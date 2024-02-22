# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
data "oci_identity_domain" "apps_domain" {
  for_each = (var.identity_domain_applications_configuration != null ) ? (var.identity_domain_applications_configuration["applications"] != null ? var.identity_domain_applications_configuration["applications"] : {}) : {}
    domain_id = each.value.identity_domain_id != null ? each.value.identity_domain_id : var.identity_domain_applications_configuration.default_identity_domain_id
}

resource "oci_identity_domains_app" "these" {
  for_each       = var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {}

    idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_applications_configuration.default_identity_domain_id,"None") ) ? oci_identity_domain.these[var.identity_domain_applications_configuration.default_identity_domain_id].url : data.oci_identity_domain.apps_domain[each.key].url)
  
    display_name            = each.value.display_name
    description  = each.value.description
    schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:App"]
    based_on_template {
            value = each.value.type == "Confidential" ? "CustomWebAppTemplateId" : (each.value.type == "SAML" ? "CustomSAMLAppTemplateId" : (each.value.type == "Enterprise" ? "CustomEnterpriseAppTemplateId" : (each.value.type == "Mobile" ? "CustomBrowserMobileTemplateId" : null)))
    }
    landing_page_url = each.value.app_url
    #client_type = each.value.type == "Mobile" ? "public" : "confidential"   #VERIFY
    is_enterprise_app = each.value.type == "Enterprise" ? true : false
    #is_mobile_target = each.value.type == "Mobile" ? true : false
    #is_oauth_client = each.value.type == "SAML" ? false : true
    #is_oauth_resource = each.value.type == "Confidential" ? true : false







    urnietfparamsscimschemasoracleidcsextension_oci_tags {

        dynamic "defined_tags" {
            for_each = each.value.defined_tags != null ? each.value.defined_tags : (var.identity_domain_applications_configuration.default_defined_tags !=null ? var.identity_domain_applications_configuration.default_defined_tags : {})
               content {
                 key = split(".",defined_tags["key"])[1]
                 namespace = split(".",defined_tags["key"])[0]
                 value = defined_tags["value"]
               }
        }

        dynamic "freeform_tags" {
            for_each = each.value.freeform_tags != null ? each.value.freeform_tags : (var.identity_domain_applications_configuration.default_freeform_tags !=null ? var.identity_domain_applications_configuration.default_freeform_tags : {})
               content {
                 key = freeform_tags["key"]
                 value = freeform_tags["value"]
               }
        }

    }
}