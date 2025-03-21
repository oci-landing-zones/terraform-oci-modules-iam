# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_domain" "grp_domain" {
  for_each = try(var.identity_domain_groups_configuration.groups,{})
    domain_id = length(regexall("^ocid1.*$", coalesce(each.value.identity_domain_id,"__void__"))) > 0 ? each.value.identity_domain_id : contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"__void__")) ? oci_identity_domain.these[each.value.identity_domain_id].id : "__void__"
}

data "oci_identity_domain" "default_domain" {
  domain_id = length(regexall("^ocid1.*$", coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"__void__"))) > 0 ? var.identity_domain_groups_configuration.default_identity_domain_id : contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"__void__")) ? oci_identity_domain.these[var.identity_domain_groups_configuration.default_identity_domain_id].id : "__void__"
}

data "oci_identity_domains_users" "these" {
  for_each = local.identity_domains
     idcs_endpoint = each.value
     user_filter = "active eq true" # Only active users are looked up. 
}

locals {
  # The group_assignments list is used to build a map with identity domains and their URL endpoints. 
  group_assignments = distinct(flatten([
    for k, v in try(var.identity_domain_groups_configuration.groups,{}) : [{
        identity_domain_key = coalesce(v.identity_domain_id,var.identity_domain_groups_configuration.default_identity_domain_id,"__void__")
        identity_domain_endpoint  = contains(keys(oci_identity_domain.these),coalesce(v.identity_domain_id,"__void__")) ? oci_identity_domain.these[v.identity_domain_id].url : length(regexall("^ocid1.*$", coalesce(v.identity_domain_id,"__void"))) > 0 ? data.oci_identity_domain.grp_domain[k].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"__void__") ) ? oci_identity_domain.these[var.identity_domain_groups_configuration.default_identity_domain_id].url : length(regexall("^ocid1.*$", coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"__void__"))) > 0 ? data.oci_identity_domain.default_domain.url : "__void__")
    }] if v.members != null
  ]))

  # Map of identity domains indexed by their user provided domain key. The value is the identity domain URL. It drives user lookup. See data source "oci_identity_domains_users" above.
  identity_domains = {for ga in local.group_assignments : ga.identity_domain_key => ga.identity_domain_endpoint}

  # Map of identity domains containing all their respective users.
  all_users =  { for k,v in local.identity_domains : k => [for u in try(data.oci_identity_domains_users.these[k].users,[]) : u]}
  
  # Filtered map
  users = { for k,v in local.identity_domains : k => {for u in local.all_users[k] : u.user_name => u.id if length([for u1 in local.all_users[k] : u1.user_name if u1.user_name == u.user_name]) == 1} }
}

resource "oci_identity_domains_group" "these" {
  for_each = try(var.identity_domain_groups_configuration.groups,{})

    lifecycle {
      precondition {
        condition = length(setsubtract(toset(each.value.members),toset([for m in each.value.members : m if contains(keys(local.users[coalesce(each.value.identity_domain_id,var.identity_domain_groups_configuration.default_identity_domain_id,"__void__")]),m)]))) == 0
        error_message = "VALIDATION FAILURE: following provided usernames in members attribute of group \"${each.key}\" do not exist or are not active in identity domain \"${coalesce(each.value.identity_domain_id,var.identity_domain_groups_configuration.default_identity_domain_id,"__void__")}\": ${join(", ",setsubtract(toset(each.value.members),toset([for m in each.value.members : m if contains(keys(local.users[coalesce(each.value.identity_domain_id,var.identity_domain_groups_configuration.default_identity_domain_id,"__void__")]),m)])))}. Please either correct their spelling or activate them."
      }
    }

    attribute_sets = ["all"]
    idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"__void__")) ? oci_identity_domain.these[each.value.identity_domain_id].url : length(regexall("^ocid1.*$", coalesce(each.value.identity_domain_id,"__void__"))) > 0 ? data.oci_identity_domain.grp_domain[each.key].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"__void__") ) ? oci_identity_domain.these[var.identity_domain_groups_configuration.default_identity_domain_id].url : length(regexall("^ocid1.*$", coalesce(var.identity_domain_groups_configuration.default_identity_domain_id,"__void__"))) > 0 ? data.oci_identity_domain.default_domain.url : "__void__")
  
    display_name = each.value.name
    schemas = ["urn:ietf:params:scim:schemas:core:2.0:Group","urn:ietf:params:scim:schemas:oracle:idcs:extension:group:Group","urn:ietf:params:scim:schemas:extension:custom:2.0:Group"]

    urnietfparamsscimschemasoracleidcsextensiongroup_group {
        creation_mechanism = "api"
        description = each.value.description
    }

    urnietfparamsscimschemasoracleidcsextensionrequestable_group {
        requestable =  each.value.requestable
    }
    
    dynamic "members" {
      for_each = try(each.value.members,[])
        content {
          type = "User"
          value = local.users[coalesce(each.value.identity_domain_id,var.identity_domain_groups_configuration.default_identity_domain_id,"__void__")][members["value"]]
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