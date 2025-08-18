# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  cis_iam12_regex = ".*to\\s*manage\\s*all-resources\\s*in\\s*tenancy\\s*$"

  cis_iam13_main_final_regex    = ".*to\\s*(manage|use)\\s*(users|groups)\\s*in\\s*tenancy\\s*$"
  cis_iam13_main_nonfinal_regex = ".*to\\s*(manage|use)\\s*(users|groups)\\s*in\\s*tenancy.*"
  cis_iam13_tenancy_admin_regex = ".*(\\s.*all\\s.*).*(target.group.name\\s*!=\\s*'Administrators').*"
  cis_iam13_non_admin_regex     = ".*(target.group.name\\s*=\\s*'[^Administrator]').*"
  cis_iam13_operations_regex    = ".*(request.operation|request.permission)\\s*=\\s*('AddUserToGroup'|'RemoveUserFromGroup'|'UpdateGroup'|'DeleteGroup'|'GROUP_UPDATE'|'GROUP_DELETE').*"

  template_root_policies = local.enable_tenancy_level_template_policies ? merge(local.root_cmp_admin_policy, local.root_cmp_nonadmin_policy, local.services_policy) : {}
  template_cmp_policies = local.enable_compartment_level_template_policies ? merge(local.enclosing_cmps_policies, local.security_cmps_policies,
    local.network_cmps_policies, local.application_cmps_policies,
  local.database_cmps_policies, local.exainfra_cmps_policies) : {}

  policies = merge(local.template_root_policies, local.template_cmp_policies, local.supplied_policies)
}

resource "oci_identity_policy" "these" {
  for_each       = local.policies
  name           = each.value.name
  description    = each.value.description
  compartment_id = length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : (upper(each.value.compartment_id) == "TENANCY-ROOT" ? var.tenancy_ocid : var.compartments_dependency[each.value.compartment_id].id)
  statements     = each.value.statements
  defined_tags   = each.value.defined_tags
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags)

  ##-- The can(regex(pattern)) combination used below is a way to ask if pattern is present in each policy statement.
  ##-- Conversely, !can(regex(pattern)) asks if pattern is not present.
  lifecycle {
    precondition {
      condition     = local.enable_cis_benchmark_checks ? length([for s in each.value.statements : s if can(regex(local.cis_iam12_regex, lower(s)))]) == 0 : true
      error_message = "VALIDATION FAILURE (CIS IAM 1.2): Policy ${each.value.name} has statements that allow a group to manage any resource in the tenancy: \"${join(",", [for s in each.value.statements : s if can(regex(local.cis_iam12_regex, lower(s)))])}\""
    }
    precondition {
      condition     = local.enable_cis_benchmark_checks ? length([for s in each.value.statements : s if can(regex(local.cis_iam13_main_final_regex, lower(s)))]) == 0 : true
      error_message = "VALIDATION FAILURE (CIS IAM 1.3): Policy ${each.value.name} has statements that allow a group to change the Administrators group: \"${join(",", [for s in each.value.statements : s if can(regex(local.cis_iam13_main_final_regex, lower(s)))])}\". You can exclude Administrators group from this statement by adding \"target.group.name != 'Administrators'\" to the statement."
    }
    precondition {
      condition     = local.enable_cis_benchmark_checks ? length([for s in each.value.statements : s if can(regex(local.cis_iam13_main_nonfinal_regex, lower(s))) && can(regex(local.cis_iam13_operations_regex, s)) && !can(regex(local.cis_iam13_tenancy_admin_regex, s))]) == 0 : true
      error_message = "VALIDATION FAILURE (CIS IAM 1.3): Policy ${each.value.name} has statements that allow a group to change the Administrators group: \"${join(",", [for s in each.value.statements : s if can(regex(local.cis_iam13_main_nonfinal_regex, lower(s))) && can(regex(local.cis_iam13_operations_regex, s)) && !can(regex(local.cis_iam13_tenancy_admin_regex, s))])}\". You can exclude Administrators group from this statement by adding \"target.group.name != 'Administrators'\" to the statement."
    }
  }
}