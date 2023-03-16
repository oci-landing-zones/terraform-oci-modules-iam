# Copyright (c) 2022 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "policies" {
  description = "The policies. Enabled if enable_output variable is true."
  value = var.enable_output ? oci_identity_policy.these : null
} 

output "map_of_compartments_tagged_with_cislz_tag_lookup_value" {
  description = "An internal map driving the assignment of pre-configured policies according to cislz tags. Enabled if enable_debug variable is true."
  value = var.enable_debug ? local.cmp_name_to_cislz_tag_map : null
}

output "list_of_compartments_types_tagged_with_cislz_tag_lookup_value" {
  description = "An internal list with compartments tagged with cislz_tag_lookup_value. Used to find if an enclosing compartment is available. Enabled if enable_debug variable is true."
  value = var.enable_debug ? local.cmp_type_list : null
}