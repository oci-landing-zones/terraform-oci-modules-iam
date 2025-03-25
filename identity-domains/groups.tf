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
  for_each = var.identity_domain_groups_configuration != null ? var.identity_domain_groups_configuration.groups : {}
    lifecycle {
      precondition {
        condition = length(setsubtract(toset(each.value.members),toset([for m in each.value.members : m if contains(keys(local.users[each.key]),m)]))) == 0
        error_message = "VALIDATION FAILURE: following provided usernames in \"members\" attribute of group \"${each.key}\" do not exist or are not active\": ${join(", ",setsubtract(toset(each.value.members),toset([for m in each.value.members : m if contains(keys(local.users[each.key]),m)])))}. Please either correct their spelling or activate them."
      }
    }

    attribute_sets = ["all"]
    idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"None") ) ? oci_identity_domain.these[var.identity_domain_groups_configuration.default_identity_domain_id].url : data.oci_identity_domain.grp_domain[each.key].url)
  
    display_name            = each.value.name
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group","urn:ietf:params:scim:schemas:oracle:idcs:extension:group:Group","urn:ietf:params:scim:schemas:extension:custom:2.0:Group"]
    urnietfparamsscimschemasoracleidcsextensiongroup_group {
        creation_mechanism = "api"
        description = each.value.description
    }
    urnietfparamsscimschemasoracleidcsextensionrequestable_group {
        requestable =  each.value.requestable
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
            for_each = each.value.freeform_tags != null ? each.value.freeform_tags : (var.identity_domain_groups_configuration.default_freeform_tags !=null ? var.identity_domain_groups_configuration.default_freeform_tags : {})
               content {
                 key = freeform_tags["key"]
                 value = freeform_tags["value"]
               }
        }

    }
}