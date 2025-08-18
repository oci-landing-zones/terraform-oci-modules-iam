# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #--------------------------------------------------------------------------------------------
  #-- Exadata Cloud Service infrastructure compartments policies
  #--------------------------------------------------------------------------------------------

  #-- Exainfra read grants on Exinfra compartment
  exainfra_read_grants_on_exainfra_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",", values["cmp-type"]), "exainfra") && values["read-group"] != null) ? [
      "allow group ${values["read-group"]} to read all-resources in compartment ${values["name"]}"
    ] : []
  }

  #-- Exainfra admin grants on Exinfra compartment
  exainfra_admin_grants_on_exainfra_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",", values["cmp-type"]), "exainfra") && values["exa-group"] != null) ? [
      "allow group ${values["exa-group"]} to read all-resources in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage cloud-exadata-infrastructures in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage cloud-vmclusters in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to read work-requests in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage bastion-session in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage instance-family in compartment ${values["name"]}",
      #"allow group ${values["exa-group"]} to read instance-agent-plugins in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage ons-family in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage alarms in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage metrics in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage data-safe-family in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to use vnics in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage keys in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to use key-delegate in compartment ${values["name"]}",
      "allow group ${values["exa-group"]} to manage secret-family in compartment ${values["name"]}"
    ] : []
  }

  #-- Database admin grants on Exainfra compartment
  database_admin_grants_on_exainfra_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",", values["cmp-type"]), "exainfra") && values["db-group"] != null) ? [
      "allow group ${values["db-group"]} to read cloud-exadata-infrastructures in compartment ${values["name"]}",
      "allow group ${values["db-group"]} to use cloud-vmclusters in compartment ${values["name"]}",
      "allow group ${values["db-group"]} to read work-requests in compartment ${values["name"]}",
      "allow group ${values["db-group"]} to manage db-nodes in compartment ${values["name"]}",
      "allow group ${values["db-group"]} to manage db-homes in compartment ${values["name"]}",
      "allow group ${values["db-group"]} to manage databases in compartment ${values["name"]}",
      "allow group ${values["db-group"]} to manage db-backups in compartment ${values["name"]}",
      "allow group ${values["db-group"]} to manage data-safe-family in compartment ${values["name"]}",
      "allow group ${values["db-group"]} to use vnics in compartment ${values["name"]}"
    ] : []
  }

  #-- Security admin grants on Exainfra compartment
  security_admin_grants_on_exainfra_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",", values["cmp-type"]), "exainfra") && values["sec-group"] != null) ? [
      "allow group ${values["sec-group"]} to read keys in compartment ${values["name"]}"
    ] : []
  }

  #-- Policies for compartments marked as exainfra compartments (values["cmp-type"] == "exainfra").
  exainfra_cmps_policies = {
    for k, values in local.cmp_name_to_cislz_tag_map :
    (upper("${k}-exainfra-policy")) => {
      name           = length(regexall("^${local.policy_name_prefix}", values["name"])) > 0 ? (length(split(",", values["cmp-type"])) > 1 ? "${values["name"]}-exainfra${local.policy_name_suffix}" : "${values["name"]}${local.policy_name_suffix}") : (length(split(",", values["cmp-type"])) > 1 ? "${local.policy_name_prefix}${values["name"]}-exainfra${local.policy_name_suffix}" : "${local.policy_name_prefix}${values["name"]}${local.policy_name_suffix}")
      compartment_id = values.ocid
      description    = "Core Landing Zone policy for Exadata Cloud Service infrastructure compartment."
      defined_tags   = var.policies_configuration.defined_tags
      freeform_tags  = var.policies_configuration.freeform_tags
      statements = concat(local.exainfra_admin_grants_on_exainfra_cmp_map[k],
        local.exainfra_read_grants_on_exainfra_cmp_map[k],
        local.database_admin_grants_on_exainfra_cmp_map[k],
      local.security_admin_grants_on_exainfra_cmp_map[k])
    }
    if contains(split(",", values["cmp-type"]), "exainfra")
  }
}