# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
data "oci_identity_domain" "apps_domain" {
  for_each = (var.identity_domain_applications_configuration != null ) ? (var.identity_domain_applications_configuration["applications"] != null ? var.identity_domain_applications_configuration["applications"] : {}) : {}
    domain_id = each.value.identity_domain_id != null ? each.value.identity_domain_id : var.identity_domain_applications_configuration.default_identity_domain_id
}

locals {
  grant_types       = ["authorization_code", "client_credentials", "resource_owner", "refresh_token", "implicit", "tls_client_auth", "jwt_assertion", "saml2_assertion", "device_code"]
  application_types = ["SAML", "Mobile", "Confidential", "Enterprise"]
}

resource "oci_identity_domains_app" "these" {
  for_each       = var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {}
    lifecycle {
      ## Check 1: Valid grant types.
      precondition {
        condition = each.value.allowed_grant_types != null ? length(setsubtract(each.value.allowed_grant_types,local.grant_types)) == 0 : true
        error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"allowed_grant_types\" attribute. Valid values are ${join(",",local.grant_types)}."
      }
      ## Check 2: Verify not null for redirec url.
      precondition {
        condition = each.value.redirect_urls == null ? !(contains(local.grant_types, "implicit")||contains(local.grant_types, "authorization_code"))  : true
        error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"redirect_urls\" attribute. A valid value must be provided if \"allowed_grant_types\" is \"implicit\" or \"authorization_code\""
      }
      # Check 3: Verify application type value.
      precondition {
        condition = each.value.type != null ? contains(local.application_types, each.value.type)  : true
        error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"type\" attribute. Valid values are ${join(",",local.application_types)}."
      }


    } 
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
    is_oauth_client = each.value.configure_as_oauth_client
    client_type = "confidential"
    #is_oauth_resource = each.value.type == "Confidential" ? true : false
    allowed_grants = [for grant in each.value.allowed_grant_types : grant=="jwt_assertion" ? "urn:ietf:params:oauth:grant-type:jwt-bearer" :(grant == "saml2_assertion" ? "urn:ietf:params:oauth:grant-type:saml2-bearer":(grant == "resource_owner") ? "password": (grant == "device_code" ? "urn:ietf:params:oauth:grant-type:device_code" : grant))]
    redirect_uris = each.value.redirect_urls






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