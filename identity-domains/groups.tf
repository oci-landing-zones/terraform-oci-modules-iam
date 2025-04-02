# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_domain" "grp_domain" {
  for_each = (var.identity_domain_groups_configuration != null ) ? (var.identity_domain_groups_configuration["groups"] != null ? var.identity_domain_groups_configuration["groups"] : {}) : {}
    domain_id = each.value.identity_domain_id != null ? each.value.identity_domain_id : var.identity_domain_groups_configuration.default_identity_domain_id
}

data "oci_identity_domains_users" "these" {
  for_each = var.identity_domain_groups_configuration != null ? (var.identity_domain_groups_configuration.groups != null ? var.identity_domain_groups_configuration.groups : {} ): {}
    idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"None") ) ? oci_identity_domain.these[var.identity_domain_groups_configuration.default_identity_domain_id].url : data.oci_identity_domain.grp_domain[each.key].url)
    user_filter = "active eq true" # Only active users are looked up. 
}

locals {
  users =  { for k,g in (var.identity_domain_groups_configuration != null ? var.identity_domain_groups_configuration["groups"]: {}) : k =>
      { for u in data.oci_identity_domains_users.these[k].users : u.user_name => u.id}}
}

resource "oci_identity_domains_group" "these" {
  for_each = var.identity_domain_groups_configuration != null ? (try(var.identity_domain_groups_configuration.ignore_external_membership_updates,true) == true ? var.identity_domain_groups_configuration.groups : {}) : {}
    lifecycle {
      ignore_changes = [ members ]
      precondition {
        condition = each.value.members != null ? length(setsubtract(toset(each.value.members),toset([for m in each.value.members : m if contains(keys(local.users[each.key]),m)]))) == 0 : true
        error_message = each.value.members != null ? "VALIDATION FAILURE: following provided usernames in \"members\" attribute of group \"${each.key}\" do not exist or are not active\": ${join(", ",setsubtract(toset(each.value.members),toset([for m in each.value.members : m if contains(keys(local.users[each.key]),m)])))}. Please either correct their spelling or activate them." : ""
      }
    }
    #attribute_sets = ["all"]
    idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"None") ) ? oci_identity_domain.these[var.identity_domain_groups_configuration.default_identity_domain_id].url : data.oci_identity_domain.grp_domain[each.key].url)
  
    display_name = each.value.name
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group","urn:ietf:params:scim:schemas:oracle:idcs:extension:requestable:Group","urn:ietf:params:scim:schemas:oracle:idcs:extension:OCITags","urn:ietf:params:scim:schemas:oracle:idcs:extension:group:Group"]
    urnietfparamsscimschemasoracleidcsextensiongroup_group {
        creation_mechanism = "api"
        description = each.value.description
    }
    dynamic "members" {
      for_each = each.value.members != null ? each.value.members : []
        content {
          type = "User"
          value = local.users[each.key][members["value"]]
        }
    }
    urnietfparamsscimschemasoracleidcsextension_oci_tags {
      dynamic "defined_tags" {
        for_each = each.value.defined_tags != null ? each.value.defined_tags : (var.identity_domain_groups_configuration.default_defined_tags !=null ? var.identity_domain_groups_configuration.default_defined_tags : {})
          content {
            key = split(".",defined_tags["key"])[1]
            namespace = split(".",defined_tags["key"])[0]
            value = defined_tags["value"]
          }
      }
      dynamic "freeform_tags" {
        for_each = each.value.freeform_tags != null ? merge(local.cislz_module_tag,each.value.freeform_tags) : (var.identity_domain_groups_configuration.default_freeform_tags != null ? merge(local.cislz_module_tag,var.identity_domain_groups_configuration.default_freeform_tags) : local.cislz_module_tag)
        content {
          key = freeform_tags["key"]
          value = freeform_tags["value"]
        }
      }
    }
    urnietfparamsscimschemasoracleidcsextensionrequestable_group {
        requestable =  each.value.requestable
    }
}

resource "oci_identity_domains_group" "these_with_external_membership_updates" {
  for_each = var.identity_domain_groups_configuration != null ? (try(var.identity_domain_groups_configuration.ignore_external_membership_updates,true) == false ? var.identity_domain_groups_configuration.groups : {}) : {}
    lifecycle {
      precondition {
        condition = each.value.members != null ? length(setsubtract(toset(each.value.members),toset([for m in each.value.members : m if contains(keys(local.users[each.key]),m)]))) == 0 : true
        error_message = each.value.members != null ? "VALIDATION FAILURE: following provided usernames in \"members\" attribute of group \"${each.key}\" do not exist or are not active\": ${join(", ",setsubtract(toset(each.value.members),toset([for m in each.value.members : m if contains(keys(local.users[each.key]),m)])))}. Please either correct their spelling or activate them." : ""
      }
    }
    #attribute_sets = ["all"]
    idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"None") ) ? oci_identity_domain.these[var.identity_domain_groups_configuration.default_identity_domain_id].url : data.oci_identity_domain.grp_domain[each.key].url)
  
    display_name = each.value.name
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group","urn:ietf:params:scim:schemas:oracle:idcs:extension:requestable:Group","urn:ietf:params:scim:schemas:oracle:idcs:extension:OCITags","urn:ietf:params:scim:schemas:oracle:idcs:extension:group:Group"]
    urnietfparamsscimschemasoracleidcsextensiongroup_group {
        creation_mechanism = "api"
        description = each.value.description
    }
    dynamic "members" {
      for_each = each.value.members != null ? each.value.members : []
        content {
          type = "User"
          value = local.users[each.key][members["value"]]
        }
    }
    urnietfparamsscimschemasoracleidcsextension_oci_tags {
      dynamic "defined_tags" {
        for_each = each.value.defined_tags != null ? each.value.defined_tags : (var.identity_domain_groups_configuration.default_defined_tags !=null ? var.identity_domain_groups_configuration.default_defined_tags : {})
          content {
            key = split(".",defined_tags["key"])[1]
            namespace = split(".",defined_tags["key"])[0]
            value = defined_tags["value"]
          }
      }
      dynamic "freeform_tags" {
        for_each = each.value.freeform_tags != null ? merge(local.cislz_module_tag,each.value.freeform_tags) : (var.identity_domain_groups_configuration.default_freeform_tags != null ? merge(local.cislz_module_tag,var.identity_domain_groups_configuration.default_freeform_tags) : local.cislz_module_tag)
        content {
          key = freeform_tags["key"]
          value = freeform_tags["value"]
        }
      }
      freeform_tags {
        key = keys(local.cislz_module_tag)[0]
        value = local.cislz_module_tag[keys(local.cislz_module_tag)[0]]
      }
    }
    urnietfparamsscimschemasoracleidcsextensionrequestable_group {
        requestable = each.value.requestable
    }
}