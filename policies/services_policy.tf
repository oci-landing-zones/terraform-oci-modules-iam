# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_tenancy" "this" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_region_subscriptions" "these" {
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

  # The name of the File Storage service user depends on your realm . 
  # For realms with realm key numbers of 10 or less, the pattern for the File Storage service user is FssOc<n>Prod, where n is the realm key number. 
  # Realms with a realm key number greater than 10 have a service user of fssocprod.
  # https://docs.oracle.com/en-us/iaas/Content/File/Tasks/encrypt-file-system.htm
  realm = split(".",trimprefix(data.oci_identity_tenancy.this.id, "ocid1.tenancy."))[0]
  fss_principal_name = substr(local.realm,2,10) <= 10 ? "Fss${local.realm}Prod" : "fssocprod"
  
  object_storage_service_principals = join(",", [for region in data.oci_identity_region_subscriptions.these.region_subscriptions : "objectstorage-${region.region_name}"])

  keys_access_principals =  join(",",compact([local.enable_block_storage_service_policies == true ? "blockstorage" : null,
                                              local.enable_oke_service_policies == true ? "oke" : null,
                                              local.enable_streaming_service_policies == true ? "streaming" : null,
                                              local.enable_file_storage_service_policies == true ? local.fss_principal_name : null,
                                              local.enable_object_storage_service_policies == true ? local.object_storage_service_principals : null]))

  keys_access_statements = length(local.keys_access_principals) > 0 ? ["Allow service ${local.keys_access_principals} to use keys in tenancy"] : []
  
  services_policy_key  = "SERVICES-POLICY"
  #services_policy_name = "${local.root_policy_name_prefix}services${local.policy_name_suffix}"
  services_policy_name = "${local.policy_name_prefix}services${local.policy_name_suffix}"

  services_policy = { 
    (local.services_policy_key) = {
      compartment_id   = var.tenancy_ocid
      name             = local.services_policy_name
      description      = "Core Landing Zone policy for OCI services."
      statements       = concat(local.cloud_guard_statements, local.vss_statements, local.os_mgmt_statements, local.keys_access_statements)
      defined_tags     = var.policies_configuration != null ? var.policies_configuration.defined_tags : null
      freeform_tags    = var.policies_configuration != null ? var.policies_configuration.freeform_tags : null
    }
  }     
}