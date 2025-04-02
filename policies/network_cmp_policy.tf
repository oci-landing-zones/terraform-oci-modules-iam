# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #--------------------------------------------------------------------------------------------
  #-- Network compartments policies
  #--------------------------------------------------------------------------------------------
  
  #-- Network read-only grants on Network compartment
  network_read_grants_on_network_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"network") && values["read-group"] != null) ? [
      "allow group ${values["read-group"]} to read all-resources in compartment ${values["name"]}"
    ] : []
  }

  #-- Network admin grants on Network compartment
  network_admin_grants_on_network_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"network") && values["net-group"] != null) ? [
      "allow group ${values["net-group"]} to read all-resources in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage virtual-network-family in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage dns in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage load-balancers in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage alarms in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage metrics in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage ons-family in compartment ${values["name"]}", 
      "allow group ${values["net-group"]} to manage orm-stacks in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage orm-jobs in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage orm-config-source-providers in compartment ${values["name"]}",
      #"allow group ${values["net-group"]} to read audit-events in compartment ${values["name"]}",
      #"allow group ${values["net-group"]} to read work-requests in compartment ${values["name"]}",
      # CIS 1.2 - 1.14 Level 2
      "allow group ${values["net-group"]} to manage instance-family in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage volume-family in compartment ${values["name"]} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
      "allow group ${values["net-group"]} to manage object-family in compartment ${values["name"]} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
      "allow group ${values["net-group"]} to manage file-family in compartment ${values["name"]} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
      "allow group ${values["net-group"]} to manage bastion-session in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage cloudevents-rules in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage alarms in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage metrics in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage keys in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to use key-delegate in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage secret-family in compartment ${values["name"]}",
      "allow group ${values["net-group"]} to manage network-firewall-family in compartment ${values["name"]}"
      #"allow group ${values["net-group"]} to read instance-agent-plugins in compartment ${values["name"]}"
    ] : []
  }  

  common_groups_on_network_cmp = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => [values["sec-group"] != null ? "${values["sec-group"]}" : "", values["app-group"] != null ? "${values["app-group"]}" : "", values["db-group"] != null ? "${values["db-group"]}" : "", values["exa-group"] != null ? "${values["exa-group"]}" : ""]
  if contains(split(",",values["cmp-type"]),"network")}

  common_admin_grants_on_network_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"network")) ? [
      "allow group ${trim(join(",",local.common_groups_on_network_cmp[k]),",")} to read virtual-network-family in compartment ${values["name"]}",
      "allow group ${trim(join(",",local.common_groups_on_network_cmp[k]),",")} to use subnets in compartment ${values["name"]}",
      "allow group ${trim(join(",",local.common_groups_on_network_cmp[k]),",")} to use network-security-groups in compartment ${values["name"]}",
      "allow group ${trim(join(",",local.common_groups_on_network_cmp[k]),",")} to use vnics in compartment ${values["name"]}",
      "allow group ${trim(join(",",local.common_groups_on_network_cmp[k]),",")} to manage private-ips in compartment ${values["name"]}",
    ] : []
  } 

  #-- Security admin grants on Network compartment
  security_admin_grants_on_network_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"network") && values["sec-group"] != null) ? [
      "allow group ${values["sec-group"]} to read keys in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to use network-firewall-family in compartment ${values["name"]}"
    ] : []
  }

  #-- Application admin grants on Network compartment
  appdev_admin_grants_on_network_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"network") && values["app-group"] != null) ? [
      "allow group ${values["app-group"]} to use load-balancers in compartment ${values["name"]}"
    ] : []
  }  

  #-- Storag admin grants on Network compartment
  storage_admin_grants_on_network_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"network") && values["stg-group"] != null) ? [
      # Object Storage
      "allow group ${values["stg-group"]} to read bucket in compartment ${values["name"]}",
      "allow group ${values["stg-group"]} to inspect object in compartment ${values["name"]}",
      "allow group ${values["stg-group"]} to manage object-family in compartment ${values["name"]} where any {request.permission = 'OBJECT_DELETE', request.permission = 'BUCKET_DELETE'}",
      # Volume Storage
      "allow group ${values["stg-group"]} to read volume-family in compartment ${values["name"]}",
      "allow group ${values["stg-group"]} to manage volume-family in compartment ${values["name"]} where any {request.permission = 'VOLUME_DELETE', request.permission = 'VOLUME_BACKUP_DELETE', request.permission = 'BOOT_VOLUME_BACKUP_DELETE'}",
      # File Storage
      "allow group ${values["stg-group"]} to read file-family in compartment ${values["name"]}",
      "allow group ${values["stg-group"]} to manage file-family in compartment ${values["name"]} where any {request.permission = 'FILE_SYSTEM_DELETE', request.permission = 'MOUNT_TARGET_DELETE', request.permission = 'VNIC_DELETE', request.permission = 'SUBNET_DETACH', request.permission = 'VNIC_DETACH', request.permission = 'PRIVATE_IP_DELETE', request.permission = 'PRIVATE_IP_UNASSIGN', request.permission = 'VNIC_UNASSIGN', request.permission = 'EXPORT_SET_UPDATE', request.permission = 'FILE_SYSTEM_NFSv3_UNEXPORT', request.permission = 'EXPORT_SET_DELETE', request.permission = 'FILE_SYSTEM_DELETE_SNAPSHOT'}",
    ] : [] 
  }  

  application_compartment_id = local.enable_oke_service_policies ? (distinct(compact(concat([for k, values in local.cmp_name_to_cislz_tag_map : (contains(split(",",values["cmp-type"]),"application")) ? values["ocid"] : ""])))[0]) : null

  oke_cluster_grants_on_network_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"network")) && local.enable_oke_service_policies && local.application_compartment_id != null ? [
      "allow any-user to use private-ips in compartment ${values["name"]} where all { request.principal.type = 'cluster', request.principal.compartment.id = '${local.application_compartment_id}' }",
      "allow any-user to use network-security-groups in compartment ${values["name"]} where all { request.principal.type = 'cluster', request.principal.compartment.id = '${local.application_compartment_id}' }",
      "allow any-user to use subnets in compartment ${values["name"]} where all { request.principal.type = 'cluster', request.principal.compartment.id = '${local.application_compartment_id}' }"
    ] : []
  }

  #-- Policies for compartments marked as network compartments (values["cmp-type"] == "network").
  network_cmps_policies = {
    for k, values in local.cmp_name_to_cislz_tag_map : 
      (upper("${k}-network-policy")) => {
        name             = length(regexall("^${local.policy_name_prefix}", values["name"])) > 0 ? (length(split(",",values["cmp-type"])) > 1 ? "${values["name"]}-network${local.policy_name_suffix}" : "${values["name"]}${local.policy_name_suffix}") : (length(split(",",values["cmp-type"])) > 1 ? "${local.policy_name_prefix}${values["name"]}-network${local.policy_name_suffix}" : "${local.policy_name_prefix}${values["name"]}${local.policy_name_suffix}")
        compartment_id   = values.ocid
        description      = "Core Landing Zone policy for Network compartment."
        defined_tags     = var.policies_configuration.defined_tags
        freeform_tags    = var.policies_configuration.freeform_tags
        statements       = concat(local.network_admin_grants_on_network_cmp_map[k],local.network_read_grants_on_network_cmp_map[k],
                                  local.security_admin_grants_on_network_cmp_map[k],local.appdev_admin_grants_on_network_cmp_map[k],
                                  #local.database_admin_grants_on_network_cmp_map[k],local.exainfra_admin_grants_on_network_cmp_map[k],
                                  local.common_admin_grants_on_network_cmp_map[k], local.storage_admin_grants_on_network_cmp_map[k],
                                  local.oke_cluster_grants_on_network_cmp_map[k])
      }
    if contains(split(",",values["cmp-type"]),"network")
  }                           
}