# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "groups" {
  description = "The groups."
  value       = oci_identity_group.these
}

output "memberships" {
  description = "The group memberships."
  value       = oci_identity_user_group_membership.these
}

output "debug_ignored_users" {
  description = "(Debug) Ignored users."
  value       = try(var.groups_configuration.enable_debug, false) ? [for u in local.all_users : { "id" : u.id, "email" : u.email, "name" : u.name } if length([for u1 in local.all_users : u1.name if u1.name == u.name]) > 1] : null
}