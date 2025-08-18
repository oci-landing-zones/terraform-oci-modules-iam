# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_users" "these" {
  count          = length(local.group_memberships) > 0 ? 1 : 0
  compartment_id = var.tenancy_ocid
  state          = "ACTIVE"
}

resource "oci_identity_group" "these" {
  for_each       = var.groups_configuration != null ? var.groups_configuration.groups : {}
  compartment_id = var.tenancy_ocid
  name           = each.value.name
  description    = each.value.description
  defined_tags   = each.value.defined_tags != null ? each.value.defined_tags : var.groups_configuration.default_defined_tags != null ? var.groups_configuration.default_defined_tags : null
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.groups_configuration.default_freeform_tags != null ? var.groups_configuration.default_freeform_tags : null)
}

resource "oci_identity_user_group_membership" "these" {
  for_each = { for m in local.group_memberships : "${m.group_key}.${m.user_name}" => m... if contains(keys(local.users), m.user_name) }
  group_id = oci_identity_group.these[split(".", each.key)[0]].id
  user_id  = local.users[each.value[0].user_name].id
}

locals {
  all_users = [for u in try(data.oci_identity_users.these[0].users, []) : u]
  users     = { for u in local.all_users : u.name => u if length([for u1 in local.all_users : u1.name if u1.name == u.name]) == 1 }

  #users  = { for u in try(data.oci_identity_users.these.users,[]) : u.name => u... }

  group_memberships = flatten([
    for k, v in(var.groups_configuration != null ? var.groups_configuration.groups : {}) : [
      for name in v.members : {
        group_key = k
        user_name = name
      }
    ] if v.members != null
  ])
}