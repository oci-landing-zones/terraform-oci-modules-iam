# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_tenancy" "this" {
  tenancy_id = var.tenancy_ocid
}

locals {
  cloud_guard_statements = local.enable_cloud_guard_service_policies == true ? [
    "Allow service cloudguard to read all-resources in tenancy",
    "Allow service cloudguard to use network-security-groups in tenancy"
  ] : []

  vss_statements = local.enable_scanning_service_policies == true ? [
    "Allow service vulnerability-scanning-service to manage instances in tenancy",
    "Allow service vulnerability-scanning-service to read compartments in tenancy",
    "Allow service vulnerability-scanning-service to read repos in tenancy",
    "Allow service vulnerability-scanning-service to read vnics in tenancy",
    "Allow service vulnerability-scanning-service to read vnic-attachments in tenancy"
  ] : []

  os_mgmt_statements = local.enable_os_management_service_policies == true ? [
    "Allow service osms to read instances in tenancy"
  ] : []

  object_storage_statements = local.object_storage_regions != null ? [ 
    for region in local.object_storage_regions : "Allow service objectstorage-${region} to use keys in tenancy"
  ] : []

  block_storage_statements = local.enable_block_storage_service_policies == true ? [
    "Allow service blockstorage to use keys in tenancy"
  ] : []

  realm = split(".",trimprefix(data.oci_identity_tenancy.this.id, "ocid1.tenancy."))[0]

  file_storage_statements = local.enable_file_storage_service_policies == true ? [
    "Allow service Fss${local.realm}Prod to use keys in tenancy"
  ] : []

  oke_statements = local.enable_oke_service_policies == true ? [
    "Allow service oke to use keys in tenancy"
  ] : []

  streaming_statements = local.enable_streaming_service_policies == true ? [
    "Allow service streaming to use keys in tenancy"
  ] : []

  services_policy_key  = "SERVICES-POLICY"
  services_policy_name = "${local.root_policy_name_prefix}services${local.policy_name_suffix}"

  services_policy = { 
    (local.services_policy_key) = {
      compartment_ocid = var.tenancy_ocid
      name            = local.services_policy_name
      description     = "CIS Landing Zone policy for OCI services."
      statements      = concat(local.cloud_guard_statements, local.vss_statements, local.os_mgmt_statements,
                               local.object_storage_statements, local.block_storage_statements, local.file_storage_statements,
                               local.oke_statements, local.streaming_statements)
      defined_tags     = var.policies_configuration.defined_tags
      freeform_tags    = var.policies_configuration.freeform_tags
    }
  }      
}