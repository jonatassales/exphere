#!/bin/sh
set -eu

test_source=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
test_area=$(mktemp -d "${TMPDIR:-/tmp}/exphere-hooks.XXXXXX")
trap 'rm -rf "$test_area"' EXIT
trap 'exit 130' INT TERM
# Hooks may export repository-local Git variables; fixtures must not inherit them.
for test_git_env in $(git rev-parse --local-env-vars); do unset "$test_git_env"; done
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
export GIT_AUTHOR_NAME='Exphere hook fixture' GIT_COMMITTER_NAME='Exphere hook fixture'
export GIT_AUTHOR_EMAIL='fixture@example.invalid' GIT_COMMITTER_EMAIL='fixture@example.invalid'
unset HUSKY CI NODE_ENV npm_config_production npm_config_omit
export XDG_CONFIG_HOME="$test_area/config"

expect() {
  expected=$1
  shift
  actual=0
  "$@" >"$test_area/output" 2>&1 || actual=$?
  if [ "$actual" -ne "$expected" ]; then
    cat "$test_area/output"
    printf 'FAIL: expected exit %s, received %s: %s\n' "$expected" "$actual" "$*" >&2
    exit 1
  fi
}

contains() {
  if ! grep -Fq "$1" "$test_area/output"; then
    cat "$test_area/output"
    printf 'FAIL: missing output: %s\n' "$1" >&2
    exit 1
  fi
}

fixture() {
  test_repo=$(mktemp -d "$test_area/repo.XXXXXX")
  cd "$test_repo"
  git init -q --initial-branch=main
  cp -R "$test_source/scripts" .
  if [ -d "$test_source/.husky" ]; then cp -R "$test_source/.husky" .; fi
  cp "$test_source/commitlint.config.js" .
  for config in biome.json .lintstagedrc.json; do
    if [ -f "$test_source/$config" ]; then cp "$test_source/$config" .; fi
  done
  printf '{"name":"hook-fixture","private":true}\n' >package.json
  printf 'node_modules\n' >.gitignore
  printf 'verifyDepsBeforeRun: false\n' >pnpm-workspace.yaml
  ln -s "$test_source/node_modules" node_modules
}

installation() {
  fixture
  expect 0 sh scripts/hooks/install.sh
  contains 'hooks activated'
  [ "$(git config --local core.hooksPath)" = '.husky/_' ]
  expect 0 sh scripts/hooks/install.sh
  printf 'feat: valid message\n' >"$test_area/message"
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  printf 'not conventional\n' >"$test_area/message"
  expect 1 sh .husky/_/commit-msg "$test_area/message"
  contains 'subject-empty'
  for skip_mode in HUSKY=0 CI=true NODE_ENV=production npm_config_production=true npm_config_omit=dev; do
    expect 0 env "$skip_mode" sh scripts/hooks/install.sh
    contains 'hook activation skipped'
  done
  git config core.hooksPath custom-hooks
  expect 1 sh scripts/hooks/install.sh
  contains 'existing hooks path conflicts'
  [ "$(git config core.hooksPath)" = custom-hooks ]
  git config --unset core.hooksPath
  rm node_modules
  expect 1 sh scripts/hooks/install.sh
  contains 'Husky is missing'
  ln -s "$test_source/node_modules" node_modules
  mkdir -p packages/cli/cli .checks
  printf '#!/bin/sh\nprintf "%%s\\n" "$*" >>.checks/setup\n' >packages/cli/cli/ex.sh
  expect 0 sh scripts/postinstall.sh
  [ "$(cat .checks/setup)" = setup ]
  contains 'hooks activated'
  expect 0 env EXPHERE_SKIP_USER_SETUP=1 sh scripts/postinstall.sh
  [ "$(wc -l <.checks/setup | tr -d ' ')" = 1 ]
  git add .
  git -c core.hooksPath=/dev/null commit -qm 'chore: fixture'
  git worktree add -q --detach "$test_repo-linked" HEAD
  cd "$test_repo-linked"
  ln -s "$test_source/node_modules" node_modules
  expect 0 sh scripts/hooks/install.sh
  contains 'hooks activated'
  cd "$test_area"
  mkdir archive
  cp -R "$test_source/scripts" archive/
  cd archive
  expect 0 sh scripts/hooks/install.sh
  contains 'no Git worktree'
  [ ! -e .git ]
  printf '{"name":"lifecycle-fixture","private":true,"scripts":{"postinstall":"sh scripts/postinstall.sh"}}\n' >package.json
  expect 0 pnpm install --offline --ignore-scripts --store-dir "$test_area/store"
  [ ! -e .husky/_ ]
  printf 'PASS: installation, lifecycle skips, preserved setup, worktree, and Conventional Commits\n' 
}

staged() {
  fixture
  git add .
  git -c core.hooksPath=/dev/null commit -qm 'chore: fixture'
  expect 0 sh scripts/hooks/install.sh
  printf 'export const value = 1;\n' >'staged file.js'
  git add 'staged file.js'
  printf 'export const unstaged=2\n' >>'staged file.js'
  before_worktree=$(git hash-object 'staged file.js')
  before_index=$(git rev-parse ':staged file.js')
  expect 0 sh .husky/_/pre-commit
  [ "$(git hash-object 'staged file.js')" = "$before_worktree" ]
  [ "$(git rev-parse ':staged file.js')" = "$before_index" ]
  git add 'staged file.js'
  expect 1 sh .husky/_/pre-commit
  contains 'staged checks failed'
  git reset -q HEAD -- 'staged file.js'
  rm 'staged file.js'
  printf 'Documentation only.\n' >notes.md
  git add notes.md
  expect 0 sh .husky/_/pre-commit
  contains 'could not find any staged files matching'
  git -c core.hooksPath=/dev/null commit -qm 'docs: fixture'
  git rm -q notes.md
  expect 0 sh .husky/_/pre-commit
  contains 'could not find any staged files'
  # Remove only the fixture symlink, retaining the real installed tools.
  rm node_modules
  mkdir -p node_modules/.bin
  printf '#!/bin/sh\nexec "%s/node_modules/.bin/lint-staged" "$@"\n' "$test_source" >node_modules/.bin/lint-staged
  chmod +x node_modules/.bin/lint-staged
  expect 1 sh scripts/harness-score.sh
  contains 'harness-score is unavailable'
  expect 0 sh .husky/_/pre-commit
  contains 'harness score unavailable'
  printf 'PASS: staged boundaries, lint failure, deletions, no matches, and unavailable scanner\n' 
}

push_gate() {
  fixture
  printf '.checks/\n' >>.gitignore
  mkdir .checks
  cat >fixture-check.sh <<'EOF'
#!/bin/sh
printf '%s\n' "$1" >>.checks/order
[ ! -f ".checks/fail-$1" ]
EOF
  printf '{"name":"push-fixture","private":true,"scripts":{"build":"sh fixture-check.sh build","test":"sh fixture-check.sh test"}}\n' >package.json
  git add .
  git -c core.hooksPath=/dev/null commit -qm 'chore: fixture'
  git init --bare -q "$test_repo-remote"
  git remote add origin "$test_repo-remote"
  expect 0 sh scripts/hooks/install.sh
  touch .checks/fail-build
  expect 1 git push origin main
  [ "$(cat .checks/order)" = build ]
  rm .checks/fail-build .checks/order
  touch .checks/fail-test
  expect 1 git push origin main
  [ "$(cat .checks/order)" = "$(printf 'build\ntest')" ]
  rm .checks/fail-test .checks/order
  expect 0 git push origin main
  [ "$(cat .checks/order)" = "$(printf 'build\ntest')" ]
  [ "$(git --git-dir="$test_repo-remote" rev-parse refs/heads/main)" = "$(git rev-parse HEAD)" ]
  contains 'PR-to-spec verification unavailable'
  # Deletion-only updates do not run quality commands.
  rm .checks/order
  expect 0 git push origin :main
  [ ! -e .checks/order ]
  contains 'no outgoing source build required'
  expect 0 git push origin main
  git tag fixture-tag
  expect 0 git push origin fixture-tag
  contains 'tag update'
  git branch second
  expect 0 git push origin main second
  printf '# dirty\n' >>fixture-check.sh
  git branch dirty
  expect 1 git push origin dirty
  contains 'tracked source is dirty'
  git checkout -- fixture-check.sh
  previous=$(git rev-parse HEAD)
  printf '# next revision\n' >>fixture-check.sh
  git add fixture-check.sh
  git -c core.hooksPath=/dev/null commit -qm 'chore: next fixture'
  expect 1 git push origin "$previous:refs/heads/old-source"
  contains 'outgoing source differs'
  expect 0 git push origin main
  git reset --hard -q "$previous"
  # Inspect a non-fast-forward ref update without performing a force push.
  printf 'refs/heads/main %s refs/heads/main %s\n' "$previous" "$(git rev-parse refs/remotes/origin/main)" >"$test_area/non-fast-forward"
  expect 0 sh .husky/_/pre-push origin "$test_repo-remote" <"$test_area/non-fast-forward"
  contains 'inspecting refs/heads/main' 
  # A missing test command must fail instead of becoming an empty success.
  printf '{"name":"push-fixture","private":true,"scripts":{"build":"sh fixture-check.sh build"}}\n' >package.json
  git add package.json
  git -c core.hooksPath=/dev/null commit -qm 'chore: missing test fixture'
  expect 1 git push origin HEAD:refs/heads/missing-test
  printf 'PASS: push quality gates, missing command, deletion, tags, multiple refs, non-fast-forward inspection, and revision scope\n' 
}

traceability() {
  fixture
  expect 0 sh scripts/hooks/install.sh
  printf 'feat: fixture\n' >"$test_area/message"
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  contains 'SDD WARN'
  contains 'exactly one Ticket'
  mkdir -p .exphere/artifacts/tickets .exphere/artifacts/specs
  printf '# TEST-01: Fixture ticket\n\n**Spec:** [SPEC-TEST v1](../specs/0099-SPEC-test.spec.md).\n' >.exphere/artifacts/tickets/0098-TICKET-test.ticket.md
  printf '# Fixture spec\n\n- ID: `SPEC-TEST`\n' >.exphere/artifacts/specs/0099-SPEC-test.spec.md
  printf 'feat: fixture\n\nTicket: TEST-01\n' >"$test_area/message"
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  contains 'ticket TEST-01 resolves to 0 artifacts'
  git add .exphere/artifacts
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  contains 'TEST-01 -> SPEC-TEST'
  printf '# Changed only in working tree\n' >.exphere/artifacts/tickets/0098-TICKET-test.ticket.md
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  contains 'TEST-01 -> SPEC-TEST'
  printf 'Ticket: TEST-02\n' >>"$test_area/message"
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  contains 'exactly one Ticket'
  printf 'feat: fixture\n\nTicket: TEST-01\n' >"$test_area/message"
  git checkout -- .exphere/artifacts/tickets/0098-TICKET-test.ticket.md
  cp .exphere/artifacts/tickets/0098-TICKET-test.ticket.md .exphere/artifacts/tickets/0100-TICKET-duplicate.ticket.md
  git add .exphere/artifacts
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  contains 'resolves to 2 artifacts'
  git rm -fq .exphere/artifacts/tickets/0100-TICKET-duplicate.ticket.md
  printf '\n**Spec:** [SPEC-OTHER v1](other.md).\n' >>.exphere/artifacts/tickets/0098-TICKET-test.ticket.md
  git add .exphere/artifacts/tickets/0098-TICKET-test.ticket.md
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  contains 'must declare one parent Spec'
  printf '# TEST-01: Fixture ticket\n\n**Spec:** [SPEC-TEST v1](../specs/0099-SPEC-test.spec.md).\n' >.exphere/artifacts/tickets/0098-TICKET-test.ticket.md
  git add .exphere/artifacts/tickets/0098-TICKET-test.ticket.md
  cp .exphere/artifacts/specs/0099-SPEC-test.spec.md .exphere/artifacts/specs/0100-SPEC-duplicate.spec.md
  git add .exphere/artifacts/specs/0100-SPEC-duplicate.spec.md
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  contains 'parent spec SPEC-TEST resolves to 2 artifacts'
  git rm -fq .exphere/artifacts/specs/0100-SPEC-duplicate.spec.md
  git rm --cached -q .exphere/artifacts/specs/0099-SPEC-test.spec.md
  expect 0 sh .husky/_/commit-msg "$test_area/message"
  contains 'parent spec SPEC-TEST resolves to 0 artifacts'
  git add .
  git -c core.hooksPath=/dev/null commit -qm "$(cat "$test_area/message")"
  first=$(git rev-parse HEAD)
  printf '# Working-tree artifact is not evidence\n' >.exphere/artifacts/tickets/0098-TICKET-test.ticket.md
  zero=0000000000000000000000000000000000000000
  printf 'refs/heads/main %s refs/heads/main %s\n' "$first" "$zero" >"$test_area/updates"
  expect 0 sh scripts/hooks/sdd.sh push origin "$test_area/updates"
  contains "$first: TEST-01 -> SPEC-TEST"
  contains 'PR-to-spec verification unavailable'
  git checkout -- .exphere/artifacts/tickets/0098-TICKET-test.ticket.md
  printf '# TEST-02: Another ticket\n\n- Spec: [SPEC-OTHER v1](../specs/0100-SPEC-other.spec.md).\n' >.exphere/artifacts/tickets/0100-TICKET-other.ticket.md
  printf '# Another spec\n\n- ID: `SPEC-OTHER`\n' >.exphere/artifacts/specs/0100-SPEC-other.spec.md
  git add .exphere/artifacts
  git -c core.hooksPath=/dev/null commit -qm "$(printf 'feat: next fixture\n\nTicket: TEST-02')"
  second=$(git rev-parse HEAD)
  printf 'refs/heads/main %s refs/heads/main %s\nrefs/heads/other %s refs/heads/other %s\n' "$second" "$zero" "$second" "$zero" >"$test_area/updates"
  expect 0 sh scripts/hooks/sdd.sh push origin "$test_area/updates"
  contains 'outgoing associations span multiple specs'
  [ "$(grep -c 'identity only' "$test_area/output")" = 2 ]
  printf 'refs/heads/main %s refs/heads/main %s\n' "$second" "$first" >"$test_area/updates"
  expect 0 sh scripts/hooks/sdd.sh push origin "$test_area/updates"
  [ "$(grep -c 'identity only' "$test_area/output")" = 1 ]
  printf 'refs/heads/main %s refs/heads/main %s\n' "$second" 1111111111111111111111111111111111111111 >"$test_area/updates"
  expect 0 sh scripts/hooks/sdd.sh push origin "$test_area/updates"
  contains 'remote base unavailable'
  git clone -q --depth=1 "file://$test_repo" "$test_repo-shallow"
  cd "$test_repo-shallow"
  expect 0 sh scripts/hooks/sdd.sh push origin "$test_area/updates"
  contains 'shallow history'
  printf 'PASS: advisory SDD, index/tree identities, duplicates, outgoing ranges, deduplication, and coverage warnings\n' 
}

layout_traceability() {
  fixture
  mkdir -p .exphere/artifacts/tickets .exphere/artifacts/specs
  printf '# LAYOUT-01: Moved ticket\n\n**Spec:** [SPEC-LAYOUT v1](../specs/0099-SPEC-layout.spec.md).\n' >.exphere/artifacts/tickets/0098-TICKET-layout.ticket.md
  printf '# Layout spec\n\n- ID: `SPEC-LAYOUT`\n' >.exphere/artifacts/specs/0099-SPEC-layout.spec.md
  printf 'feat: layout fixture\n\nTicket: LAYOUT-01\n' >"$test_area/message"
  expect 0 sh scripts/hooks/sdd.sh commit "$test_area/message"
  contains 'ticket LAYOUT-01 resolves to 0 artifacts'
  git add .exphere/artifacts
  expect 0 sh scripts/hooks/sdd.sh commit "$test_area/message"
  contains 'LAYOUT-01 -> SPEC-LAYOUT'
  # A duplicate present only in the working tree is not index evidence.
  mkdir -p .artifacts/tickets
  cp .exphere/artifacts/tickets/0098-TICKET-layout.ticket.md .artifacts/tickets/0098-TICKET-layout.ticket.md
  expect 0 sh scripts/hooks/sdd.sh commit "$test_area/message"
  contains 'LAYOUT-01 -> SPEC-LAYOUT'
  rm .artifacts/tickets/0098-TICKET-layout.ticket.md
  # An unstaged spec edit cannot invalidate the staged relationship either.
  printf '# Unstaged spec is not evidence\n' >.exphere/artifacts/specs/0099-SPEC-layout.spec.md
  expect 0 sh scripts/hooks/sdd.sh commit "$test_area/message"
  contains 'LAYOUT-01 -> SPEC-LAYOUT'
  git checkout -- .exphere/artifacts/specs/0099-SPEC-layout.spec.md
  printf '# Unstaged identity is not evidence\n' >.exphere/artifacts/tickets/0098-TICKET-layout.ticket.md
  expect 0 sh scripts/hooks/sdd.sh commit "$test_area/message"
  contains 'LAYOUT-01 -> SPEC-LAYOUT'
  git checkout -- .exphere/artifacts/tickets/0098-TICKET-layout.ticket.md

  # Identical blobs at different paths still represent duplicate artifacts.
  mkdir -p .artifacts/tickets .artifacts/specs
  cp .exphere/artifacts/tickets/0098-TICKET-layout.ticket.md .artifacts/tickets/0098-TICKET-layout.ticket.md
  git add .artifacts
  expect 0 sh scripts/hooks/sdd.sh commit "$test_area/message"
  contains 'ticket LAYOUT-01 resolves to 2 artifacts'
  git rm -fq .artifacts/tickets/0098-TICKET-layout.ticket.md
  cp .exphere/artifacts/specs/0099-SPEC-layout.spec.md .artifacts/specs/0099-SPEC-layout.spec.md
  git add .artifacts
  expect 0 sh scripts/hooks/sdd.sh commit "$test_area/message"
  contains 'parent spec SPEC-LAYOUT resolves to 2 artifacts'
  git rm -fq .artifacts/specs/0099-SPEC-layout.spec.md

  # Build pre-move and post-move commits, then assess their own trees together.
  rmdir .artifacts/tickets .artifacts/specs .artifacts 2>/dev/null || :
  git mv .exphere/artifacts .artifacts
  git add scripts .gitignore
  git -c core.hooksPath=/dev/null commit -qm "$(cat "$test_area/message")"
  layout_legacy=$(git rev-parse HEAD)
  expect 0 sh scripts/hooks/sdd.sh commit "$test_area/message"
  contains 'LAYOUT-01 -> SPEC-LAYOUT'
  mkdir -p .exphere/artifacts
  git mv .artifacts/tickets .exphere/artifacts/tickets
  printf '# LAYOUT-01: Moved ticket\n\n**Spec:** [SPEC-LAYOUT v1](../../../.artifacts/specs/0099-SPEC-layout.spec.md).\n' >.exphere/artifacts/tickets/0098-TICKET-layout.ticket.md
  git add .exphere/artifacts/tickets
  git -c core.hooksPath=/dev/null commit -qm "$(cat "$test_area/message")"
  layout_partial=$(git rev-parse HEAD)
  git mv .artifacts/specs .exphere/artifacts/specs
  printf '# LAYOUT-01: Moved ticket\n\n**Spec:** [SPEC-LAYOUT v1](../specs/0099-SPEC-layout.spec.md).\n' >.exphere/artifacts/tickets/0098-TICKET-layout.ticket.md
  git add .exphere/artifacts/tickets
  git -c core.hooksPath=/dev/null commit -qm "$(cat "$test_area/message")"
  layout_current=$(git rev-parse HEAD)
  printf '# Working tree cannot repair either commit\n' >.exphere/artifacts/tickets/0098-TICKET-layout.ticket.md
  printf 'refs/heads/main %s refs/heads/main 0000000000000000000000000000000000000000\n' "$layout_current" >"$test_area/updates"
  expect 0 sh scripts/hooks/sdd.sh push origin "$test_area/updates"
  contains "$layout_legacy: LAYOUT-01 -> SPEC-LAYOUT"
  contains "$layout_partial: LAYOUT-01 -> SPEC-LAYOUT"
  contains "$layout_current: LAYOUT-01 -> SPEC-LAYOUT"
  [ "$(grep -c 'identity only' "$test_area/output")" = 3 ]
  # A later clean tree must not hide ambiguity in an earlier commit.
  git checkout -- .exphere/artifacts/tickets/0098-TICKET-layout.ticket.md
  mkdir -p .artifacts/tickets .artifacts/specs
  cp .exphere/artifacts/tickets/0098-TICKET-layout.ticket.md .artifacts/tickets/
  git add .artifacts
  git -c core.hooksPath=/dev/null commit -qm "$(cat "$test_area/message")"
  layout_duplicate_ticket=$(git rev-parse HEAD)
  git rm -q .artifacts/tickets/0098-TICKET-layout.ticket.md
  cp .exphere/artifacts/specs/0099-SPEC-layout.spec.md .artifacts/specs/
  git add .artifacts
  git -c core.hooksPath=/dev/null commit -qm "$(cat "$test_area/message")"
  layout_duplicate_spec=$(git rev-parse HEAD)
  git rm -q .artifacts/specs/0099-SPEC-layout.spec.md
  git -c core.hooksPath=/dev/null commit -qm "$(cat "$test_area/message")"
  layout_repaired=$(git rev-parse HEAD)
  printf 'refs/heads/main %s refs/heads/main %s\n' "$layout_repaired" "$layout_current" >"$test_area/updates"
  expect 0 sh scripts/hooks/sdd.sh push origin "$test_area/updates"
  contains "$layout_duplicate_ticket: ticket LAYOUT-01 resolves to 2 artifacts"
  contains "$layout_duplicate_spec: parent spec SPEC-LAYOUT resolves to 2 artifacts"
  contains "$layout_repaired: LAYOUT-01 -> SPEC-LAYOUT"
  [ "$(grep -c 'identity only' "$test_area/output")" = 1 ]
  printf 'PASS: canonical index, legacy and mixed commit trees, cross-root duplicates, and later repairs cannot alter history\n'
}

deletion_without_head() {
  fixture
  expect 0 sh scripts/hooks/install.sh
  printf '(delete) 0000000000000000000000000000000000000000 refs/heads/obsolete 1111111111111111111111111111111111111111\n' >"$test_area/deletion"
  expect 0 sh .husky/_/pre-push origin unused-local-remote <"$test_area/deletion"
  contains 'no outgoing source build required'
  printf 'PASS: deletion-only hook input works without a HEAD commit\n'
}

case "${1:-all}" in
  installation) installation ;;
  staged) staged ;;
  push) push_gate ;;
  sdd) traceability ;;
  layout) layout_traceability ;;
  unborn) deletion_without_head ;;
  all) installation; staged; push_gate; traceability; layout_traceability; deletion_without_head ;;
  *) printf 'Unknown hook test group: %s\n' "$1" >&2; exit 2 ;;
esac
