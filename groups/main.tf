# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_users" "these" {
  compartment_id = var.tenancy_ocid
}

resource "oci_identity_group" "these" {
  for_each       = var.groups
    compartment_id = var.tenancy_ocid
    name           = each.value.name
    description    = each.value.description
    defined_tags   = each.value.defined_tags 
    freeform_tags  = each.value.freeform_tags
}

resource "oci_identity_user_group_membership" "these" {
  for_each = { for m in local.group_memberships : "${m.group_key}.${m.user_name}" => m }
    group_id = oci_identity_group.these[split(".",each.key)[0]].id
    user_id  = local.users[each.value.user_name].id
}

locals {
  users  = { for u in data.oci_identity_users.these.users : u.name => u }

  group_memberships = flatten([
    for k, v in var.groups : [
      for name in v.members : {
        group_key  = k
        user_name  = name
      }
    ] if v.members != null
  ])
}