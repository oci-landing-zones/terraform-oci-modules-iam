# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#-- This module creates tag namespaces, tags and tag defaults 

locals {
  #---------------------------------------------------------------------------
  #-- CIS required namespace - only if Oracle-Tags namespace is not defined
  #---------------------------------------------------------------------------
  #-- Naming
  cislz_namespace_key = "${var.cislz_tag_name_prefix}-namesp"
  default_cislz_namespace_name = "namesp"
  cislz_namespace_name = var.cislz_namespace_name != null ? var.cislz_namespace_name : "${var.cislz_tag_name_prefix}-${local.default_cislz_namespace_name}"

  #-- The namespace itself
  cislz_namespace = var.enable_cislz_namespace && length(data.oci_identity_tag_namespaces.oracle_default.tag_namespaces) == 0 ? {
    (local.cislz_namespace_key) = {
      compartment_id = var.cislz_namespace_compartment_id
      namespace_name = local.cislz_namespace_name
      namespace_description = "CIS Landing Zone default tag namespace."
      is_namespace_retired = false
      defined_tags = var.cislz_defined_tags
      freeform_tags = var.cislz_freeform_tags
    }
  } : {}

  #---------------------------------------------------------------------------------------
  #-- CIS required CreatedBy tag - only if not already defined in Oracle-Tags namespace
  #---------------------------------------------------------------------------------------
  #-- Naming
  cislz_created_by_tag_key = "CreatedBy"
  default_cislz_created_by_tag_name = "CreatedBy"
  cislz_created_by_tag_name = var.cislz_created_by_tag_name != null ? var.cislz_created_by_tag_name : local.default_cislz_created_by_tag_name

  #-- The tag itself
  cislz_created_by_tag = var.enable_cislz_namespace && length(data.oci_identity_tag.default_created_by) == 0 ? {
    (local.cislz_created_by_tag_key) = {
      name = local.cislz_created_by_tag_name,
      description = "CIS Landing Zone tag that identifies the resource creator.",
      tag_namespace_id = oci_identity_tag_namespace.these[local.cislz_namespace_key].id
      is_cost_tracking = true,
      is_retired = false,
      valid_values = []
      defined_tags = var.cislz_defined_tags
      freeform_tags = var.cislz_freeform_tags
    }
  } : {} 

  #-- Tag default
  cislz_created_by_tag_default = var.enable_cislz_namespace && length(data.oci_identity_tag.default_created_by) == 0 ? {
    (local.cislz_created_by_tag_key) = {
      tag_definition_id = oci_identity_tag.these[local.cislz_created_by_tag_key].id
      compartment_id = var.tenancy_ocid,
      default_value = "$${iam.principal.name}",
      is_required = true
    }
  } : {}

  #---------------------------------------------------------------------------------------
  #-- CIS required CreatedOn tag - only if not already defined in Oracle-Tags namespace
  #---------------------------------------------------------------------------------------
  #-- Naming
  cislz_created_on_tag_key = "CreatedOn"
  default_cislz_created_on_tag_name = "CreatedOn"
  cislz_created_on_tag_name = var.cislz_created_on_tag_name != null ? var.cislz_created_on_tag_name : local.default_cislz_created_on_tag_name

  #-- The tag itself
  cislz_created_on_tag = var.enable_cislz_namespace && length(data.oci_identity_tag.default_created_on) == 0 ? {
    (local.cislz_created_on_tag_key) = {
      name = local.cislz_created_on_tag_name,
      description = "CIS Landing Zone tag that identifies when resource is created.",
      tag_namespace_id = oci_identity_tag_namespace.these[local.cislz_namespace_key].id
      is_cost_tracking = false,
      is_retired = false,
      valid_values = []
      defined_tags = var.cislz_defined_tags
      freeform_tags = var.cislz_freeform_tags
    }
  } : {}

  #-- Tag default
  cislz_created_on_tag_default = var.enable_cislz_namespace && length(data.oci_identity_tag.default_created_on) == 0 ? {
    (local.cislz_created_on_tag_key) = {
      tag_definition_id = oci_identity_tag.these[local.cislz_created_on_tag_key].id
      compartment_id = var.tenancy_ocid,
      default_value = "$${oci.datetime}",
      is_required = true
    }
  } : {}

  #---------------------------------------------------------------------------------------
  #-- Building an array with all tags passed in defined_tags variable
  #---------------------------------------------------------------------------------------
  tags = flatten([
    for k1,v1 in (var.defined_tags != null ? var.defined_tags : {}) : [
      for k2, v2 in v1.tags : {
        key  = k2
        name = v2.name
        description = v2.description
        tag_namespace_id = oci_identity_tag_namespace.these[k1].id
        is_cost_tracking = v2.is_cost_tracking
        is_retired = v2.is_retired
        valid_values = v2.valid_values
        defined_tags = v2.defined_tags
        freeform_tags = v2.freeform_tags
      }
    ]
  ])

  #---------------------------------------------------------------------------------------
  #-- Building an array with all tag defaults passed in defined_tags variable
  #---------------------------------------------------------------------------------------
  tag_defaults = flatten([
    for v1 in (var.defined_tags != null ? var.defined_tags : {}) : [
      for k2, v2 in v1.tags : [
        for cmp in v2.apply_default_to_compartments == null ? [] : v2.apply_default_to_compartments : {
          key  = "${k2}.${cmp}"
          tag_definition_id = oci_identity_tag.these[k2].id
          compartment_id = cmp
          default_value = v2.default_value
          is_required = v2.is_default_required
        }
      ]
    ]
  ])                 
}

#-- Tag namespaces creation. 
#-- It loops through a merged map of defined_tags variable and the optional local cislz_namespace (contingent to Oracle-Tags namespace unexistence) 
resource "oci_identity_tag_namespace" "these" {
  for_each = merge(var.defined_tags != null ? var.defined_tags : {}, local.cislz_namespace)
    compartment_id = each.value.compartment_id != null ? each.value.compartment_id : var.tenancy_ocid
    name           = each.value.namespace_name
    description    = each.value.namespace_description
    is_retired     = each.value.is_namespace_retired
    defined_tags   = each.value.defined_tags
    freeform_tags  = each.value.freeform_tags
}

#-- Tags creation.
#-- It loops through a merged map of externally provided tags and the optional locals cislz_created_by_tag and cislz_created_on_tag (contingent to their unexistence in Oracle-Tags namespace)
resource "oci_identity_tag" "these" {
  for_each = merge({for t in local.tags : t.key => {name: t.name, 
                                                    description: t.description,
                                                    tag_namespace_id : t.tag_namespace_id
                                                    is_cost_tracking: t.is_cost_tracking,
                                                    is_retired: t.is_retired,
                                                    valid_values: t.valid_values,
                                                    defined_tags: t.defined_tags,
                                                    freeform_tags: t.freeform_tags}},local.cislz_created_by_tag, local.cislz_created_on_tag)
    name             = each.value.name
    description      = each.value.description
    tag_namespace_id = each.value.tag_namespace_id
    is_cost_tracking = each.value.is_cost_tracking
    is_retired       = each.value.is_retired
    defined_tags     = each.value.defined_tags
    freeform_tags    = each.value.freeform_tags
    dynamic "validator" {
    for_each = each.value.valid_values != null ? (length(each.value.valid_values) > 0 ? [1] : []) : []
      content {
        validator_type = "ENUM"
        values = each.value.valid_values
      }
    }
}

#-- Tag defaults creation.
#-- It loops through a merged map of externally provided tag defaults and the optional locals cislz_created_by_tag and cislz_created_on_tag (contingent to their unexistence in Oracle-Tags namespace)
resource "oci_identity_tag_default" "these" {
  for_each = merge({for td in local.tag_defaults : td.key => {tag_definition_id: td.tag_definition_id,
                                                              compartment_id: td.compartment_id,
                                                              default_value: td.default_value,
                                                              is_required: td.is_required}},local.cislz_created_by_tag_default, local.cislz_created_on_tag_default)
    compartment_id    = each.value.compartment_id
    tag_definition_id = each.value.tag_definition_id                         
    value             = each.value.default_value       
    is_required       = each.value.is_required 
}