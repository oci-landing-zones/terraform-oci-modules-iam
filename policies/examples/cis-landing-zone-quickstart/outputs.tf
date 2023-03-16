# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "cmp_name_to_cislz_tag_map" {
  value = module.cislz_policies.map_of_compartments_tagged_with_cislz_tag_lookup_value
}

output "cmp_type_list" {
  value = module.cislz_policies.list_of_compartments_types_tagged_with_cislz_tag_lookup_value
}