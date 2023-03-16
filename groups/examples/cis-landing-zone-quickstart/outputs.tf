# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "groups" {
  description = "The groups."
  value       = module.cislz_groups.groups
}

output "memberships" {
  description = "The memberships."
  value       = module.cislz_groups.memberships
}
