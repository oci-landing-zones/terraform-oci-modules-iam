# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "cislz_policies" {
  source       = "../.."
  tenancy_ocid = var.tenancy_ocid

  #policy_name_prefix     = "vision" # Uncomment to add the prefix to all pre-configured policy names.
  cislz_tag_lookup_value = var.cislz_tag_lookup_value # tells the module to lookup compartments with freeform tag cislz = "vision"
  
  enable_tenancy_level_template_policies = var.enable_tenancy_level_template_policies
  groups_with_tenancy_level_roles = var.groups_with_tenancy_level_roles

  ## Sample custom policies to test CIS checks.
  custom_policies = {
    "CUSTOM-POLICY" : {
      name : "custom-policy"
      description : "Custom policy"
      compartment_ocid : var.tenancy_ocid
      #-- The "not ok" statements below are flagged by the module if variable enable_cis_benchmark_checks = true (default)
      statements : [
        #"allow group-a to manage all-resources in tenancy", # not ok
        #"allow group-b to manage all-resources in tenancy ", # not ok
        "allow group group-a to use groups in tenancy where target.group.name != 'Administrators'", # ok
        "allow group group-a to use groups in tenancy where target.group.name = 'group-a'", # ok
        "allow group vision-cred-admin-group to manage users in tenancy where any {target.group.name != 'Administrators'}", # ok
        #"allow group vision-cred-admin-group to manage users in tenancy where any {target.group.name != 'Administrators', request.operation = 'UpdateGroup'}", # not ok
        "allow group vision-cred-admin-group to manage users in tenancy where any {target.group.name != 'Administrators', request.operation = 'ListAPiKeys'}" # ok
        #"allow group vision-cred-admin-group to manage groups in tenancy", # not ok
        #"allow group vision-cred-admin-group to manage users in tenancy" # not ok
      ]            
      defined_tags : null
      freeform_tags : null
    }
  }

  #enable_cis_benchmark_checks = false # uncomment to disable CIS Benchmark policy checks.
}  