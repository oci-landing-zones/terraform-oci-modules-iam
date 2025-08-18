# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  #-- The expected tag names.
  cmp_type_tag_name                = "cislz-cmp-type"
  iam_group_tag_name               = "cislz-consumer-groups-iam"
  security_group_tag_name          = "cislz-consumer-groups-security"
  read_group_tag_name              = "cislz-consumer-groups-read"
  application_group_tag_name       = "cislz-consumer-groups-application"
  database_group_tag_name          = "cislz-consumer-groups-database"
  network_group_tag_name           = "cislz-consumer-groups-network"
  exainfra_group_tag_name          = "cislz-consumer-groups-exainfra"
  storage_group_tag_name           = "cislz-consumer-groups-storage"
  database_kms_dyn_group_tag_name  = "cislz-consumer-groups-dyn-database-kms"
  compute_agent_dyn_group_tag_name = "cislz-consumer-groups-dyn-compute-agent"

  #-- Module defaults
  enable_cis_benchmark_checks                = var.policies_configuration != null ? (var.policies_configuration.enable_cis_benchmark_checks != null ? var.policies_configuration.enable_cis_benchmark_checks : true) : false
  enable_tenancy_level_template_policies     = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.tenancy_level_settings != null ? (var.policies_configuration.template_policies.tenancy_level_settings.groups_with_tenancy_level_roles != null ? true : false) : false) : false) : false
  enable_compartment_level_template_policies = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.compartment_level_settings != null ? (var.policies_configuration.template_policies.compartment_level_settings.supplied_compartments != null ? true : false) : false) : false) : false
  enable_output                              = var.enable_output != null ? var.enable_output : false
  enable_debug                               = var.enable_debug != null ? var.enable_debug : false
  supplied_compartments                      = local.enable_compartment_level_template_policies == true ? (var.policies_configuration != null ? var.policies_configuration.template_policies.compartment_level_settings.supplied_compartments : {}) : {}
  supplied_policies                          = var.policies_configuration != null ? (var.policies_configuration.supplied_policies != null ? var.policies_configuration.supplied_policies : {}) : {}
  #-- Service policies
  enable_scanning_service_policies       = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.tenancy_level_settings != null ? (var.policies_configuration.template_policies.tenancy_level_settings.oci_services != null ? (coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_scanning_policies, false) == true || coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_all_policies, false) == true ? true : false) : false) : false) : false) : false
  enable_cloud_guard_service_policies    = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.tenancy_level_settings != null ? (var.policies_configuration.template_policies.tenancy_level_settings.oci_services != null ? (coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_cloud_guard_policies, false) == true || coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_all_policies, false) == true ? true : false) : false) : false) : false) : false
  enable_os_management_service_policies  = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.tenancy_level_settings != null ? (var.policies_configuration.template_policies.tenancy_level_settings.oci_services != null ? (coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_os_management_policies, false) == true || coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_all_policies, false) == true ? true : false) : false) : false) : false) : false
  enable_block_storage_service_policies  = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.tenancy_level_settings != null ? (var.policies_configuration.template_policies.tenancy_level_settings.oci_services != null ? (coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_block_storage_policies, false) == true || coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_all_policies, false) == true ? true : false) : false) : false) : false) : false
  enable_file_storage_service_policies   = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.tenancy_level_settings != null ? (var.policies_configuration.template_policies.tenancy_level_settings.oci_services != null ? (coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_file_storage_policies, false) == true || coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_all_policies, false) == true ? true : false) : false) : false) : false) : false
  enable_streaming_service_policies      = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.tenancy_level_settings != null ? (var.policies_configuration.template_policies.tenancy_level_settings.oci_services != null ? (coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_streaming_policies, false) == true || coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_all_policies, false) == true ? true : false) : false) : false) : false) : false
  enable_oke_service_policies            = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.tenancy_level_settings != null ? (var.policies_configuration.template_policies.tenancy_level_settings.oci_services != null ? (coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_oke_policies, false) == true || coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_all_policies, false) == true ? true : false) : false) : false) : false) : false
  enable_object_storage_service_policies = var.policies_configuration != null ? (var.policies_configuration.template_policies != null ? (var.policies_configuration.template_policies.tenancy_level_settings != null ? (var.policies_configuration.template_policies.tenancy_level_settings.oci_services != null ? (coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_object_storage_policies, false) == true || coalesce(var.policies_configuration.template_policies.tenancy_level_settings.oci_services.enable_all_policies, false) == true ? true : false) : false) : false) : false) : false

  #-- Map derived from compartments input variable.
  cmp_name_to_cislz_tag_map = { for k, cmp in local.supplied_compartments : k => {
    name : cmp.name
    ocid : length(regexall("^ocid1.*$", cmp.id)) > 0 ? cmp.id : var.compartments_dependency[cmp.id].id
    cmp-type : lookup(cmp.cislz_metadata, local.cmp_type_tag_name, ""),
    iam-group : length(lookup(cmp.cislz_metadata, local.iam_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.iam_group_tag_name, "") : null,
    sec-group : length(lookup(cmp.cislz_metadata, local.security_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.security_group_tag_name, "") : null,
    read-group : length(lookup(cmp.cislz_metadata, local.read_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.read_group_tag_name, "") : null,
    app-group : length(lookup(cmp.cislz_metadata, local.application_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.application_group_tag_name, "") : null,
    db-group : length(lookup(cmp.cislz_metadata, local.database_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.database_group_tag_name, "") : null,
    net-group : length(lookup(cmp.cislz_metadata, local.network_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.network_group_tag_name, "") : null,
    exa-group : length(lookup(cmp.cislz_metadata, local.exainfra_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.exainfra_group_tag_name, "") : null,
    stg-group : length(lookup(cmp.cislz_metadata, local.storage_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.storage_group_tag_name, "") : null,
    db-dyn-group : length(lookup(cmp.cislz_metadata, local.database_kms_dyn_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.database_kms_dyn_group_tag_name, "") : null,
    ca-dyn-group : length(lookup(cmp.cislz_metadata, local.compute_agent_dyn_group_tag_name, "")) > 0 ? lookup(cmp.cislz_metadata, local.compute_agent_dyn_group_tag_name, "") : null,
  } }

  #cmp_policy_name_prefix = local.enable_compartment_level_template_policies == true ? (var.policies_configuration.template_policies.compartment_level_settings.policy_name_prefix != null ? "${var.policies_configuration.template_policies.compartment_level_settings.policy_name_prefix}-" : "") : ""
  policy_name_prefix = var.policies_configuration != null ? (var.policies_configuration.policy_name_prefix != null ? "${var.policies_configuration.policy_name_prefix}-" : "") : ""
  policy_name_suffix = var.policies_configuration != null ? (var.policies_configuration.policy_name_suffix != null ? (var.policies_configuration.policy_name_suffix == "" ? "" : "-${var.policies_configuration.policy_name_suffix}") : "-policy") : "-policy"
}  