# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #--------------------------------------------------------------------------------------------
  #-- Security compartments policies
  #--------------------------------------------------------------------------------------------
  
  #-- Security read-only grants on Security compartment
  security_read_grants_on_security_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"security") && values["read-group"] != null) ? [
      "allow group ${values["read-group"]} to read all-resources in compartment ${values["name"]}"
    ] : []
  }
  
  #-- Security admin grants on Security compartment
  security_admin_grants_on_security_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"security") && values["sec-group"] != null) ? [
      "allow group ${values["sec-group"]} to read all-resources in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage instance-family in compartment ${values["name"]}",
      # CIS 1.2 - 1.14 Level 2
      "allow group ${values["sec-group"]} to manage volume-family in compartment ${values["name"]} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
      "allow group ${values["sec-group"]} to manage object-family in compartment ${values["name"]} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
      "allow group ${values["sec-group"]} to manage file-family in compartment ${values["name"]} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
      "allow group ${values["sec-group"]} to manage vaults in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage keys in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage secret-family in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage logging-family in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage serviceconnectors in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage streams in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage ons-family in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage functions-family in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage waas-family in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage security-zone in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage orm-stacks in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage orm-jobs in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage orm-config-source-providers in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage vss-family in compartment ${values["name"]}",
      #"allow group ${values["sec-group"]} to read work-requests in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage bastion-family in compartment ${values["name"]}",
      #"allow group ${values["sec-group"]} to read instance-agent-plugins in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage cloudevents-rules in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage alarms in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to manage metrics in compartment ${values["name"]}",
      "allow group ${values["sec-group"]} to use key-delegate in compartment ${values["name"]}"
    ] : []
  }

  #-- Non security admins
  common_groups_on_security_cmp = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => compact([values["net-group"] != null ? "${values["net-group"]}" : "", values["app-group"] != null ? "${values["app-group"]}" : "", values["db-group"] != null ? "${values["db-group"]}" : "", values["exa-group"] != null ? "${values["exa-group"]}" : ""])
  if contains(split(",",values["cmp-type"]),"security")}

  #-- Common grants on Security compartment to non security admins
  common_grants_on_security_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"security")) ? [
      "allow group ${join(",",local.common_groups_on_security_cmp[k])} to read vss-family in compartment ${values["name"]}",
      "allow group ${join(",",local.common_groups_on_security_cmp[k])} to use vaults in compartment ${values["name"]}",
      "allow group ${join(",",local.common_groups_on_security_cmp[k])} to use bastion in compartment ${values["name"]}",
      "allow group ${join(",",local.common_groups_on_security_cmp[k])} to manage bastion-session in compartment ${values["name"]}",
      "allow group ${join(",",local.common_groups_on_security_cmp[k])} to read logging-family in compartment ${values["name"]}"
    ] : []
  }  

  #-- Storage admin grants on Security compartment
  storage_admin_grants_on_security_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"security") && values["stg-group"] != null) ? [
      # Object Storage
      "allow group ${values["stg-group"]} to read bucket in compartment ${values["name"]}",
      "allow group ${values["stg-group"]} to inspect object in compartment ${values["name"]}",
      "allow group ${values["stg-group"]} to manage object-family in compartment ${values["name"]} where any {request.permission = 'OBJECT_DELETE', request.permission = 'BUCKET_DELETE'}",
      # Volume Storage
      "allow group ${values["stg-group"]} to read volume-family in compartment ${values["name"]}",
      "allow group ${values["stg-group"]} to manage volume-family in compartment ${values["name"]} where any {request.permission = 'VOLUME_DELETE', request.permission = 'VOLUME_BACKUP_DELETE', request.permission = 'BOOT_VOLUME_BACKUP_DELETE'}",
      # File Storage
      "allow group ${values["stg-group"]} to read file-family in compartment ${values["name"]}",
      "allow group ${values["stg-group"]} to manage file-family in compartment ${values["name"]} where any {request.permission = 'FILE_SYSTEM_DELETE', request.permission = 'MOUNT_TARGET_DELETE', request.permission = 'EXPORT_SET_UPDATE', request.permission = 'FILE_SYSTEM_NFSv3_UNEXPORT', request.permission = 'EXPORT_SET_DELETE', request.permission = 'FILE_SYSTEM_DELETE_SNAPSHOT'}"
    ] : []
  } 

  #-- Database grants on Security compartment
  database_kms_grants_on_security_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"security") && values["db-dyn-group"] != null) ? [
      "allow dynamic-group ${values["db-dyn-group"]} to use vaults in compartment ${values["name"]}"
    ] : []
  }  
 
  #-- Policies for compartments marked as security compartments (values["cmp-type"] == "security").
  security_cmps_policies = {
    for k, values in local.cmp_name_to_cislz_tag_map : 
      (upper("${k}-security-policy")) => {
        name             = length(regexall("^${local.policy_name_prefix}", values["name"])) > 0 ? (length(split(",",values["cmp-type"])) > 1 ? "${values["name"]}-security${local.policy_name_suffix}" : "${values["name"]}${local.policy_name_suffix}") : (length(split(",",values["cmp-type"])) > 1 ? "${local.policy_name_prefix}${values["name"]}-security${local.policy_name_suffix}" : "${local.policy_name_prefix}${values["name"]}${local.policy_name_suffix}")
        compartment_id   = values.ocid
        description      = "CIS Landing Zone policy for Security compartment."
        defined_tags     = var.policies_configuration.defined_tags
        freeform_tags    = var.policies_configuration.freeform_tags
        statements       = concat(local.security_read_grants_on_security_cmp_map[k],local.security_admin_grants_on_security_cmp_map[k],
                                  local.common_grants_on_security_cmp_map[k],
                                  local.storage_admin_grants_on_security_cmp_map[k],local.database_kms_grants_on_security_cmp_map[k])
      }
    if contains(split(",",values["cmp-type"]),"security")
  }
}
