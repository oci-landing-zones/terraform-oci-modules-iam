# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

resource "oci_identity_dynamic_group" "these" {
  for_each       = var.dynamic_groups_configuration != null ? var.dynamic_groups_configuration.dynamic_groups : {}
  name           = each.value.name
  description    = each.value.description
  compartment_id = var.tenancy_ocid
  matching_rule  = each.value.matching_rule
  defined_tags   = each.value.defined_tags != null ? each.value.defined_tags : var.dynamic_groups_configuration.default_defined_tags != null ? var.dynamic_groups_configuration.default_defined_tags : null
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.dynamic_groups_configuration.default_freeform_tags != null ? var.dynamic_groups_configuration.default_freeform_tags : null)
}