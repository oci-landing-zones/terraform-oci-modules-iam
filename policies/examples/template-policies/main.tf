# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_compartments" "all_cmps" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true
  access_level = "ANY"
  state = "ACTIVE"
}
locals {
  #-- The compartments we are interested are freeform tagged as {"cislz" : "vision"}
  cmps_from_data_source = {
    for cmp in data.oci_identity_compartments.all_cmps.compartments : cmp.name => 
      { 
        name : cmp.name, 
        ocid : cmp.id, 
        freeform_tags : cmp.freeform_tags 
      } 
    if lookup(cmp.freeform_tags, "cislz","") == "vision"
  }

  policies_configuration = {
    supplied_compartments : local.cmps_from_data_source
    groups_with_tenancy_level_roles : [
      {"name":"vision-iam-admin-group",     "roles":"iam"},
      {"name":"vision-cred-admin-group",    "roles":"cred"},
      {"name":"vision-cost-admin-group",    "roles":"cost"},
      {"name":"vision-security-admin-group","roles":"security"},
      {"name":"vision-app-admin-group",     "roles":"application"},
      {"name":"vision-auditor-group",       "roles":"auditor"},
      {"name":"vision-database-admin-group","roles":"basic"},
      {"name":"vision-exainfra-admin-group","roles":"basic"},
      {"name":"vision-storage-admin-group", "roles":"basic"},
      {"name":"vision-announcement_reader-group","roles":"announcement-reader"}
    ]
    enable_output : true
  } 
}

module "cislz_policies" {
  source       = "../.."
  tenancy_ocid = var.tenancy_ocid
  policies_configuration = local.policies_configuration
}  