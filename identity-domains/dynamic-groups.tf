# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
data "oci_identity_domain" "dyngrp_domain" {
  for_each = (var.identity_domain_dynamic_groups_configuration != null ) ? (var.identity_domain_dynamic_groups_configuration["dynamic_groups"] != null ? var.identity_domain_dynamic_groups_configuration["dynamic_groups"] : {}) : {}
    domain_id = each.value.identity_domain_id != null ? each.value.identity_domain_id : var.identity_domain_dynamic_groups_configuration.default_identity_domain_id
}

resource "oci_identity_domains_dynamic_resource_group" "these" {
  for_each = var.identity_domain_dynamic_groups_configuration != null ? var.identity_domain_dynamic_groups_configuration.dynamic_groups : {}

    idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_dynamic_groups_configuration.default_identity_domain_id,"None") ) ? oci_identity_domain.these[var.identity_domain_dynamic_groups_configuration.default_identity_domain_id].url : data.oci_identity_domain.dyngrp_domain[each.key].url)
  
    display_name            = each.value.name
    schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:DynamicResourceGroup","urn:ietf:params:scim:schemas:oracle:idcs:extension:OCITags"]
    description  = each.value.description
    matching_rule = each.value.matching_rule
    urnietfparamsscimschemasoracleidcsextension_oci_tags {
      dynamic "defined_tags" {
        for_each = each.value.defined_tags != null ? each.value.defined_tags : (var.identity_domain_dynamic_groups_configuration.default_defined_tags !=null ? var.identity_domain_dynamic_groups_configuration.default_defined_tags : {})
          content {
            key = split(".",defined_tags["key"])[1]
            namespace = split(".",defined_tags["key"])[0]
            value = defined_tags["value"]
          }
        }
      dynamic "freeform_tags" {
        for_each = each.value.freeform_tags != null ? merge(local.cislz_module_tag,each.value.freeform_tags) : (var.identity_domain_dynamic_groups_configuration.default_freeform_tags != null ? merge(local.cislz_module_tag,var.identity_domain_dynamic_groups_configuration.default_freeform_tags) : local.cislz_module_tag)
          content {
            key = freeform_tags["key"]
            value = freeform_tags["value"]
          }
        }
    }
}