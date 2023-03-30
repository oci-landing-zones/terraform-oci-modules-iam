# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {  

  #-- The expected tag names.
  lz_tag_name                      = "cislz"
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
  enable_cis_benchmark_checks = var.policies_configuration.enable_cis_benchmark_checks != null ? var.policies_configuration.enable_cis_benchmark_checks : true
  enable_tenancy_level_template_policies = var.policies_configuration.enable_tenancy_level_template_policies != null ? var.policies_configuration.enable_tenancy_level_template_policies : true
  enable_compartment_level_template_policies = var.policies_configuration.enable_compartment_level_template_policies != null ? var.policies_configuration.enable_compartment_level_template_policies : true
  enable_output = var.policies_configuration.enable_output != null ? var.policies_configuration.enable_output : false
  enable_debug = var.policies_configuration.enable_debug != null ? var.policies_configuration.enable_debug : false
  supplied_compartments = var.policies_configuration.supplied_compartments != null ? var.policies_configuration.supplied_compartments : []
  supplied_policies = var.policies_configuration.supplied_policies != null ? var.policies_configuration.supplied_policies : {}

  #-- Map derived from compartments input variable.
  cmp_name_to_cislz_tag_map_from_var = {for cmp in local.supplied_compartments : cmp.name => {
    cmp-type     : lookup(cmp.freeform_tags, local.cmp_type_tag_name,""),
    iam-group    : length(lookup(cmp.freeform_tags, local.iam_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.iam_group_tag_name,"") : null,
    sec-group    : length(lookup(cmp.freeform_tags, local.security_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.security_group_tag_name,"") : null,
    read-group   : length(lookup(cmp.freeform_tags, local.read_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.read_group_tag_name,"") : null,
    app-group    : length(lookup(cmp.freeform_tags, local.application_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.application_group_tag_name,"") : null,
    db-group     : length(lookup(cmp.freeform_tags, local.database_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.database_group_tag_name,"") : null,
    net-group    : length(lookup(cmp.freeform_tags, local.network_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.network_group_tag_name,"") : null,
    exa-group    : length(lookup(cmp.freeform_tags, local.exainfra_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.exainfra_group_tag_name,"") : null,
    stg-group    : length(lookup(cmp.freeform_tags, local.storage_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.storage_group_tag_name,"") : null,
    db-dyn-group : length(lookup(cmp.freeform_tags, local.database_kms_dyn_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.database_kms_dyn_group_tag_name,"") : null,
    ca-dyn-group : length(lookup(cmp.freeform_tags, local.compute_agent_dyn_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags,local.compute_agent_dyn_group_tag_name,"") : null,
    ocid         : cmp.ocid
  }}

  #-- Same map as above, but derived from "oci_identity_compartments" "all" data source.
  cmp_name_to_cislz_tag_map_from_data_source = {for cmp in data.oci_identity_compartments.all.compartments : cmp.name => {
    cmp-type     : lookup(cmp.freeform_tags, local.cmp_type_tag_name,""),
    iam-group    : length(lookup(cmp.freeform_tags, local.iam_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.iam_group_tag_name,"") : null,
    sec-group    : length(lookup(cmp.freeform_tags, local.security_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.security_group_tag_name,"") : null,
    read-group   : length(lookup(cmp.freeform_tags, local.read_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.read_group_tag_name,"") : null,
    app-group    : length(lookup(cmp.freeform_tags, local.application_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.application_group_tag_name,"") : null,
    db-group     : length(lookup(cmp.freeform_tags, local.database_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.database_group_tag_name,"") : null,
    net-group    : length(lookup(cmp.freeform_tags, local.network_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.network_group_tag_name,"") : null,
    exa-group    : length(lookup(cmp.freeform_tags, local.exainfra_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.exainfra_group_tag_name,"") : null,
    stg-group    : length(lookup(cmp.freeform_tags, local.storage_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.storage_group_tag_name,"") : null,
    db-dyn-group : length(lookup(cmp.freeform_tags, local.database_kms_dyn_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags, local.database_kms_dyn_group_tag_name,"") : null,
    ca-dyn-group : length(lookup(cmp.freeform_tags, local.compute_agent_dyn_group_tag_name,"")) > 0 ? lookup(cmp.freeform_tags,local.compute_agent_dyn_group_tag_name,"") : null,
    ocid         : cmp.id
  } if lookup(cmp.freeform_tags, local.lz_tag_name,"") == var.policies_configuration.cislz_tag_lookup_value }

  #-- Map from variable takes precedence
  cmp_name_to_cislz_tag_map = length(local.cmp_name_to_cislz_tag_map_from_var) > 0 ? local.cmp_name_to_cislz_tag_map_from_var : local.cmp_name_to_cislz_tag_map_from_data_source  

  policy_name_prefix = var.policies_configuration.policy_name_prefix != null ? "${var.policies_configuration.policy_name_prefix}-" : ""
  policy_name_suffix = var.policies_configuration.policy_name_suffix != null ? (var.policies_configuration.policy_name_suffix == "" ? "" : "-${var.policies_configuration.policy_name_suffix}") : "-policy"
}  