# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.



resource "oci_identity_domain" "these" {
  for_each       = var.identity_domains_configuration != null ? var.identity_domains_configuration.identity_domains : {}
    compartment_id      = each.value.compartment_id != null ? (length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id) : (length(regexall("^ocid1.*$", var.identity_domains_configuration.default_compartment_id)) > 0 ? var.identity_domains_configuration.default_compartment_id : var.compartments_dependency[var.identity_domains_configuration.default_compartment_id].id)

    display_name    = each.value.display_name
    description     = each.value.description
    home_region     = each.value.home_region
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