# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #--------------------------------------------------------------------------------------------
  #-- Network compartments policies
  #--------------------------------------------------------------------------------------------
  
  #-- Network read-only grants on Network compartment
  network_read_grants_on_network_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"network") && values["read-group"] != null) ? [
      "allow group ${values["read-group"]} to read all-resources in compartment ${cmp}"
    ] : []
  }

  #-- Network admin grants on Network compartment
  network_admin_grants_on_network_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"network") && values["net-group"] != null) ? [
      "allow group ${values["net-group"]} to read all-resources in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage virtual-network-family in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage dns in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage load-balancers in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage alarms in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage metrics in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage ons-family in compartment ${cmp}", 
      "allow group ${values["net-group"]} to manage orm-stacks in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage orm-jobs in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage orm-config-source-providers in compartment ${cmp}",
      #"allow group ${values["net-group"]} to read audit-events in compartment ${cmp}",
      #"allow group ${values["net-group"]} to read work-requests in compartment ${cmp}",
      # CIS 1.2 - 1.14 Level 2
      "allow group ${values["net-group"]} to manage instance-family in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage volume-family in compartment ${cmp} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
      "allow group ${values["net-group"]} to manage object-family in compartment ${cmp} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
      "allow group ${values["net-group"]} to manage file-family in compartment ${cmp} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
      "allow group ${values["net-group"]} to manage bastion-session in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage cloudevents-rules in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage alarms in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage metrics in compartment ${cmp}",
      #"allow group ${values["net-group"]} to read instance-agent-plugins in compartment ${cmp}"
    ] : []
  }  

  #-- Security admin grants on Network compartment
  security_admin_grants_on_network_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"network") && values["sec-group"] != null) ? [
      "allow group ${values["sec-group"]} to read virtual-network-family in compartment ${cmp}",
      "allow group ${values["sec-group"]} to use subnets in compartment ${cmp}",
      "allow group ${values["sec-group"]} to use network-security-groups in compartment ${cmp}",
      "allow group ${values["sec-group"]} to use vnics in compartment ${cmp}"
    ] : []
  }

  #-- Database admin grants on Network compartment
  database_admin_grants_on_network_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"network") && values["db-group"] != null) ? [
      "allow group ${values["db-group"]} to read virtual-network-family in compartment ${cmp}",
      "allow group ${values["db-group"]} to use vnics in compartment ${cmp}",
      "allow group ${values["db-group"]} to use subnets in compartment ${cmp}",
      "allow group ${values["db-group"]} to use network-security-groups in compartment ${cmp}"
    ] : [] 
  }  

  #-- Application admin grants on Network compartment
  appdev_admin_grants_on_network_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"network") && values["app-group"] != null) ? [
      "allow group ${values["app-group"]} to read virtual-network-family in compartment ${cmp}",
      "allow group ${values["app-group"]} to use subnets in compartment ${cmp}",
      "allow group ${values["app-group"]} to use network-security-groups in compartment ${cmp}",
      "allow group ${values["app-group"]} to use vnics in compartment ${cmp}",
      "allow group ${values["app-group"]} to use load-balancers in compartment ${cmp}"
    ] : []
  }  

  #-- Exainfra admin grants on Network compartment
  exainfra_admin_grants_on_network_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"network") && values["exa-group"] != null) ? [
      "allow group ${values["exa-group"]} to read virtual-network-family in compartment ${cmp}"
    ] : []
  }  

  #-- Storag admin grants on Network compartment
  storage_admin_grants_on_network_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"network") && values["stg-group"] != null) ? [
      # Object Storage
      "allow group ${values["stg-group"]} to read bucket in compartment ${cmp}",
      "allow group ${values["stg-group"]} to inspect object in compartment ${cmp}",
      "allow group ${values["stg-group"]} to manage object-family in compartment ${cmp} where any {request.permission = 'OBJECT_DELETE', request.permission = 'BUCKET_DELETE'}",
      # Volume Storage
      "allow group ${values["stg-group"]} to read volume-family in compartment ${cmp}",
      "allow group ${values["stg-group"]} to manage volume-family in compartment ${cmp} where any {request.permission = 'VOLUME_DELETE', request.permission = 'VOLUME_BACKUP_DELETE', request.permission = 'BOOT_VOLUME_BACKUP_DELETE'}",
      # File Storage
      "allow group ${values["stg-group"]} to read file-family in compartment ${cmp}",
      "allow group ${values["stg-group"]} to manage file-family in compartment ${cmp} where any {request.permission = 'FILE_SYSTEM_DELETE', request.permission = 'MOUNT_TARGET_DELETE', request.permission = 'VNIC_DELETE', request.permission = 'SUBNET_DETACH', request.permission = 'VNIC_DETACH', request.permission = 'PRIVATE_IP_DELETE', request.permission = 'PRIVATE_IP_UNASSIGN', request.permission = 'VNIC_UNASSIGN', request.permission = 'EXPORT_SET_UPDATE', request.permission = 'FILE_SYSTEM_NFSv3_UNEXPORT', request.permission = 'EXPORT_SET_DELETE', request.permission = 'FILE_SYSTEM_DELETE_SNAPSHOT'}",
    ] : [] 
  }  

  #-- Policy
  network_cmps_policies = {for cmp, values in local.cmp_name_to_cislz_tag_map : 
    (upper("${cmp}-network-policy")) => {
      name             = "${local.cmp_policy_name_prefix}${cmp}${local.policy_name_suffix}"
      compartment_ocid = values.ocid
      description      = "CIS Landing Zone policy for Network compartment."
      defined_tags     = var.policies_configuration.defined_tags
      freeform_tags    = var.policies_configuration.freeform_tags
      statements       = concat(local.network_admin_grants_on_network_cmp_map[cmp],local.network_read_grants_on_network_cmp_map[cmp],
                                local.security_admin_grants_on_network_cmp_map[cmp],local.appdev_admin_grants_on_network_cmp_map[cmp],
                                local.database_admin_grants_on_network_cmp_map[cmp],local.exainfra_admin_grants_on_network_cmp_map[cmp],
                                local.storage_admin_grants_on_network_cmp_map[cmp])
    }
  }                           
}