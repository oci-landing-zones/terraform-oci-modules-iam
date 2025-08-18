# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_compartments" "all_cmps" {
  compartment_id            = var.tenancy_ocid
  compartment_id_in_subtree = true
  access_level              = "ANY"
  state                     = "ACTIVE"
}
locals {

  #-- Compartment metadata attributes. These are passed to the policy module via supplied_compartments' cislz_metadata attribute.
  cislz_compartments_metadata = {
    "enclosing" : {
      "cislz-cmp-type" : "enclosing",
      "cislz-consumer-groups-security" : "vision-security-admin-group", # see right below how to pass multiple groups, and with spaces in their names.
      #"cislz-consumer-groups-security":"vision-security-admin-group,'vision security adm group2'",
      "cislz-consumer-groups-application" : "vision-app-admin-group",
      "cislz-consumer-groups-iam" : "vision-iam-admin-group"
    },
    "network" : {
      "cislz-cmp-type" : "network",
      "cislz-consumer-groups-security" : "vision-security-admin-group",
      "cislz-consumer-groups-application" : "vision-app-admin-group",
      "cislz-consumer-groups-database" : "vision-database-admin-group",
      "cislz-consumer-groups-network" : "vision-network-admin-group",
      "cislz-consumer-groups-storage" : "vision-storage-admin-group",
      "cislz-consumer-groups-exainfra" : "vision-exainfra-admin-group"
    },
    "security" : {
      "cislz-cmp-type" : "security",
      "cislz-consumer-groups-security" : "vision-security-admin-group",
      "cislz-consumer-groups-application" : "vision-app-admin-group",
      "cislz-consumer-groups-database" : "vision-database-admin-group",
      "cislz-consumer-groups-network" : "vision-network-admin-group",
      "cislz-consumer-groups-storage" : "vision-storage-admin-group",
      "cislz-consumer-groups-exainfra" : "vision-exainfra-admin-group",
      "cislz-consumer-groups-dyn-database-kms" : "vision-database-kms-dynamic-group"
    },
    "application" : {
      "cislz-cmp-type" : "application",
      "cislz-consumer-groups-security" : "vision-security-admin-group",
      "cislz-consumer-groups-application" : "vision-app-admin-group",
      "cislz-consumer-groups-database" : "vision-database-admin-group",
      "cislz-consumer-groups-network" : "vision-network-admin-group",
      "cislz-consumer-groups-storage" : "vision-storage-admin-group",
      "cislz-consumer-groups-exainfra" : "vision-exainfra-admin-group",
      "cislz-consumer-groups-dyn-compute-agent" : "vision-appdev-computeagent-dynamic-group"
    },
    "database" : {
      "cislz-cmp-type" : "database",
      "cislz-consumer-groups-security" : "vision-security-admin-group",
      "cislz-consumer-groups-application" : "vision-app-admin-group",
      "cislz-consumer-groups-database" : "vision-database-admin-group",
      "cislz-consumer-groups-network" : "vision-network-admin-group",
      "cislz-consumer-groups-storage" : "vision-storage-admin-group",
      "cislz-consumer-groups-exainfra" : "vision-exainfra-admin-group",
      "cislz-consumer-groups-dyn-database-kms" : "vision-database-kms-dynamic-group"
    },
    "exainfra" : {
      "cislz-cmp-type" : "exainfra",
      "cislz-consumer-groups-security" : "vision-security-admin-group",
      "cislz-consumer-groups-application" : "vision-app-admin-group",
      "cislz-consumer-groups-database" : "vision-database-admin-group",
      "cislz-consumer-groups-network" : "vision-network-admin-group",
      "cislz-consumer-groups-storage" : "vision-storage-admin-group",
      "cislz-consumer-groups-exainfra" : "vision-exainfra-admin-group"
    }
  }

  cmps_from_data_source = {
    for cmp in data.oci_identity_compartments.all_cmps.compartments : cmp.name =>
    {
      name : cmp.name,
      id : cmp.id,
      cislz_metadata : local.cislz_compartments_metadata[cmp.freeform_tags["cislz-cmp-type"]] #-- This example expects compartments to be freeform tagged with "cislz-cmp-type", so it can figure out the compartments intent and associate it with the appropriate metadata.
    }
    if lookup(cmp.freeform_tags, "cislz", "") == "template-policies-example" #-- The compartments we are interested are freeform tagged as {"cislz" : "template-policies-example"} but you could identify the compartments through some other attributes that makes sense to your deployment.
  }

  policies_configuration = {
    template_policies : {
      tenancy_level_settings : {
        groups_with_tenancy_level_roles : [
          { "name" : "vision-iam-admin-group", "roles" : "iam" }, # for multiple groups with the same role, add another element to the list, repeating the role, like the one right below.
          #{"name":"'vision iam adm group'",     "roles":"iam"}, # an example with a group name with spaces. Use single quotes around it.
          { "name" : "vision-cred-admin-group", "roles" : "cred" },
          { "name" : "vision-cost-admin-group", "roles" : "cost" },
          { "name" : "vision-security-admin-group", "roles" : "security,basic" },
          { "name" : "vision-app-admin-group", "roles" : "application,basic" },
          { "name" : "vision-auditor-group", "roles" : "auditor" },
          { "name" : "vision-database-admin-group", "roles" : "database,basic" },
          { "name" : "vision-exainfra-admin-group", "roles" : "exainfra,basic" },
          { "name" : "vision-storage-admin-group", "roles" : "basic" },
          { "name" : "vision-network-admin-group", "roles" : "network,basic" },
          { "name" : "vision-announcement_reader-group", "roles" : "announcement-reader" }
        ]
        oci_services : {
          enable_all_policies : true
        }
        #policy_name_prefix : "vision"
      }
      compartment_level_settings : {
        supplied_compartments : local.cmps_from_data_source
      }
    }
    policy_name_prefix : "vision"
  }
}

module "cislz_policies" {
  source                 = "../.."
  tenancy_ocid           = var.tenancy_ocid
  policies_configuration = local.policies_configuration
}  