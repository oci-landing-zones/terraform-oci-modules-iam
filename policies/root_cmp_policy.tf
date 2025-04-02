# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#--------------------------------------------------------------------------------------------
#-- Tenancy root compartment policy
#-- Notice that policy is conditioned to the existence of applicable grants 
#--------------------------------------------------------------------------------------------

locals {

  #-- Valid group roles for policies at the root compartment (tenancy) level.
  iam_role         = "iam"
  cred_role        = "cred"
  cost_role        = "cost"
  security_role    = "security"
  application_role = "application"
  network_role     = "network"
  database_role    = "database"
  exainfra_role    = "exainfra"
  auditor_role     = "auditor"
  announcement_reader_role = "announcement-reader"

  groups_with_tenancy_level_roles = local.enable_tenancy_level_template_policies == true ? var.policies_configuration.template_policies.tenancy_level_settings.groups_with_tenancy_level_roles : []

  group_name_to_role_map = {for group in local.groups_with_tenancy_level_roles : group.name => split(",", lookup(group,"roles","basic"))} # this produces objects like {"group-name-1" : ["iam", "security"]}
  group_names = join(",", compact(keys(local.group_name_to_role_map))) # this produces a comma separated string of group names, like "group-name-1, group-name-2, group-name-3"
  group_name_map_transpose = transpose(local.group_name_to_role_map) # this produces objects like {"iam" : ["group-name-1"], "security" : ["group-name-1"]}
  #group_role_to_name_map = {for key, value in local.group_name_map_transpose : key => value[0]} # this is the same transposed matrix, but it takes group name string at index 0.

  iam_group_names = contains(keys(local.group_name_map_transpose),local.iam_role) ? join(",",local.group_name_map_transpose[local.iam_role]) : null
  cred_group_names = contains(keys(local.group_name_map_transpose),local.cred_role) ? join(",",local.group_name_map_transpose[local.cred_role]) : null
  cost_group_names = contains(keys(local.group_name_map_transpose),local.cost_role) ? join(",",local.group_name_map_transpose[local.cost_role]) : null
  security_group_names = contains(keys(local.group_name_map_transpose),local.security_role) ? join(",",local.group_name_map_transpose[local.security_role]) : null
  application_group_names = contains(keys(local.group_name_map_transpose),local.application_role) ? join(",",local.group_name_map_transpose[local.application_role]) : null
  network_group_names = contains(keys(local.group_name_map_transpose),local.network_role) ? join(",",local.group_name_map_transpose[local.network_role]) : null
  database_group_names = contains(keys(local.group_name_map_transpose),local.database_role) ? join(",",local.group_name_map_transpose[local.database_role]) : null
  exainfra_group_names = contains(keys(local.group_name_map_transpose),local.exainfra_role) ? join(",",local.group_name_map_transpose[local.exainfra_role]) : null
  auditor_group_names = contains(keys(local.group_name_map_transpose),local.auditor_role) ? join(",",local.group_name_map_transpose[local.auditor_role]) : null
  announcement_reader_group_names = contains(keys(local.group_name_map_transpose),local.announcement_reader_role) ? join(",",local.group_name_map_transpose[local.announcement_reader_role]) : null

  iam_grants_condition = contains(keys(local.group_name_map_transpose),local.cred_role) ? [for g in split(",",local.cred_group_names) : substr(g,0,1) == "'" && substr(g,length(g)-1,1) == "'" ? "target.group.name != ${g}" : "target.group.name != '${g}'"] : []

  #-- Used to check if an enclosing compartment is available.
  cmp_type_list = flatten([for cmp, values in local.cmp_name_to_cislz_tag_map : split(",",values.cmp-type)])

  #-- Basic grants
  basic_grants_on_root_cmp = length(local.group_names) > 0 ? [
    "allow group ${local.group_names} to use cloud-shell in tenancy",
    "allow group ${local.group_names} to read usage-budgets in tenancy",
    "allow group ${local.group_names} to read usage-reports in tenancy",
    "allow group ${local.group_names} to read objectstorage-namespaces in tenancy",
    "allow group ${local.group_names} to read tag-namespaces in tenancy"
  ] : []

  iam_admin_grants_on_root_cmp = contains(keys(local.group_name_map_transpose),local.iam_role) ? [
    "allow group ${local.iam_group_names} to inspect users in tenancy",
    "allow group ${local.iam_group_names} to manage users in tenancy where all {request.operation != 'ListApiKeys',request.operation != 'ListAuthTokens',request.operation != 'ListCustomerSecretKeys',request.operation != 'UploadApiKey',request.operation != 'DeleteApiKey',request.operation != 'UpdateAuthToken',request.operation != 'CreateAuthToken',request.operation != 'DeleteAuthToken',request.operation != 'CreateSecretKey',request.operation != 'UpdateCustomerSecretKey',request.operation != 'DeleteCustomerSecretKey'}",
    "allow group ${local.iam_group_names} to inspect groups in tenancy",
    "allow group ${local.iam_group_names} to read policies in tenancy",
    "allow group ${local.iam_group_names} to manage groups in tenancy where all {target.group.name != 'Administrators', ${join(",",local.iam_grants_condition)}}",
    "allow group ${local.iam_group_names} to inspect identity-providers in tenancy",
    "allow group ${local.iam_group_names} to manage identity-providers in tenancy where any {request.operation = 'AddIdpGroupMapping', request.operation = 'DeleteIdpGroupMapping'}",
    "allow group ${local.iam_group_names} to manage dynamic-groups in tenancy",
    "allow group ${local.iam_group_names} to manage authentication-policies in tenancy",
    "allow group ${local.iam_group_names} to manage network-sources in tenancy",
    "allow group ${local.iam_group_names} to manage quota in tenancy",
    "allow group ${local.iam_group_names} to read audit-events in tenancy",
    "allow group ${local.iam_group_names} to manage tag-defaults in tenancy",
    "allow group ${local.iam_group_names} to manage tag-namespaces in tenancy",
    # Statements scoped to allow an IAM admin to deploy IAM resources via ORM
    "allow group ${local.iam_group_names} to manage orm-stacks in tenancy",
    "allow group ${local.iam_group_names} to manage orm-jobs in tenancy",
    "allow group ${local.iam_group_names} to manage orm-config-source-providers in tenancy"
  ] : []

  # For the case when there's no enclosing compartment defined, the grants are set in the root compartment. Analogous grants are present in enclosing_cmp_policy.tf, which are applied when an enclosing compartment is defined.
  iam_admin_grants_on_enclosing_cmp = contains(keys(local.group_name_map_transpose),local.iam_role) && !contains(local.cmp_type_list,"enclosing") ? [
    "allow group ${local.iam_group_names} to manage policies in tenancy", 
    "allow group ${local.iam_group_names} to manage compartments in tenancy"
  ] : []

  cred_admin_grants_on_root_cmp = contains(keys(local.group_name_map_transpose),local.cred_role) ? [
    "allow group ${local.cred_group_names} to inspect users in tenancy",
    "allow group ${local.cred_group_names} to inspect groups in tenancy",
    "allow group ${local.cred_group_names} to manage users in tenancy  where any {request.operation = 'ListApiKeys',request.operation = 'ListAuthTokens',request.operation = 'ListCustomerSecretKeys',request.operation = 'UploadApiKey',request.operation = 'DeleteApiKey',request.operation = 'UpdateAuthToken',request.operation = 'CreateAuthToken',request.operation = 'DeleteAuthToken',request.operation = 'CreateSecretKey',request.operation = 'UpdateCustomerSecretKey',request.operation = 'DeleteCustomerSecretKey',request.operation = 'UpdateUserCapabilities'}"
  ] : [] 

  cost_admin_grants_on_root_cmp = contains(keys(local.group_name_map_transpose),local.cost_role) ? [
    "define tenancy usage-report as ocid1.tenancy.oc1..aaaaaaaaned4fkpkisbwjlr56u7cj63lf3wffbilvqknstgtvzub7vhqkggq", 
    "endorse group ${local.cost_group_names} to read objects in tenancy usage-report",
    "allow group ${local.cost_group_names} to manage usage-report in tenancy",
    "allow group ${local.cost_group_names} to manage usage-budgets in tenancy"
  ] : []

  security_admin_grants_on_root_cmp = contains(keys(local.group_name_map_transpose),local.security_role) ? [
    "allow group ${local.security_group_names} to manage cloudevents-rules in tenancy",
    "allow group ${local.security_group_names} to manage cloud-guard-family in tenancy",
    "allow group ${local.security_group_names} to read tenancies in tenancy",
    "allow group ${local.security_group_names} to manage zpr-configuration in tenancy",
    "allow group ${local.security_group_names} to manage zpr-policy in tenancy",
    "allow group ${local.security_group_names} to manage security-attribute-namespace in tenancy"
    #"allow group ${local.security_group_names} to read objectstorage-namespaces in tenancy"
  ] : []

  network_admin_grants_on_root_cmp = contains(keys(local.group_name_map_transpose),local.network_role) ? [
    "allow group ${local.network_group_names} to read zpr-configuration in tenancy",
    "allow group ${local.network_group_names} to read zpr-policy in tenancy",
    "allow group ${local.network_group_names} to read security-attribute-namespace in tenancy"
  ] : []

  application_admin_grants_on_root_cmp = contains(keys(local.group_name_map_transpose),local.application_role) ? [
    "allow group ${local.application_group_names} to read app-catalog-listing in tenancy",
    "allow group ${local.application_group_names} to read instance-images in tenancy",
    "allow group ${local.application_group_names} to read repos in tenancy"
  ] : []

  objectstorage_read_grantees = compact(
                                  concat(contains(keys(local.group_name_map_transpose),local.network_role) ?     [local.network_group_names]     : [],
                                         contains(keys(local.group_name_map_transpose),local.security_role) ?    [local.security_group_names]    : [],
                                         contains(keys(local.group_name_map_transpose),local.application_role) ? [local.application_group_names] : [],
                                         contains(keys(local.group_name_map_transpose),local.database_role) ?    [local.database_group_names]    : [],
                                         contains(keys(local.group_name_map_transpose),local.exainfra_role) ?    [local.exainfra_group_names]    : [])
                                )
  objectstorage_read_on_root_cmp = coalescelist(local.objectstorage_read_grantees,[1]) != [1] ? ["allow group ${join(",",local.objectstorage_read_grantees)} to read objectstorage-namespaces in tenancy"] : []
  
  # For the case when there's no enclosing compartment defined, the grants are set in the root compartment. Analogous grants are present in enclosing_cmp_policy.tf, which are applied when an enclosing compartment is defined.
  security_admin_grants_on_enclosing_cmp = contains(keys(local.group_name_map_transpose),local.security_role) && !contains(local.cmp_type_list,"enclosing") ? [
    "allow group ${local.security_group_names} to manage tag-namespaces in tenancy",
    "allow group ${local.security_group_names} to manage tag-defaults in tenancy",
    "allow group ${local.security_group_names} to manage repos in tenancy",
    "allow group ${local.security_group_names} to read audit-events in tenancy",
    "allow group ${local.security_group_names} to read app-catalog-listing in tenancy",
    "allow group ${local.security_group_names} to read instance-images in tenancy",
    "allow group ${local.security_group_names} to inspect buckets in tenancy"
  ] : []  

  auditor_grants = contains(keys(local.group_name_map_transpose),local.auditor_role) ? [
    "allow group ${local.auditor_group_names} to inspect all-resources in tenancy",
    "allow group ${local.auditor_group_names} to read instances in tenancy",
    "allow group ${local.auditor_group_names} to read load-balancers in tenancy",
    "allow group ${local.auditor_group_names} to read buckets in tenancy",
    "allow group ${local.auditor_group_names} to read nat-gateways in tenancy",
    "allow group ${local.auditor_group_names} to read public-ips in tenancy",
    "allow group ${local.auditor_group_names} to read file-family in tenancy",
    "allow group ${local.auditor_group_names} to read instance-configurations in tenancy",
    "allow group ${local.auditor_group_names} to read network-security-groups in tenancy",
    "allow group ${local.auditor_group_names} to read resource-availability in tenancy",
    "allow group ${local.auditor_group_names} to read audit-events in tenancy",
    "allow group ${local.auditor_group_names} to read users in tenancy",
    "allow group ${local.auditor_group_names} to use cloud-shell in tenancy",
    "allow group ${local.auditor_group_names} to read vss-family in tenancy",
    "allow group ${local.auditor_group_names} to read usage-budgets in tenancy",
    "allow group ${local.auditor_group_names} to read usage-reports in tenancy",
    "allow group ${local.auditor_group_names} to read data-safe-family in tenancy",
    "allow group ${local.auditor_group_names} to read vaults in tenancy",
    "allow group ${local.auditor_group_names} to read keys in tenancy",
    "allow group ${local.auditor_group_names} to read tag-namespaces in tenancy",
    "allow group ${local.auditor_group_names} to use ons-family in tenancy where any {request.operation!=/Create*/, request.operation!=/Update*/, request.operation!=/Delete*/, request.operation!=/Change*/}",
    "allow group ${local.auditor_group_names} to read zpr-configuration in tenancy",
    "allow group ${local.auditor_group_names} to read zpr-policy in tenancy",
    "allow group ${local.auditor_group_names} to read security-attribute-namespace in tenancy",
    "allow group ${local.auditor_group_names} to read network-firewall-family in tenancy"
  ] : []

  announcement_reader_grants = contains(keys(local.group_name_map_transpose),local.announcement_reader_role) ? [
    "allow group ${local.announcement_reader_group_names} to read announcements in tenancy"
  ] : []

  root_cmp_admin_grants = concat(local.cost_admin_grants_on_root_cmp,local.iam_admin_grants_on_root_cmp,
                                 local.iam_admin_grants_on_enclosing_cmp,local.cred_admin_grants_on_root_cmp,
                                 local.security_admin_grants_on_root_cmp,local.security_admin_grants_on_enclosing_cmp,
                                 local.network_admin_grants_on_root_cmp,local.application_admin_grants_on_root_cmp)

  root_cmp_nonadmin_grants = concat(local.basic_grants_on_root_cmp, local.auditor_grants,local.announcement_reader_grants, local.objectstorage_read_on_root_cmp)                               

  #-- Policies
  #root_policy_name_prefix = local.enable_tenancy_level_template_policies == true ? (var.policies_configuration.template_policies.tenancy_level_settings.policy_name_prefix != null ? "${var.policies_configuration.template_policies.tenancy_level_settings.policy_name_prefix}-" : "") : ""
  #-- Naming
  root_cmp_admin_policy_key = "ROOT-CMP-ADMIN-POLICY"
  #root_cmp_admin_policy_name = "${local.root_policy_name_prefix}root-admin${local.policy_name_suffix}"
  root_cmp_admin_policy_name = "${local.policy_name_prefix}root-admin${local.policy_name_suffix}"
    
  root_cmp_admin_policy = length(local.root_cmp_admin_grants) > 0 ? {
    (local.root_cmp_admin_policy_key) = {
      name           = local.root_cmp_admin_policy_name
      compartment_id = var.tenancy_ocid
      description    = "Core Landing Zone root policy for admin groups."
      defined_tags   = var.policies_configuration.defined_tags
      freeform_tags  = var.policies_configuration.freeform_tags
      statements     = local.root_cmp_admin_grants
    }
  } : {}

  #-- Naming
  root_cmp_nonadmin_policy_key = "ROOT-CMP-NONADMIN-POLICY"
  #root_cmp_nonadmin_policy_name = "${local.root_policy_name_prefix}root-non-admin${local.policy_name_suffix}"
  root_cmp_nonadmin_policy_name = "${local.policy_name_prefix}root-non-admin${local.policy_name_suffix}"
  
  root_cmp_nonadmin_policy = length(local.root_cmp_nonadmin_grants) > 0 ? {
    (local.root_cmp_nonadmin_policy_key) = {
      name             = local.root_cmp_nonadmin_policy_name
      compartment_id   = var.tenancy_ocid
      description      = "Core Landing Zone root policy for non-admin groups."
      defined_tags     = var.policies_configuration.defined_tags
      freeform_tags    = var.policies_configuration.freeform_tags
      statements       = local.root_cmp_nonadmin_grants
    }
  } : {}
}
