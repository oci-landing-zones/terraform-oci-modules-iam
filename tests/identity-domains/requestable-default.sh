#!/usr/bin/env bash
set -euo pipefail

repository_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
module_dir="$repository_dir/identity-domains"
fixture_dir=$(mktemp -d "${TMPDIR:-/tmp}/requestable-default.XXXXXX")
trap 'rm -rf "$fixture_dir"' EXIT

ln -s "$module_dir/variables.tf" "$fixture_dir/variables.tf"

evaluate_requestable() {
  local group_definition=$1

  terraform -chdir="$fixture_dir" console -no-color \
    -var='tenancy_ocid=ocid1.tenancy.oc1..contracttest' \
    -var="identity_domain_groups_configuration={ default_identity_domain_id = \"ocid1.domain.oc1..contracttest\", groups = { TEST = $group_definition } }" \
    <<<'var.identity_domain_groups_configuration.groups["TEST"].requestable'
}

assert_requestable() {
  local name=$1
  local expected=$2
  local group_definition=$3
  local actual

  actual=$(evaluate_requestable "$group_definition")
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: $name expected $expected, got $actual" >&2
    return 1
  fi
  echo "PASS: $name"
}

assert_requestable omitted false '{ name = "test" }'
assert_requestable explicit_null false '{ name = "test", requestable = null }'
assert_requestable explicit_false false '{ name = "test", requestable = false }'
assert_requestable explicit_true true '{ name = "test", requestable = true }'
