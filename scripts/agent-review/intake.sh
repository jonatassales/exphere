#!/bin/sh
set -eu
adapter=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$adapter/common.sh"
read_event
eligibility
[ -z "$skip_reason" ] || exit 0
# Only object data is fetched. HEAD and all executable files stay at the trusted revision.
# The header lives in the process environment, never in Git config or command arguments.
GIT_CONFIG_COUNT=1
GIT_CONFIG_KEY_0=http.https://github.com/.extraheader
GIT_CONFIG_VALUE_0="AUTHORIZATION: basic $(printf 'x-access-token:%s' "$GH_TOKEN" | base64 | tr -d '\n')"
export GIT_CONFIG_COUNT GIT_CONFIG_KEY_0 GIT_CONFIG_VALUE_0
git fetch --no-tags --no-recurse-submodules origin "$base" "$head"
