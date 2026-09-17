# Copyright (c) 2026 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource "oci_identity_tag_default" "these" {
  for_each = var.tag_defaults_configuration

  compartment_id    = each.value.compartment_id
  tag_definition_id = each.value.tag_definition_id
  value             = each.value.default_value
  is_required       = each.value.is_user_required
}
