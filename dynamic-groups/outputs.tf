# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "dynamic_groups" {
  description = "The dynamic groups."
  value       = oci_identity_dynamic_group.these
}