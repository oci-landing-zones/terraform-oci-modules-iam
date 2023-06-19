# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #--------------------------------------------------------------------------------------------
  #-- Security compartments policies
  #--------------------------------------------------------------------------------------------
  
  #-- Security read-only grants on Security compartment
  security_read_grants_on_security_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"security") && values["read-group"] != null) ? [
      "allow group ${values["read-group"]} to read all-resources in compartment ${cmp}"
    ] : []
  }
  
  #-- Security admin grants on Security compartment
  security_admin_grants_on_security_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"security") && values["sec-group"] != null) ? [
      "allow group ${values["sec-group"]} to read all-resources in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage instance-family in compartment ${cmp}",
      # CIS 1.2 - 1.14 Level 2
      "allow group ${values["sec-group"]} to manage volume-family in compartment ${cmp} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
      "allow group ${values["sec-group"]} to manage object-family in compartment ${cmp} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
      "allow group ${values["sec-group"]} to manage file-family in compartment ${cmp} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
      "allow group ${values["sec-group"]} to manage vaults in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage keys in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage secret-family in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage logging-family in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage serviceconnectors in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage streams in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage ons-family in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage functions-family in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage waas-family in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage security-zone in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage orm-stacks in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage orm-jobs in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage orm-config-source-providers in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage vss-family in compartment ${cmp}",
      #"allow group ${values["sec-group"]} to read work-requests in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage bastion-family in compartment ${cmp}",
      #"allow group ${values["sec-group"]} to read instance-agent-plugins in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage cloudevents-rules in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage alarms in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage metrics in compartment ${cmp}"
    ] : []
  }

  #-- Network admin grants on Security compartment
  network_admin_grants_on_security_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"security") && values["net-group"] != null) ? [
      "allow group ${values["net-group"]} to read vss-family in compartment ${cmp}",
      "allow group ${values["net-group"]} to use bastion in compartment ${cmp}",
      "allow group ${values["net-group"]} to manage bastion-session in compartment ${cmp}"
    ] : []
  }
  
  #-- Database admin grants on Security compartment
  database_admin_grants_on_security_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"security") && values["db-group"] != null) ? [
      "allow group ${values["db-group"]} to read vss-family in compartment ${cmp}",
      "allow group ${values["db-group"]} to read vaults in compartment ${cmp}",
      "allow group ${values["db-group"]} to inspect keys in compartment ${cmp}",
      "allow group ${values["db-group"]} to use bastion in compartment ${cmp}",
      "allow group ${values["db-group"]} to manage bastion-session in compartment ${cmp}"
    ] : []
  }  

  #-- Application admin grants on Security compartment
  appdev_admin_grants_on_security_cmp_map = {
    for cmp, tags in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",tags["cmp-type"]),"security") && tags["app-group"] != null) ? [
      "allow group ${tags["app-group"]} to read vaults in compartment ${cmp}",
      "allow group ${tags["app-group"]} to inspect keys in compartment ${cmp}",
      "allow group ${tags["app-group"]} to manage instance-images in compartment ${cmp}",
      "allow group ${tags["app-group"]} to read vss-family in compartment ${cmp}",
      "allow group ${tags["app-group"]} to use bastion in compartment ${cmp}",
      "allow group ${tags["app-group"]} to manage bastion-session in compartment ${cmp}"
    ] : []
  }
  
  #-- Exainfra admin grants on Security compartment
  exainfra_admin_grants_on_security_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"security") && values["exa-group"] != null) ? [
      "allow group ${values["exa-group"]} to use bastion in compartment ${cmp}",
      "allow group ${values["exa-group"]} to manage bastion-session in compartment ${cmp}"
    ] : []
  } 

  #-- Storage admin grants on Security compartment
  storage_admin_grants_on_security_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"security") && values["stg-group"] != null) ? [
      # Object Storage
      "allow group ${values["stg-group"]} to read bucket in compartment ${cmp}",
      "allow group ${values["stg-group"]} to inspect object in compartment ${cmp}",
      "allow group ${values["stg-group"]} to manage object-family in compartment ${cmp} where any {request.permission = 'OBJECT_DELETE', request.permission = 'BUCKET_DELETE'}",
      # Volume Storage
      "allow group ${values["stg-group"]} to read volume-family in compartment ${cmp}",
      "allow group ${values["stg-group"]} to manage volume-family in compartment ${cmp} where any {request.permission = 'VOLUME_DELETE', request.permission = 'VOLUME_BACKUP_DELETE', request.permission = 'BOOT_VOLUME_BACKUP_DELETE'}",
      # File Storage
      "allow group ${values["stg-group"]} to read file-family in compartment ${cmp}",
      "allow group ${values["stg-group"]} to manage file-family in compartment ${cmp} where any {request.permission = 'FILE_SYSTEM_DELETE', request.permission = 'MOUNT_TARGET_DELETE', request.permission = 'EXPORT_SET_UPDATE', request.permission = 'FILE_SYSTEM_NFSv3_UNEXPORT', request.permission = 'EXPORT_SET_DELETE', request.permission = 'FILE_SYSTEM_DELETE_SNAPSHOT'}"
    ] : []
  } 

  #-- Database grants on Security compartment
  database_kms_grants_on_security_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"security") && values["db-dyn-group"] != null) ? [
      "allow dynamic-group ${values["db-dyn-group"]} to read vaults in compartment ${cmp}",
      "allow dynamic-group ${values["db-dyn-group"]} to use keys in compartment ${cmp}"
    ] : []
  }  
 
  #-- Policies
  security_cmps_policies = {for cmp, values in local.cmp_name_to_cislz_tag_map : 
    (upper("${cmp}-security-policy")) => {
      name             = "${local.policy_name_prefix}${cmp}-security${local.policy_name_suffix}"
      compartment_ocid : values.ocid
      description      : "CIS Landing Zone policy for Security compartment."
      defined_tags     : var.policies_configuration.defined_tags
      freeform_tags    : var.policies_configuration.freeform_tags
      statements       : concat(local.security_read_grants_on_security_cmp_map[cmp],local.security_admin_grants_on_security_cmp_map[cmp],
                                local.network_admin_grants_on_security_cmp_map[cmp],local.database_admin_grants_on_security_cmp_map[cmp],
                                local.appdev_admin_grants_on_security_cmp_map[cmp],local.exainfra_admin_grants_on_security_cmp_map[cmp],
                                local.storage_admin_grants_on_security_cmp_map[cmp],local.database_kms_grants_on_security_cmp_map[cmp])
    }
  }
}
