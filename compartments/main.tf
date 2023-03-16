# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  level_2 = flatten([
    for k1, v1 in var.compartments : [
      for k2, v2 in v1.children : {
        key  = k2
        name = v2.name
        description = v2.description
        parent_ocid = oci_identity_compartment.these[k1].id
        defined_tags = v2.defined_tags
        freeform_tags = v2.freeform_tags
      } 
    ] if v1.children != null
  ])

  level_3 = flatten([
    for v1 in var.compartments : [
      for k2, v2 in v1.children : [
        for k3, v3 in v2.children : {
          key  = k3
          name = v3.name
          description = v3.description
          parent_ocid = oci_identity_compartment.level_2[k2].id
          defined_tags = v3.defined_tags
          freeform_tags = v3.freeform_tags
        } 
      ] if v2.children != null
    ] if v1.children != null
  ])

  level_4 = flatten([
    for v1 in var.compartments : [
      for v2 in v1.children : [
        for k3, v3 in v2.children : [
          for k4, v4 in v3.children : {
            key  = k4
            name = v4.name
            description = v4.description
            parent_ocid = oci_identity_compartment.level_3[k3].id
            defined_tags = v4.defined_tags
            freeform_tags = v4.freeform_tags
          } 
        ] if v3.children != null  
      ] if v2.children != null
    ] if v1.children != null
  ])

  level_5 = flatten([
    for v1 in var.compartments : [
      for v2 in v1.children : [
        for v3 in v2.children : [
          for k4, v4 in v3.children : [
            for k5, v5 in v4.children : {
              key  = k5
              name = v5.name
              description = v5.description
              parent_ocid = oci_identity_compartment.level_4[k4].id
              defined_tags = v5.defined_tags
              freeform_tags = v5.freeform_tags
            }  
          ] if v4.children != null
        ] if v3.children != null 
      ] if v2.children != null
    ] if v1.children != null
  ])

  level_6 = flatten([
    for v1 in var.compartments : [
      for v2 in v1.children : [
        for v3 in v2.children : [
          for v4 in v3.children : [
            for k5, v5 in v4.children : [
              for k6, v6 in v5.children : {
                key  = k6
                name = v6.name
                description = v6.description
                parent_ocid = oci_identity_compartment.level_5[k5].id
                defined_tags = v6.defined_tags
                freeform_tags = v6.freeform_tags
              } 
            ] if v5.children != null 
          ] if v4.children != null 
        ] if v3.children != null  
      ] if v2.children != null
    ] if v1.children != null
  ])
}

resource "oci_identity_compartment" "these" {
  for_each = var.compartments
    compartment_id = each.value.parent_ocid
    name           = each.value.name
    description    = each.value.description
    enable_delete  = var.enable_compartments_delete
    defined_tags   = each.value.defined_tags
    freeform_tags  = each.value.freeform_tags
}

resource "oci_identity_compartment" "level_2" {
  for_each = {for c in local.level_2 : c.key => {name: c.name, 
                                                 description: c.description,
                                                 parent_ocid: c.parent_ocid,
                                                 defined_tags: c.defined_tags,
                                                 freeform_tags: c.freeform_tags}}
    compartment_id = each.value.parent_ocid
    name           = each.value.name
    description    = each.value.description
    enable_delete  = var.enable_compartments_delete
    defined_tags   = each.value.defined_tags
    freeform_tags  = each.value.freeform_tags
}

resource "oci_identity_compartment" "level_3" {
  for_each = {for c in local.level_3 : c.key => {name: c.name, 
                                                 description: c.description,
                                                 parent_ocid: c.parent_ocid,
                                                 defined_tags: c.defined_tags,
                                                 freeform_tags: c.freeform_tags}}
    compartment_id = each.value.parent_ocid
    name           = each.value.name
    description    = each.value.description
    enable_delete  = var.enable_compartments_delete
    defined_tags   = each.value.defined_tags
    freeform_tags  = each.value.freeform_tags
}

resource "oci_identity_compartment" "level_4" {
  for_each = {for c in local.level_4 : c.key => {name: c.name, 
                                                 description: c.description,
                                                 parent_ocid: c.parent_ocid,
                                                 defined_tags: c.defined_tags,
                                                 freeform_tags: c.freeform_tags}}
    compartment_id = each.value.parent_ocid
    name           = each.value.name
    description    = each.value.description
    enable_delete  = var.enable_compartments_delete
    defined_tags   = each.value.defined_tags
    freeform_tags  = each.value.freeform_tags
}

resource "oci_identity_compartment" "level_5" {
  for_each = {for c in local.level_5 : c.key => {name: c.name, 
                                                 description: c.description,
                                                 parent_ocid: c.parent_ocid,
                                                 defined_tags: c.defined_tags,
                                                 freeform_tags: c.freeform_tags}}
    compartment_id = each.value.parent_ocid
    name           = each.value.name
    description    = each.value.description
    enable_delete  = var.enable_compartments_delete
    defined_tags   = each.value.defined_tags
    freeform_tags  = each.value.freeform_tags
}

resource "oci_identity_compartment" "level_6" {
  for_each = {for c in local.level_6 : c.key => {name: c.name, 
                                                 description: c.description,
                                                 parent_ocid: c.parent_ocid,
                                                 defined_tags: c.defined_tags,
                                                 freeform_tags: c.freeform_tags}}
    compartment_id = each.value.parent_ocid
    name           = each.value.name
    description    = each.value.description
    enable_delete  = var.enable_compartments_delete
    defined_tags   = each.value.defined_tags
    freeform_tags  = each.value.freeform_tags
} 