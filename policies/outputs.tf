# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "policies" {
  description = "The policies. Enabled if enable_output attribute is true."
  value       = local.enable_output ? oci_identity_policy.these : null
}

output "template_target_compartments" {
  description = "An internal map driving the assignment of template policies according to compartment metadata. Enabled if enable_debug attribute is true."
  value       = local.enable_debug ? local.cmp_name_to_cislz_tag_map : null
}