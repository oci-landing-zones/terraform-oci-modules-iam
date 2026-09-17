# Copyright (c) 2026 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "tag_defaults" {
  description = "The tag defaults."
  value       = oci_identity_tag_default.these
}
