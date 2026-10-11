#!/bin/sh
set -eu

package_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd -P)
cli_entry="$package_dir/cli/ex.sh"
test_area=$(mktemp -d "${TMPDIR:-/tmp}/exphere-cli-contract.XXXXXX")
trap 'rm -rf "$test_area"' EXIT HUP INT TERM

fail() {
  printf 'CLI contract failed: %s\n' "$1" >&2
  exit 1
}

# These public commands must work from outside the package's directory.
cd "$test_area"
actual_version=$(sh "$cli_entry" --version)
[ "$actual_version" = 'ex 0.0.0' ] || fail 'CLI version differs from its package version.'
sh "$cli_entry" --help >help.out
grep -Fq 'runtime <id> init' help.out || fail 'CLI help lost the microruntime entry point.'
printf 'CLI contract: version and help passed.\n'

fixture() {
  fixture_root=$(mktemp -d "$test_area/checkout.XXXXXX")
  fixture_root=$(CDPATH= cd "$fixture_root" && pwd -P)
  fixture_home="$fixture_root/user"
  mkdir -p "$fixture_root/packages/cli" "$fixture_home/.local/share/exphere/bin"
  cp -R "$package_dir/cli" "$fixture_root/packages/cli/cli"
  cp "$package_dir/package.json" "$fixture_root/packages/cli/package.json"
  printf 'packages: [packages/*]\n' >"$fixture_root/pnpm-workspace.yaml"
  fixture_entry="$fixture_root/packages/cli/cli/ex.sh"
  fixture_bin="$fixture_home/.local/share/exphere/bin/ex"
  fixture_env="$fixture_home/.local/share/exphere/env.sh"
  legacy_entry="$fixture_root/packages/exphere/cli/ex.sh"
  legacy_env="$fixture_root/packages/exphere/cli/env.sh"
}

setup() {
  # Override only the child process environment; never change this shell's HOME.
  env HOME="$fixture_home" ZDOTDIR="$fixture_home" SHELL=/bin/bash CI= npm_lifecycle_event= "$@" \
    sh "$fixture_entry" setup >"$test_area/setup.out" 2>&1
}

fixture
ln -s "$legacy_entry" "$fixture_bin"
ln -s "$legacy_env" "$fixture_env"
rm "$fixture_root/packages/cli/cli/env.sh"
if setup; then fail 'Setup reported success with its environment asset missing.'; fi
[ "$(readlink "$fixture_bin")" = "$legacy_entry" ] || fail 'A missing environment asset changed the executable link.'
[ "$(readlink "$fixture_env")" = "$legacy_env" ] || fail 'A missing environment asset changed the environment link.'
[ ! -e "$fixture_home/.bashrc" ] && [ ! -e "$fixture_home/.profile" ] || fail 'A missing environment asset changed shell configuration.'
grep -Fq 'Environment asset must be a readable regular file:' "$test_area/setup.out" || fail 'Missing environment asset failure was not actionable.'
printf 'CLI contract: missing environment asset preserves the existing installation.\n'

fixture
ln -s "$legacy_entry" "$fixture_bin"
ln -s "$legacy_env" "$fixture_env"
setup || { cat "$test_area/setup.out"; fail 'Same-checkout legacy setup was rejected.'; }
[ "$(readlink "$fixture_bin")" = "$fixture_entry" ] || fail 'The legacy executable link was not migrated.'
[ "$(readlink "$fixture_env")" = "$fixture_root/packages/cli/cli/env.sh" ] || fail 'The legacy environment link was not migrated.'
[ "$("$fixture_bin" --version)" = 'ex 0.0.0' ] || fail 'The migrated command does not execute.'
printf 'CLI contract: same-checkout legacy installation migrated.\n'

fixture
ln -s "$legacy_entry" "$fixture_bin"
ln -s "$legacy_env" "$fixture_env"
mkdir "$fixture_root/fault-tools"
cat >"$fixture_root/fault-tools/mv" <<'EOF'
#!/bin/sh
for argument do destination=$argument; done
if [ "$destination" = "$EX_TEST_FAILURE_TARGET" ]; then
  printf 'fixture: environment link write failed\n' >&2
  if [ "${EX_TEST_INTERRUPT:-}" = 1 ]; then kill -TERM "$PPID"; fi
  exit 1
fi
exec /bin/mv "$@"
EOF
chmod +x "$fixture_root/fault-tools/mv"
if setup "PATH=$fixture_root/fault-tools:$PATH" "EX_TEST_FAILURE_TARGET=$fixture_env"; then
  fail 'A failed environment-link write was reported as success.'
fi
[ "$(readlink "$fixture_bin")" = "$legacy_entry" ] || fail 'A partial migration did not restore the executable link.'
[ "$(readlink "$fixture_env")" = "$legacy_env" ] || fail 'A partial migration changed the environment link.'
printf 'CLI contract: failed link update preserves the original installation.\n'
if setup "PATH=$fixture_root/fault-tools:$PATH" "EX_TEST_FAILURE_TARGET=$fixture_env" EX_TEST_INTERRUPT=1; then
  fail 'An interrupted setup was reported as success.'
fi
[ "$(readlink "$fixture_bin")" = "$legacy_entry" ] || fail 'Interrupted setup did not restore the executable link.'
[ "$(readlink "$fixture_env")" = "$legacy_env" ] || fail 'Interrupted setup changed the environment link.'
rm "$fixture_bin" "$fixture_env"
if setup "PATH=$fixture_root/fault-tools:$PATH" "EX_TEST_FAILURE_TARGET=$fixture_env"; then
  fail 'A partial fresh installation was reported as success.'
fi
[ ! -e "$fixture_bin" ] && [ ! -L "$fixture_bin" ] || fail 'A failed fresh setup left its executable link installed.'
[ ! -e "$fixture_env" ] && [ ! -L "$fixture_env" ] || fail 'A failed fresh setup left its environment link installed.'
printf 'CLI contract: interruption and failed fresh setup restore prior link state.\n'

fixture
setup || { cat "$test_area/setup.out"; fail 'Fresh setup failed.'; }
profile_before=$(cksum "$fixture_home/.bashrc" "$fixture_home/.profile")
setup || fail 'Repeated setup failed.'
[ "$(cksum "$fixture_home/.bashrc" "$fixture_home/.profile")" = "$profile_before" ] || fail 'Repeated setup changed shell configuration.'
activated=$(env HOME="$fixture_home" PATH=/usr/bin:/bin sh -c '
  . "$HOME/.local/share/exphere/env.sh"
  first_path=$PATH
  . "$HOME/.local/share/exphere/env.sh"
  [ "$PATH" = "$first_path" ] || exit 1
  command -v ex
') || fail 'Environment activation is not repeatable.'
[ "$activated" = "$fixture_bin" ] || fail 'Environment activation selects another command.'
printf 'CLI contract: fresh setup and repeated shell activation passed.\n'

for conflict in file dangling other-checkout relative-lookalike; do
  fixture
  ln -s "$legacy_entry" "$fixture_bin"
  case "$conflict" in
    file) printf 'consumer-owned\n' >"$fixture_env" ;;
    dangling) ln -s "$fixture_root/missing/env.sh" "$fixture_env" ;;
    other-checkout) ln -s "$test_area/another/packages/exphere/cli/env.sh" "$fixture_env" ;;
    relative-lookalike) ln -s "$fixture_root/packages/cli/../exphere/cli/env.sh" "$fixture_env" ;;
  esac
  if setup; then fail "Setup accepted the $conflict environment conflict."; fi
  [ "$(readlink "$fixture_bin")" = "$legacy_entry" ] || fail 'Conflict checking modified the executable first.'
  if [ "$conflict" = file ]; then
    [ "$(cat "$fixture_env")" = consumer-owned ] || fail 'Setup overwrote a consumer file.'
  else
    [ -L "$fixture_env" ] || fail 'Setup removed a conflicting symbolic link.'
  fi
  [ ! -e "$fixture_home/.bashrc" ] || fail 'A refused setup changed shell configuration.'
done
fixture
printf 'consumer-command\n' >"$fixture_bin"
ln -s "$legacy_env" "$fixture_env"
if setup; then fail 'Setup overwrote an ordinary executable file.'; fi
[ "$(cat "$fixture_bin")" = consumer-command ] || fail 'An ordinary executable was changed.'
[ "$(readlink "$fixture_env")" = "$legacy_env" ] || fail 'An executable conflict modified the environment link.'
printf 'CLI contract: unrelated files and links remain unchanged.\n'

fixture
mkdir -p "$legacy_entry"
ln -s "$legacy_entry" "$fixture_bin"
ln -s "$legacy_env" "$fixture_env"
if setup; then fail 'Setup accepted a legacy executable that resolves to a directory.'; fi
[ "$(readlink "$fixture_bin")" = "$legacy_entry" ] || fail 'A directory conflict changed the executable link.'
[ "$(readlink "$fixture_env")" = "$legacy_env" ] || fail 'A directory conflict changed the environment link.'
[ -z "$(ls -A "$legacy_entry")" ] || fail 'Setup wrote through the legacy directory link.'
printf 'CLI contract: directory targets are rejected without following links.\n'

fixture
setup CI=true npm_lifecycle_event=postinstall || fail 'CI installation skip failed.'
[ ! -e "$fixture_bin" ] && [ ! -L "$fixture_bin" ] || fail 'CI setup created an executable link.'
[ ! -e "$fixture_home/.bashrc" ] || fail 'CI setup changed shell configuration.'
printf 'CLI contract: CI installation leaves user setup untouched.\n'

# A relocated package must report its own version without an SDK next to it.
jq '.version = "0.0.7"' "$fixture_root/packages/cli/package.json" >"$test_area/cli-manifest.json"
mv "$test_area/cli-manifest.json" "$fixture_root/packages/cli/package.json"
[ "$(sh "$fixture_entry" --version)" = 'ex 0.0.7' ] || fail 'CLI version does not follow its own manifest.'
consumer="$fixture_root/consumer"
mkdir "$consumer"
sh "$fixture_entry" --root "$consumer" runtime billing init --legacy >"$test_area/runtime.out"
sh "$fixture_entry" --root "$consumer" runtime billing validate >>"$test_area/runtime.out"
sh "$fixture_entry" --root "$consumer" runtime list >"$test_area/list.out"
grep -Fq 'billing' "$test_area/list.out" && grep -Fq 'v1' "$test_area/list.out" && grep -Fq '.micro-runtime/billing/schema.json' "$test_area/list.out" || fail 'Microruntime discovery omitted legacy identity or location after relocation.'
before_descriptor=$(cksum "$consumer/.micro-runtime/billing/schema.json")
if sh "$fixture_entry" --root "$consumer" runtime billing init >>"$test_area/runtime.out" 2>&1; then
  fail 'Microruntime initialization overwrote an existing descriptor.'
fi
[ "$(cksum "$consumer/.micro-runtime/billing/schema.json")" = "$before_descriptor" ] || fail 'A repeated initialization changed the descriptor.'
jq '.id = "another"' "$consumer/.micro-runtime/billing/schema.json" >"$test_area/descriptor.json"
mv "$test_area/descriptor.json" "$consumer/.micro-runtime/billing/schema.json"
if sh "$fixture_entry" --root "$consumer" runtime billing validate >>"$test_area/runtime.out" 2>&1; then
  fail 'Validation accepted a descriptor belonging to another microruntime.'
fi
printf 'CLI contract: relocated package version and consumer descriptors passed.\n'

runtime_dir="$consumer/.micro-runtime/billing"
mkdir "$runtime_dir/terraform" "$runtime_dir/manifests" "$runtime_dir/hooks" "$fixture_root/tools"
cat >"$runtime_dir/hooks/prepare.sh" <<'EOF'
#!/bin/sh
printf '%s\n' "$EX_RUNTIME_ID" "$PWD" "$1"
EOF
jq '.id = "billing" | .terraform = {directory: "terraform"} | .kubernetes = {context: "fixture-context", namespace: "billing", manifests: "manifests"} | .hooks = {prepare: "hooks/prepare.sh"}' \
  "$runtime_dir/schema.json" >"$test_area/descriptor.json"
mv "$test_area/descriptor.json" "$runtime_dir/schema.json"
sh "$fixture_entry" --root "$consumer" runtime billing run prepare -- 'a spaced value' >"$test_area/hook.out"
printf 'billing\n%s\na spaced value\n' "$runtime_dir" >"$test_area/hook.expected"
cmp -s "$test_area/hook.out" "$test_area/hook.expected" || fail 'Consumer hook context or argument forwarding changed.'
cat >"$fixture_root/tools/terraform" <<'EOF'
#!/bin/sh
printf '%s\n' "$@"
exit 2
EOF
cat >"$fixture_root/tools/kubectl" <<'EOF'
#!/bin/sh
printf '%s\n' "$@"
exit 1
EOF
chmod +x "$fixture_root/tools/terraform" "$fixture_root/tools/kubectl"
adapter_status=0
env PATH="$fixture_root/tools:$PATH" sh "$fixture_entry" --root "$consumer" runtime billing terraform plan -- -detailed-exitcode >"$test_area/terraform.out" || adapter_status=$?
[ "$adapter_status" -eq 2 ] || fail 'Terraform adapter lost the native exit code.'
printf '%s\n' "-chdir=$runtime_dir/terraform" plan -detailed-exitcode >"$test_area/terraform.expected"
cmp -s "$test_area/terraform.out" "$test_area/terraform.expected" || fail 'Terraform adapter argument forwarding changed.'
adapter_status=0
env PATH="$fixture_root/tools:$PATH" sh "$fixture_entry" --root "$consumer" runtime billing kubernetes diff >"$test_area/kubernetes.out" || adapter_status=$?
[ "$adapter_status" -eq 1 ] || fail 'Kubernetes adapter lost the native exit code.'
printf '%s\n' --context=fixture-context --namespace=billing diff --filename "$runtime_dir/manifests" >"$test_area/kubernetes.expected"
cmp -s "$test_area/kubernetes.out" "$test_area/kubernetes.expected" || fail 'Kubernetes adapter arguments changed.'
printf 'CLI contract: consumer hooks and controlled external adapters passed.\n'

sh "$package_dir/scripts/test-configuration.sh"
sh "$package_dir/scripts/test-guided-configuration.sh"
