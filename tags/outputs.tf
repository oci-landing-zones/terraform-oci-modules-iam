# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "tag_namespaces" {
  description = "The tag namespaces."
  value = oci_identity_tag_namespace.these
}

output "tags" {
  description = "The tags."
  value = oci_identity_tag.these
}