# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #--------------------------------------------------------------------------------------------
  #-- Application compartments policies
  #--------------------------------------------------------------------------------------------
  
  #-- Application read grants on application compartment
  application_read_grants_on_application_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"application") && values["read-group"] != null) ? [
      "allow group ${values["read-group"]} to read all-resources in compartment ${values["name"]}"
    ] : []
  }

  #-- Application admin grants on application compartment
  application_admin_grants_on_application_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"application") && values["app-group"] != null) ? [
      "allow group ${values["app-group"]} to read all-resources in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage functions-family in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage api-gateway-family in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage ons-family in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage streams in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage cluster-family in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage alarms in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage metrics in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage logging-family in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage instance-family in compartment ${values["name"]}",
      # CIS 1.2 - 1.14 Level 2 
      "allow group ${values["app-group"]} to manage volume-family in compartment ${values["name"]} where all{request.permission != 'VOLUME_BACKUP_DELETE', request.permission != 'VOLUME_DELETE', request.permission != 'BOOT_VOLUME_BACKUP_DELETE'}",
      "allow group ${values["app-group"]} to manage object-family in compartment ${values["name"]} where all{request.permission != 'OBJECT_DELETE', request.permission != 'BUCKET_DELETE'}",
      "allow group ${values["app-group"]} to manage file-family in compartment ${values["name"]} where all{request.permission != 'FILE_SYSTEM_DELETE', request.permission != 'MOUNT_TARGET_DELETE', request.permission != 'EXPORT_SET_DELETE', request.permission != 'FILE_SYSTEM_DELETE_SNAPSHOT', request.permission != 'FILE_SYSTEM_NFSv3_UNEXPORT'}",
      "allow group ${values["app-group"]} to manage repos in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage orm-stacks in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage orm-jobs in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage orm-config-source-providers in compartment ${values["name"]}",
      #"allow group ${values["app-group"]} to read audit-events in compartment ${values["name"]}",
      #"allow group ${values["app-group"]} to read work-requests in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage bastion-session in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage cloudevents-rules in compartment ${values["name"]}",
      #"allow group ${values["app-group"]} to read instance-agent-plugins in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to use vnics in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage keys in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to use key-delegate in compartment ${values["name"]}",
      "allow group ${values["app-group"]} to manage secret-family in compartment ${values["name"]}"
    ] : []
  }  

  #-- Storage admin grants on application compartment
  storage_admin_grants_on_application_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"application") && values["stg-group"] != null) ? [
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

  #-- Compute Agent grants on application compartment
  compute_agent_grants_on_application_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"application") && values["ca-dyn-group"] != null) ? [
      "allow dynamic-group ${values["ca-dyn-group"]} to manage management-agents in compartment ${values["name"]}",
      "allow dynamic-group ${values["ca-dyn-group"]} to use metrics in compartment ${values["name"]}",
      "allow dynamic-group ${values["ca-dyn-group"]} to use tag-namespaces in compartment ${values["name"]}"
    ] : []
  }  

  #-- Security admin grants on application compartment
  security_admin_grants_on_application_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"application") && values["sec-group"] != null) ? [
      "allow group ${values["sec-group"]} to read keys in compartment ${values["name"]}"
    ] : []
  }

  oke_cluster_grants_on_application_cmp_map = {
    for k, values in local.cmp_name_to_cislz_tag_map : k => (contains(split(",",values["cmp-type"]),"application")) && local.enable_oke_service_policies ? [
      "allow any-user to manage instances in compartment ${values["name"]} where all { request.principal.type = 'cluster', request.principal.compartment.id = '${values["ocid"]}' }"
    ] : []
  }

  #-- Policies for compartments marked as application compartments (values["cmp-type"] == "application").
  application_cmps_policies = {
    for k, values in local.cmp_name_to_cislz_tag_map : 
      (upper("${k}-application-policy")) => {
        name             = length(regexall("^${local.policy_name_prefix}", values["name"])) > 0 ? (length(split(",",values["cmp-type"])) > 1 ? "${values["name"]}-application${local.policy_name_suffix}" : "${values["name"]}${local.policy_name_suffix}") : (length(split(",",values["cmp-type"])) > 1 ? "${local.policy_name_prefix}${values["name"]}-application${local.policy_name_suffix}" : "${local.policy_name_prefix}${values["name"]}${local.policy_name_suffix}")
        compartment_id   = values.ocid
        description      = "Core Landing Zone policy for Application compartment."
        defined_tags     = var.policies_configuration.defined_tags
        freeform_tags    = var.policies_configuration.freeform_tags
        statements       = concat(local.application_admin_grants_on_application_cmp_map[k],local.application_read_grants_on_application_cmp_map[k],
                                  local.storage_admin_grants_on_application_cmp_map[k],local.security_admin_grants_on_application_cmp_map[k],
                                  local.compute_agent_grants_on_application_cmp_map[k],local.oke_cluster_grants_on_application_cmp_map[k])
      }
    if contains(split(",",values["cmp-type"]),"application")
  }
}