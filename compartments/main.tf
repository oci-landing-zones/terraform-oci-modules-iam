# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  level_1 = [
    for k1, v1 in(var.compartments_configuration != null ? var.compartments_configuration.compartments : {}) : {
      key           = k1
      name          = v1.name
      description   = v1.description
      parent_ocid   = v1.parent_id != null ? (length(regexall("^ocid1.*$", v1.parent_id)) > 0 ? v1.parent_id : (upper(v1.parent_id) == "TENANCY-ROOT" ? var.tenancy_ocid : var.compartments_dependency[v1.parent_id].id)) : var.compartments_configuration.default_parent_id != null ? (length(regexall("^ocid1.*$", var.compartments_configuration.default_parent_id)) > 0 ? var.compartments_configuration.default_parent_id : (upper(var.compartments_configuration.default_parent_id) == "TENANCY-ROOT" ? var.tenancy_ocid : var.compartments_dependency[var.compartments_configuration.default_parent_id].id)) : var.tenancy_ocid
      defined_tags  = v1.defined_tags != null ? v1.defined_tags : var.compartments_configuration.default_defined_tags != null ? var.compartments_configuration.default_defined_tags : null
      freeform_tags = v1.freeform_tags != null ? v1.freeform_tags : var.compartments_configuration.default_freeform_tags != null ? var.compartments_configuration.default_freeform_tags : null
      tag_defaults  = v1.tag_defaults
      enable_delete = var.compartments_configuration.enable_delete != null ? var.compartments_configuration.enable_delete : false
    }
  ]

  level_2 = flatten([
    for k1, v1 in(var.compartments_configuration != null ? var.compartments_configuration.compartments : {}) : [
      for k2, v2 in v1.children : {
        key           = var.derive_keys_from_hierarchy ? format("%s-%s", k1, k2) : k2
        name          = v2.name
        description   = v2.description
        parent_ocid   = oci_identity_compartment.these[k1].id
        defined_tags  = v2.defined_tags != null ? v2.defined_tags : var.compartments_configuration.default_defined_tags != null ? var.compartments_configuration.default_defined_tags : null
        freeform_tags = v2.freeform_tags != null ? v2.freeform_tags : var.compartments_configuration.default_freeform_tags != null ? var.compartments_configuration.default_freeform_tags : null
        tag_defaults  = v2.tag_defaults
        enable_delete = var.compartments_configuration.enable_delete != null ? var.compartments_configuration.enable_delete : false
      }
    ] if v1.children != null
  ])

  level_3 = flatten([
    for k1, v1 in(var.compartments_configuration != null ? var.compartments_configuration.compartments : {}) : [
      for k2, v2 in v1.children : [
        for k3, v3 in v2.children : {
          key           = var.derive_keys_from_hierarchy ? format("%s-%s-%s", k1, k2, k3) : k3
          name          = v3.name
          description   = v3.description
          parent_ocid   = var.derive_keys_from_hierarchy ? oci_identity_compartment.level_2["${k1}-${k2}"].id : oci_identity_compartment.level_2[k2].id
          defined_tags  = v3.defined_tags != null ? v3.defined_tags : var.compartments_configuration.default_defined_tags != null ? var.compartments_configuration.default_defined_tags : null
          freeform_tags = v3.freeform_tags != null ? v3.freeform_tags : var.compartments_configuration.default_freeform_tags != null ? var.compartments_configuration.default_freeform_tags : null
          tag_defaults  = v3.tag_defaults
          enable_delete = var.compartments_configuration.enable_delete != null ? var.compartments_configuration.enable_delete : false
        }
      ] if v2.children != null
    ] if v1.children != null
  ])

  level_4 = flatten([
    for k1, v1 in(var.compartments_configuration != null ? var.compartments_configuration.compartments : {}) : [
      for k2, v2 in v1.children : [
        for k3, v3 in v2.children : [
          for k4, v4 in v3.children : {
            key           = var.derive_keys_from_hierarchy ? format("%s-%s-%s-%s", k1, k2, k3, k4) : k4
            name          = v4.name
            description   = v4.description
            parent_ocid   = var.derive_keys_from_hierarchy ? oci_identity_compartment.level_3["${k1}-${k2}-${k3}"].id : oci_identity_compartment.level_3[k3].id
            defined_tags  = v4.defined_tags != null ? v4.defined_tags : var.compartments_configuration.default_defined_tags != null ? var.compartments_configuration.default_defined_tags : null
            freeform_tags = v4.freeform_tags != null ? v4.freeform_tags : var.compartments_configuration.default_freeform_tags != null ? var.compartments_configuration.default_freeform_tags : null
            tag_defaults  = v4.tag_defaults
            enable_delete = var.compartments_configuration.enable_delete != null ? var.compartments_configuration.enable_delete : false
          }
        ] if v3.children != null
      ] if v2.children != null
    ] if v1.children != null
  ])

  level_5 = flatten([
    for k1, v1 in(var.compartments_configuration != null ? var.compartments_configuration.compartments : {}) : [
      for k2, v2 in v1.children : [
        for k3, v3 in v2.children : [
          for k4, v4 in v3.children : [
            for k5, v5 in v4.children : {
              key           = var.derive_keys_from_hierarchy ? format("%s-%s-%s-%s-%s", k1, k2, k3, k4, k5) : k5
              name          = v5.name
              description   = v5.description
              parent_ocid   = var.derive_keys_from_hierarchy ? oci_identity_compartment.level_4["${k1}-${k2}-${k3}-${k4}"].id : oci_identity_compartment.level_4[k4].id
              defined_tags  = v5.defined_tags != null ? v5.defined_tags : var.compartments_configuration.default_defined_tags != null ? var.compartments_configuration.default_defined_tags : null
              freeform_tags = v5.freeform_tags != null ? v5.freeform_tags : var.compartments_configuration.default_freeform_tags != null ? var.compartments_configuration.default_freeform_tags : null
              tag_defaults  = v5.tag_defaults
              enable_delete = var.compartments_configuration.enable_delete != null ? var.compartments_configuration.enable_delete : false
            }
          ] if v4.children != null
        ] if v3.children != null
      ] if v2.children != null
    ] if v1.children != null
  ])

  level_6 = flatten([
    for k1, v1 in(var.compartments_configuration != null ? var.compartments_configuration.compartments : {}) : [
      for k2, v2 in v1.children : [
        for k3, v3 in v2.children : [
          for k4, v4 in v3.children : [
            for k5, v5 in v4.children : [
              for k6, v6 in v5.children : {
                key           = var.derive_keys_from_hierarchy ? format("%s-%s-%s-%s-%s-%s", k1, k2, k3, k4, k5, k6) : k6
                name          = v6.name
                description   = v6.description
                parent_ocid   = var.derive_keys_from_hierarchy ? oci_identity_compartment.level_5["${k1}-${k2}-${k3}-${k4}-${k5}"].id : oci_identity_compartment.level_5[k5].id
                defined_tags  = v6.defined_tags != null ? v6.defined_tags : var.compartments_configuration.default_defined_tags != null ? var.compartments_configuration.default_defined_tags : null
                freeform_tags = v6.freeform_tags != null ? v6.freeform_tags : var.compartments_configuration.default_freeform_tags != null ? var.compartments_configuration.default_freeform_tags : null
                tag_defaults  = v6.tag_defaults
                enable_delete = var.compartments_configuration.enable_delete != null ? var.compartments_configuration.enable_delete : false
              }
            ] if v5.children != null
          ] if v4.children != null
        ] if v3.children != null
      ] if v2.children != null
    ] if v1.children != null
  ])

  all_input_compartments = concat(local.level_1, local.level_2, local.level_3, local.level_4, local.level_5, local.level_6)
  all_processed_compartments = merge(oci_identity_compartment.these, oci_identity_compartment.level_2,
    oci_identity_compartment.level_3, oci_identity_compartment.level_4,
  oci_identity_compartment.level_5, oci_identity_compartment.level_6)
  tag_defaults = flatten([
    for cmp in local.all_input_compartments : [
      for k, v in cmp.tag_defaults : {
        key               = "${k}.${substr(v.tag_id, -22, -1)}"
        tag_definition_id = length(regexall("^ocid1.*$", v.tag_id)) > 0 ? v.tag_id : var.tags_dependency[v.tag_id].id
        compartment_id    = local.all_processed_compartments[cmp.key].id
        default_value     = v.default_value
        is_user_required  = v.is_user_required != null ? v.is_user_required : false
      }
    ] if cmp.tag_defaults != null
  ])
}

resource "oci_identity_compartment" "these" {
  for_each = { for c in local.level_1 : c.key => { name : c.name,
    description : c.description,
    parent_ocid : c.parent_ocid,
    defined_tags : c.defined_tags,
    freeform_tags : c.freeform_tags,
  enable_delete : c.enable_delete } }
  compartment_id = each.value.parent_ocid
  name           = each.value.name
  description    = each.value.description
  enable_delete  = each.value.enable_delete
  defined_tags   = each.value.defined_tags
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags)
}

resource "oci_identity_compartment" "level_2" {
  for_each = { for c in local.level_2 : c.key => { name : c.name,
    description : c.description,
    parent_ocid : c.parent_ocid,
    defined_tags : c.defined_tags,
    freeform_tags : c.freeform_tags,
  enable_delete : c.enable_delete } }
  compartment_id = each.value.parent_ocid
  name           = each.value.name
  description    = each.value.description
  enable_delete  = each.value.enable_delete
  defined_tags   = each.value.defined_tags
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags)
}

resource "oci_identity_compartment" "level_3" {
  for_each = { for c in local.level_3 : c.key => { name : c.name,
    description : c.description,
    parent_ocid : c.parent_ocid,
    defined_tags : c.defined_tags,
    freeform_tags : c.freeform_tags,
  enable_delete : c.enable_delete } }
  compartment_id = each.value.parent_ocid
  name           = each.value.name
  description    = each.value.description
  enable_delete  = each.value.enable_delete
  defined_tags   = each.value.defined_tags
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags)
}

resource "oci_identity_compartment" "level_4" {
  for_each = { for c in local.level_4 : c.key => { name : c.name,
    description : c.description,
    parent_ocid : c.parent_ocid,
    defined_tags : c.defined_tags,
    freeform_tags : c.freeform_tags,
  enable_delete : c.enable_delete } }
  compartment_id = each.value.parent_ocid
  name           = each.value.name
  description    = each.value.description
  enable_delete  = each.value.enable_delete
  defined_tags   = each.value.defined_tags
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags)
}

resource "oci_identity_compartment" "level_5" {
  for_each = { for c in local.level_5 : c.key => { name : c.name,
    description : c.description,
    parent_ocid : c.parent_ocid,
    defined_tags : c.defined_tags,
    freeform_tags : c.freeform_tags,
  enable_delete : c.enable_delete } }
  compartment_id = each.value.parent_ocid
  name           = each.value.name
  description    = each.value.description
  enable_delete  = each.value.enable_delete
  defined_tags   = each.value.defined_tags
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags)
}

resource "oci_identity_compartment" "level_6" {
  for_each = { for c in local.level_6 : c.key => { name : c.name,
    description : c.description,
    parent_ocid : c.parent_ocid,
    defined_tags : c.defined_tags,
    freeform_tags : c.freeform_tags,
  enable_delete : c.enable_delete } }
  compartment_id = each.value.parent_ocid
  name           = each.value.name
  description    = each.value.description
  enable_delete  = each.value.enable_delete
  defined_tags   = each.value.defined_tags
  freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags)
}

resource "oci_identity_tag_default" "these" {
  for_each = { for td in local.tag_defaults : td.key => { tag_definition_id = td.tag_definition_id
    compartment_id = td.compartment_id
    default_value  = td.default_value
  is_user_required = td.is_user_required } }
  compartment_id    = each.value.compartment_id
  tag_definition_id = each.value.tag_definition_id
  value             = each.value.default_value
  is_required       = each.value.is_user_required
}