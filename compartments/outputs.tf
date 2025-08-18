# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "compartments" {
  description = "The compartments in a single flat map."
  value       = merge(oci_identity_compartment.these, oci_identity_compartment.level_2, oci_identity_compartment.level_3, oci_identity_compartment.level_4, oci_identity_compartment.level_5, oci_identity_compartment.level_6)
}

output "tag_defaults" {
  description = "The tag defaults."
  value       = oci_identity_tag_default.these
}