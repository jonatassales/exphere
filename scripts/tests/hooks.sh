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
  mkdir -p packages/exphere/cli .checks
  printf '#!/bin/sh\nprintf "%%s\\n" "$*" >>.checks/setup\n' >packages/exphere/cli/ex.sh
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

case "${1:-all}" in
  installation) installation ;;
  staged) staged ;;
  all) installation; staged ;;
  *) printf 'Unknown hook test group: %s\n' "$1" >&2; exit 2 ;;
esac
