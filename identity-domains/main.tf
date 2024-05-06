# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_regions" "these" {}

data "oci_identity_tenancy" "this" {
  tenancy_id = var.tenancy_ocid
}

locals {
  regions_map     = { for r in data.oci_identity_regions.these.regions : r.key => r.name } 
  home_region_key = data.oci_identity_tenancy.this.home_region_key                         
}



resource "oci_identity_domain" "these" {
  for_each       = var.identity_domains_configuration != null ? var.identity_domains_configuration.identity_domains : {}
    #compartment_id      = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.identity_domains_configuration.default_compartment_id)) > 0 ? var.identity_domains_configuration.default_compartment_id : var.compartments_dependency[var.identity_domains_configuration.default_compartment_id].id)
    compartment_id      = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (var.identity_domains_configuration.default_compartment_id != null ? (length(regexall("^ocid1.*$", var.identity_domains_configuration.default_compartment_id)) > 0 ? var.identity_domains_configuration.default_compartment_id : var.compartments_dependency[var.identity_domains_configuration.default_compartment_id].id) : var.tenancy_ocid)


    display_name    = each.value.display_name
    description     = each.value.description
    #home_region     = each.value.home_region
    home_region     = each.value.home_region != null ? each.value.home_region : local.regions_map[local.home_region_key]
    license_type    = each.value.license_type

    admin_email         = each.value.admin_email
    admin_first_name    = each.value.admin_first_name
    admin_last_name     = each.value.admin_last_name
    admin_user_name     = each.value.admin_user_name

    is_hidden_on_login          = each.value.is_hidden_on_login
    is_notification_bypassed    = each.value.is_notification_bypassed
    is_primary_email_required   = each.value.is_primary_email_required

    defined_tags   = each.value.defined_tags != null ? each.value.defined_tags : var.identity_domains_configuration.default_defined_tags != null ? var.identity_domains_configuration.default_defined_tags : null
    freeform_tags  = merge(local.cislz_module_tag, each.value.freeform_tags != null ? each.value.freeform_tags : var.identity_domains_configuration.default_freeform_tags != null ? var.identity_domains_configuration.default_freeform_tags : null)
}

resource "oci_identity_domain_replication_to_region" "these" {
  for_each = { for k, v in var.identity_domains_configuration != null ? var.identity_domains_configuration.identity_domains : {} : k => v
    if coalesce(v.enable_domain_replication, false)
  }
  domain_id      = oci_identity_domain.these[each.key].id
  replica_region = each.value.replica_region

  lifecycle {
    precondition {
      condition     = each.value.enable_domain_replication && each.value.replica_region != null && each.value.replica_region != ""
      error_message = "replica_region must not be null when domain replication is enabled. The region must be a subscribed region and cannot be the same as the home region."
    }
    precondition {
      condition     = each.value.replica_region != each.value.home_region
      error_message = "replica_region must not be the same as the home region when domain replication is enabled."
    }
  }
}