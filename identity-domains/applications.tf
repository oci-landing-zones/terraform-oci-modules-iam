# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
data "oci_identity_domain" "apps_domain" {
  for_each  = (var.identity_domain_applications_configuration != null) ? (var.identity_domain_applications_configuration["applications"] != null ? var.identity_domain_applications_configuration["applications"] : {}) : {}
  domain_id = each.value.identity_domain_id != null ? each.value.identity_domain_id : var.identity_domain_applications_configuration.default_identity_domain_id
}

data "oci_identity_domain" "service_provider_domain" {
  for_each  = local.target_sps
  domain_id = each.value
}

data "http" "sp_signing_cert" {
  for_each = local.target_sps
  # url = join("",[data.oci_identity_domain.service_provider_domain[each.key].url,local.sign_cert_uri])
  url = join("", contains(keys(oci_identity_domain.these), coalesce(each.value, "None")) ? [oci_identity_domain.these[each.value].url] : [data.oci_identity_domain.service_provider_domain[each.key].url], [local.sign_cert_uri])
  depends_on = [
    oci_identity_domains_setting.cert_public_access_setting
  ]
}

data "oci_identity_domains_app_roles" "client_app_roles" {
  for_each = tomap({
    for role in local.app_roles : role.role_name => role
  })
  idcs_endpoint = contains(keys(oci_identity_domain.these), coalesce(each.value.app.identity_domain_id, "None")) ? oci_identity_domain.these[each.value.app.identity_domain_id].url : (contains(keys(oci_identity_domain.these), coalesce(var.identity_domain_applications_configuration.default_identity_domain_id, "None")) ? oci_identity_domain.these[var.identity_domain_applications_configuration.default_identity_domain_id].url : data.oci_identity_domain.apps_domain[each.value.app_key].url)

  app_role_filter = "displayname eq \"${each.value.role_name}\" and app.value eq \"IDCSAppId\""
  #app_role_filter  = join(" or ",[for role in each.value.application_roles : "displayname eq ${role} and app.value eq \"IDCSAppId\""])
}

data "oci_identity_domains_group" "granted_app_group" {
  for_each = tomap({
    for group in local.app_groups : group.app_key => group
  })
  idcs_endpoint = contains(keys(oci_identity_domain.these), coalesce(each.value.app.identity_domain_id, "None")) ? oci_identity_domain.these[each.value.app.identity_domain_id].url : (contains(keys(oci_identity_domain.these), coalesce(var.identity_domain_applications_configuration.default_identity_domain_id, "None")) ? oci_identity_domain.these[var.identity_domain_applications_configuration.default_identity_domain_id].url : data.oci_identity_domain.apps_domain[each.value.app_key].url)
  group_id      = each.value.group_id
}

locals {
  grant_types                         = ["authorization_code", "client_credentials", "resource_owner", "refresh_token", "implicit", "tls_client_auth", "jwt_assertion", "saml2_assertion", "device_code"]
  application_types                   = ["SAML", "Mobile", "Confidential", "SCIM", "GenericSCIM", "FusionApps"]
  allowed_operations                  = ["introspect", "onBehalfOfUser"]
  encryption_algorithms               = ["A128CBC-HS256", "A192CBC-HS384", "A256CBC-HS512", "A128GCM", "A192GCM", "A256GCM"]
  assertion_encryption_algorithms     = ["AES-128", "AES-192", "AES-256", "AES-128-CGM", "AES-256-GCM", "3DES"]
  assertion_key_encryption_algorithms = ["RSA-V1.5", "RSA-OAEP"]
  authorized_resources                = ["All", "Specific"]
  application_roles                   = ["Me", "Cloud Gate", "Kerberos Administrator", "DB Administrator", "MFA Client", "Authenticator Client", "Posix Viewer", "Me Password Validator", "Identity Domain Administrator", "Security Administrator", "User Administrator", "User Manager", "Help Desk Administrator", "Application Administrator", "Audit Administrator", "Change Password", "Reset Password", "Self Registration", "Forgot Password", "Verify Email"]
  app_roles = flatten([
    for app_key, app in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : [
      for role_key, role in app.application_roles != null ? app.application_roles : [] : {
        app_key   = app_key
        app       = app
        role_key  = role_key
        role_name = role
      }
  ]])
  app_groups = flatten([
    for app_key, app in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : [
      for grp_key, group in app.application_group_ids != null ? app.application_group_ids : [] : {
        app_key   = app_key
        app       = app
        group_key = grp_key
        #group_id = (length(regexall("^ocid1.*$", group)) > 0 ?  var.compartments_dependency[group].id) : oci_identity_domains_group.these[group].id
        group_id = group
      }
  ]])
  sign_cert_uri = "/admin/v1/SigningCert/jwk"
  authn_server_op = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k =>
    "{\"op\": \"${v.authentication_server_url == null ? "remove" : "replace"}\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"authenticationServerUrl\\\"].value\",\"value\": [\"${v.authentication_server_url == null ? "nothing" : v.authentication_server_url}\"]}"
    if(v.type == "SCIM" || v.type == "GenericSCIM") && v.enable_provisioning == true
  }
  scope_op = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k =>
    "{\"op\": \"${v.scope == null ? "remove" : "replace"}\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"scope\\\"].value\",\"value\": [\"${v.scope == null ? "nothing" : v.scope}\"]}"
    if(v.type == "SCIM" || v.type == "GenericSCIM") && v.enable_provisioning == true
  }
  custom_auth_headers_op = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k =>
    "{\"op\": \"${v.custom_auth_headers == null ? "remove" : "replace"}\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"customAuthHeaders\\\"].value\",\"value\": [\"${v.custom_auth_headers == null ? "nothing" : v.custom_auth_headers}\"]}"
    if v.type == "GenericSCIM" && v.enable_provisioning == true
  }
  http_operation_types_op = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k =>
    "{\"op\": \"${v.http_operation_types == null ? "remove" : "replace"}\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"httpOperationTypes\\\"].value\",\"value\": [\"${v.http_operation_types == null ? "nothing" : v.http_operation_types}\"]}"
    if v.type == "GenericSCIM" && v.enable_provisioning == true
  }
  base_uri_op = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k =>
    "{\"op\": \"${v.base_uri == null ? "remove" : "replace"}\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"baseURI\\\"].value\",\"value\": [\"${v.base_uri == null ? "nothing" : v.base_uri}\"]}"
    if v.type == "GenericSCIM" && v.enable_provisioning == true
  }
  provisioning_op = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k =>
    "{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"clientid\\\"].value\",\"value\": [\"${v.target_app_id != null ? oci_identity_domains_app.these[v.target_app_id].name : v.client_id}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"clientSecret\\\"].value\",\"value\": [\"${v.target_app_id != null ? oci_identity_domains_app.these[v.target_app_id].client_secret : sensitive(v.client_secret)}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"host\\\"].value\",\"value\": [\"${v.target_app_id != null ? trimsuffix(trimprefix(oci_identity_domains_app.these[v.target_app_id].idcs_endpoint, "https://"), ":443") : v.host_name}\"]}"
    if(v.type == "SCIM" || v.type == "GenericSCIM") && v.enable_provisioning == true
  }
  fa_provisioning_op = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k =>
    "{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"host\\\"].value\",\"value\": [\"${v.host_name != null ? v.host_name : ""}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"port\\\"].value\",\"value\": [\"${v.fa_port != null ? v.fa_port : ""}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"adminUser\\\"].value\",\"value\": [\"${v.fa_admin_user != null ? v.fa_admin_user : ""}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"adminPassword\\\"].value\",\"value\": [\"${v.fa_admin_password != null ? sensitive(v.fa_admin_password) : ""}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"sslEnabled\\\"].value\",\"value\": [\"${coalesce(v.fa_ssl_enabled, true)}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"faAdminRoles\\\"].value\",\"value\": ${v.fa_admin_roles != null ? jsonencode(v.fa_admin_roles) : ""}},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"overrideCustomSyncBehavior\\\"].value\",\"value\": [\"${coalesce(v.fa_override_custom_sync, true)}\"]}"
    if v.type == "FusionApps" && v.enable_provisioning == true
  }
  target_sps = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k => v.identity_domain_sp_id
    if v.identity_domain_sp_id != null
  }
  # saml_attributemapping_op           =  { for k,v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} :  k => 
  #                 "{\"op\": \"replace\",\"path\": \"attributeMappings\",\"value\": [{\"managedObjectAttributeName\":\"ATTR1\",\"samlFormat\":\"Basic\",\"idcsAttributeName\":\"username\"},{\"managedObjectAttributeName\":\"ATTR2\",\"samlFormat\":\"Basic\",\"idcsAttributeName\":\"name.givenName\"},]}]}"
  #                if v.type == "SAML" && v.attribute_configuration != null
  #                }
  saml_attributemapping_op = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k => join("", [for attrs in v.attribute_configuration : "{\"managedObjectAttributeName\": \"${attrs.assertion_attribute}\",\"samlFormat\": \"${attrs.format}\",\"idcsAttributeName\": \"${attrs.identity_domain_attribute}\"},"])

    if contains(local.sso_app_types, v.type) && v.attribute_configuration != null
  }
  saml_attributemapping_op2 = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k => join("", [join("", [for attrs in v.attribute_configuration : "{\"managedObjectAttributeName\": \"${attrs.assertion_attribute}\",\"samlFormat\": \"${attrs.format}\",\"idcsAttributeName\": \"${attrs.identity_domain_attribute}\"},"]), "{\"managedObjectAttributeName\":\"fed.nameidvalue\",\"idcsAttributeName\":\"$(${v.name_id_value == "userName" ? "user.userName" : v.name_id_value == "emails.primary.value" ? "user.emails[primary eq true].value" : v.name_id_value})\"}"])

    if contains(local.sso_app_types, v.type) && v.attribute_configuration != null
  }

  saml_app_links = flatten([
    for app_key, app in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : [
      for link_key, link in app.app_links != null && app.type == "SAML" ? app.app_links : {} : {
        app_key            = app_key
        app_name           = app.display_name
        name               = link_key
        relay_state        = link.relay_state
        app_icon           = link.application_icon
        visible            = link.visible
        identity_domain_id = app.identity_domain_id
      }
  ]])
  default_app_icon = "data:image/png;base64,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"

  sso_app_types          = ["SAML", "FusionApps"]
  provisioning_app_types = ["SCIM", "FusionApps", "GenericSCIM"]


}

resource "oci_identity_domains_oauth_client_certificate" "app_client_cert" {
  for_each = var.identity_domain_applications_configuration != null ? { for k, v in var.identity_domain_applications_configuration.applications : k => v if v.app_client_certificate != null } : {}
  #Required
  certificate_alias     = each.value.app_client_certificate.alias
  idcs_endpoint         = contains(keys(oci_identity_domain.these), coalesce(each.value.identity_domain_id, "None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these), coalesce(var.identity_domain_applications_configuration.default_identity_domain_id, "None")) ? oci_identity_domain.these[var.identity_domain_applications_configuration.default_identity_domain_id].url : data.oci_identity_domain.apps_domain[each.key].url)
  schemas               = ["urn:ietf:params:scim:schemas:oracle:idcs:OAuthClientCertificate"]
  x509base64certificate = each.value.app_client_certificate.base64certificate
}

resource "oci_identity_domains_grant" "app_roles_grant" {
  #for_each       = var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {}
  for_each = tomap({
    for role in local.app_roles : "${role.app_key}.${role.role_key}" => role
  })

  grant_mechanism = "ADMINISTRATOR_TO_APP"
  grantee {
    type  = "App"
    value = oci_identity_domains_app.these[each.value.app_key].id
  }
  idcs_endpoint = contains(keys(oci_identity_domain.these), coalesce(each.value.app.identity_domain_id, "None")) ? oci_identity_domain.these[each.value.app.identity_domain_id].url : (contains(keys(oci_identity_domain.these), coalesce(var.identity_domain_applications_configuration.default_identity_domain_id, "None")) ? oci_identity_domain.these[var.identity_domain_applications_configuration.default_identity_domain_id].url : data.oci_identity_domain.apps_domain[each.value.app_key].url)
  schemas       = ["urn:ietf:params:scim:schemas:oracle:idcs:Grant"]
  app {
    value = "IDCSAppId"
  }
  entitlement {
    attribute_name = "appRoles"
    #attribute_value = data.oci_identity_domains_app_roles.client_app_roles[each.value.app_key].app_roles.0.id
    attribute_value = data.oci_identity_domains_app_roles.client_app_roles[each.value.role_name].app_roles.0.id

  }
}

resource "oci_identity_domains_grant" "app_groups_grant" {
  for_each = tomap({
    for group in local.app_groups : "${group.app_key}.${group.group_key}" => group
  })

  grant_mechanism = "ADMINISTRATOR_TO_GROUP"
  grantee {
    type  = "Group"
    value = length(regexall("^ocid1.*$", each.value.group_id)) > 0 ? data.oci_identity_domains_group.granted_app_group[each.value.app_key].id : oci_identity_domains_group.these[each.value.group_id].id
  }
  idcs_endpoint = contains(keys(oci_identity_domain.these), coalesce(each.value.app.identity_domain_id, "None")) ? oci_identity_domain.these[each.value.app.identity_domain_id].url : (contains(keys(oci_identity_domain.these), coalesce(var.identity_domain_applications_configuration.default_identity_domain_id, "None")) ? oci_identity_domain.these[var.identity_domain_applications_configuration.default_identity_domain_id].url : data.oci_identity_domain.apps_domain[each.value.app_key].url)
  schemas       = ["urn:ietf:params:scim:schemas:oracle:idcs:Grant"]
  app {
    value = oci_identity_domains_app.these[each.value.app_key].id
  }

}

resource "oci_identity_domains_setting" "cert_public_access_setting" {
  for_each = {
    for k, v in var.identity_domains_configuration != null ? var.identity_domains_configuration.identity_domains : {} : k => v
    if v.allow_signing_cert_public_access
  }
  #Required
  csr_access                 = "none"
  idcs_endpoint              = oci_identity_domain.these[each.key].url
  schemas                    = ["urn:ietf:params:scim:schemas:oracle:idcs:Settings"]
  setting_id                 = "Settings"
  signing_cert_public_access = true
}

resource "oci_identity_domains_app" "these" {
  for_each = var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {}
  lifecycle {
    ## Check 1: Valid grant types.
    precondition {
      condition     = each.value.allowed_grant_types != null ? length(setsubtract(each.value.allowed_grant_types, local.grant_types)) == 0 : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"allowed_grant_types\" attribute. Valid values are ${join(",", local.grant_types)}."
    }
    ## Check 2: Verify not null for redirect url.
    precondition {
      condition     = each.value.redirect_urls == null && !contains(["SAML", "SCIM", "FusionApps", "GenericSCIM"], each.value.type) ? (contains(local.grant_types, "implicit") || contains(local.grant_types, "authorization_code")) : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"redirect_urls\" attribute. A valid value must be provided if \"allowed_grant_types\" is \"implicit\" or \"authorization_code\""
    }
    # Check 3: Verify application type value.
    precondition {
      condition     = each.value.type != null ? contains(local.application_types, each.value.type) : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"type\" attribute. Valid values are ${join(",", local.application_types)}."
    }
    # Check 4: Verify certificate alias is provided when using Trusted client type.
    precondition {
      condition     = each.value.client_type != null ? !(each.value.client_type == "trusted" && each.value.app_client_certificate == null) || each.value.client_type != "trusted" : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"app_client_certificate\" attribute. Provide a signing certificate when Client Type is trusted"
    }
    # Check 5: Verify id token encryption algorithm value.
    precondition {
      condition     = each.value.id_token_encryption_algorithm != null ? contains(local.encryption_algorithms, each.value.id_token_encryption_algorithm) : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"id_token_encryption_algorithm\" attribute. Valid values are ${join(",", local.encryption_algorithms)}."
    }
    # Check 8: Verify primary audience is provided for a Resource Server app.
    precondition {
      condition     = coalesce(each.value.configure_as_oauth_resource_server, false) ? each.value.primary_audience != null : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"primary_audience\" attribute. Provide a Primary Audience when configuring OAuth Resource Server."
    }
    # Check 7: Verfiy valid Application Roles.
    precondition {
      condition     = each.value.application_roles != null ? contains([for role in each.value.application_roles : (contains(local.application_roles, role) ? true : false)], false) ? false : true : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"application_roles\" attribute. Valid values are ${join(",", local.application_roles)}."
    }
    # Check 8: Verfiy if admin consent has been granted.
    precondition {
      condition     = each.value.admin_consent_granted == null && contains(local.provisioning_app_types, each.value.type) && each.value.enable_provisioning == true ? false : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": Admin consent has not been granted for provisioning. Grant it by setting \"admin_consent_granted\" after reading ."
    }
    # Check 9: Verify assertion encryption algorithm value.
    precondition {
      condition     = each.value.encryption_algorithm != null ? contains(local.assertion_encryption_algorithms, each.value.encryption_algorithm) : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"encryption_algorithm\" attribute. Valid values are ${join(",", local.assertion_encryption_algorithms)}."
    }
    # Check 10: Verify assertion key encryption algorithm value.
    precondition {
      condition     = each.value.key_encryption_algorithm != null ? contains(local.assertion_key_encryption_algorithms, each.value.key_encryption_algorithm) : true
      error_message = "VALIDATION FAILURE in application \"${each.key}\": invalid value for \"key_encryption_algorithm\" attribute. Valid values are ${join(",", local.assertion_key_encryption_algorithms)}."
    }
    ## Check 11: Valid Signature Hash Algorithm.
    precondition {
      condition     = each.value.signature_hash_algorithm != null ? contains(local.hash_algorithms, each.value.signature_hash_algorithm) : true
      error_message = "VALIDATION FAILURE in identity provider \"${each.key}\": invalid value for \"signature_hash_algorithm\" attribute. Valid values are ${join(",", local.hash_algorithms)}."
    }
  }
  idcs_endpoint = contains(keys(oci_identity_domain.these), coalesce(each.value.identity_domain_id, "None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these), coalesce(var.identity_domain_applications_configuration.default_identity_domain_id, "None")) ? oci_identity_domain.these[var.identity_domain_applications_configuration.default_identity_domain_id].url : data.oci_identity_domain.apps_domain[each.key].url)
  display_name  = each.value.display_name
  description   = each.value.description
  schemas = [
    "urn:ietf:params:scim:schemas:oracle:idcs:App",
    "urn:ietf:params:scim:schemas:oracle:idcs:extension:OCITags",
    "urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App"
  ] #["urn:ietf:params:scim:schemas:oracle:idcs:App","urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App"]  #["urn:ietf:params:scim:schemas:oracle:idcs:App","urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:app:bundleConfigurationProperties"]

  based_on_template {
    value = each.value.type == "Confidential" ? "CustomWebAppTemplateId" : (each.value.type == "SAML" ? "CustomSAMLAppTemplateId" : (each.value.type == "Enterprise" ? "CustomEnterpriseAppTemplateId" : (each.value.type == "Mobile" ? "CustomBrowserMobileTemplateId" : (each.value.type == "SCIM" ? "170c671e7cc13a78a480a2d1f8a5d123" : (each.value.type == "FusionApps" ? "417374eb54633da0929a71a5545ebf4c" : (each.value.type == "GenericSCIM" ? "df61971610a531f48a3187b90c97573c" : null)))))) # "df61971610a531f48a3187b90c97573c" : null))))
  }
  # URLS and General Configuration
  landing_page_url     = each.value.app_url
  login_page_url       = each.value.custom_signin_url
  logout_page_url      = each.value.custom_signout_url
  error_page_url       = each.value.custom_error_url
  linking_callback_url = each.value.custom_social_linking_callback_url

  active = coalesce(each.value.active, false)
  # Display Settings
  show_in_my_apps = each.value.display_in_my_apps
  #   user_can_request_access???????

  # Authentication and Authorization
  allow_access_control = each.value.enforce_grants_as_authorization

  #OAUTH Configuration
  is_oauth_client           = coalesce(each.value.configure_as_oauth_client, false)
  allowed_grants            = [for grant in each.value.allowed_grant_types != null ? each.value.allowed_grant_types : [] : grant == "jwt_assertion" ? "urn:ietf:params:oauth:grant-type:jwt-bearer" : (grant == "saml2_assertion" ? "urn:ietf:params:oauth:grant-type:saml2-bearer" : (grant == "resource_owner") ? "password" : (grant == "device_code" ? "urn:ietf:params:oauth:grant-type:device_code" : grant))]
  all_url_schemes_allowed   = each.value.allow_non_https_urls
  redirect_uris             = each.value.redirect_urls
  post_logout_redirect_uris = each.value.post_logout_redirect_urls
  logout_uri                = each.value.logout_url
  client_type               = each.value.client_type
  allowed_operations        = compact(concat([coalesce(each.value.allow_introspect_operation, false) ? "introspect" : ""], [coalesce(each.value.allow_on_behalf_of_operation, false) ? "onBehalfOfUser" : ""]))
  dynamic "certificates" {
    for_each = each.value.app_client_certificate != null ? [each.value.app_client_certificate["alias"]] : []
    content {
      cert_alias = oci_identity_domains_oauth_client_certificate.app_client_cert[each.key].certificate_alias
    }
  }
  id_token_enc_algo = each.value.id_token_encryption_algorithm == "None" ? "A" : each.value.id_token_encryption_algorithm
  bypass_consent    = coalesce(each.value.bypass_consent, false)
  trust_scope       = each.value.authorized_resources != null ? (each.value.authorized_resources == "All" ? "Account" : "Explicit") : "Explicit"
  dynamic "allowed_scopes" {
    for_each = each.value.resources != null ? each.value.resources : []
    content {
      fqs = allowed_scopes.value
    }
  }
  #Resource Server Configuration
  is_oauth_resource    = coalesce(each.value.configure_as_oauth_resource_server, false)
  access_token_expiry  = coalesce(each.value.access_token_expiration, 3600)
  refresh_token_expiry = coalesce(each.value.allow_token_refresh, false) ? coalesce(each.value.refresh_token_expiration, 604800) : null
  audience             = each.value.primary_audience
  secondary_audiences  = each.value.secondary_audiences
  dynamic "scopes" {
    for_each = each.value.scopes != null ? each.value.scopes : {}
    content {
      value            = scopes.value.scope
      display_name     = scopes.value.display_name
      description      = scopes.value.description
      requires_consent = coalesce(scopes.value.requires_user_consent, false)
    }
  }
  # SAML SSO Configuration
  is_saml_service_provider = each.value.type == "FusionApps" ? false : null
  #App Links
  dynamic "alias_apps" {
    for_each = each.value.app_links != null && each.value.type == "SAML" ? each.value.app_links : {}
    content {
      value = oci_identity_domains_app.saml_app_links["${each.value.display_name}.${alias_apps.key}"].id
    }
  }
  # Fusion Apps Service URLs
  dynamic "service_params" {
    for_each = each.value.type == "FusionApps" && each.value.fusion_service_urls != null ? { "crmlpu" = "${each.value.fusion_service_urls.crm_landing_page_url}", "scmlpu" = "${each.value.fusion_service_urls.scm_landing_page_url}", "hcmlpu" = "${each.value.fusion_service_urls.hcm_landing_page_url}", "erplpu" = "${each.value.fusion_service_urls.erp_landing_page_url}" } : {}
    content {
      name  = service_params.key
      value = service_params.value
    }
  }

  dynamic "urnietfparamsscimschemasoracleidcsextensionsaml_service_provider_app" {
    # for_each = (each.value.type == "SAML" || each.value.type == "FusionApps") ? ["yes"] : []
    for_each = contains(local.sso_app_types, each.value.type) ? ["yes"] : []
    ### App Links - This needs a new apps resource to create the alias apps and then referred to them with alias_apps parameter.  Normally alias apps are created using /admin/v1/Bulk.
    content {
      partner_provider_id               = each.value.identity_domain_sp_id == null ? each.value.entity_id : contains(keys(oci_identity_domain.these), coalesce(each.value.identity_domain_sp_id, "None")) ? "${oci_identity_domain.these[each.value.identity_domain_sp_id].url}/fed" : "${data.oci_identity_domain.service_provider_domain[each.key].url}/fed"
      assertion_consumer_url            = each.value.identity_domain_sp_id == null ? each.value.assertion_consumer_url : contains(keys(oci_identity_domain.these), coalesce(each.value.identity_domain_sp_id, "None")) ? "${oci_identity_domain.these[each.value.identity_domain_sp_id].url}/fed/v1/sp/sso" : "${data.oci_identity_domain.service_provider_domain[each.key].url}/fed/v1/sp/sso"
      signing_certificate               = each.value.identity_domain_sp_id == null ? each.value.signing_certificate : jsondecode(data.http.sp_signing_cert[each.key].response_body).keys[0].x5c[0]
      name_id_format                    = each.value.type == "FusionApps" ? "saml-unspecified" : coalesce(each.value.name_id_format, "saml-emailaddress")
      name_id_userstore_attribute       = each.value.type == "FusionApps" ? "userName" : coalesce(each.value.name_id_value, "emails.primary.value")
      sign_response_or_assertion        = coalesce(each.value.signed_sso, "Assertion")
      logout_enabled                    = each.value.type == "FusionApps" ? true : coalesce(each.value.enable_single_logout, false)
      include_signing_cert_in_signature = coalesce(each.value.include_signing_certificate, false)
      signature_hash_algorithm          = coalesce(each.value.signature_hash_algorithm, "SHA-256")
      logout_binding                    = coalesce(each.value.logout_binding, "Redirect")
      logout_request_url                = each.value.identity_domain_sp_id == null ? each.value.single_logout_url : contains(keys(oci_identity_domain.these), coalesce(each.value.identity_domain_sp_id, "None")) ? "${oci_identity_domain.these[each.value.identity_domain_sp_id].url}/fed/v1/sp/slo" : "${data.oci_identity_domain.service_provider_domain[each.key].url}/fed/v1/sp/slo"
      logout_response_url               = each.value.identity_domain_sp_id == null ? each.value.logout_response_url : contains(keys(oci_identity_domain.these), coalesce(each.value.identity_domain_sp_id, "None")) ? "${oci_identity_domain.these[each.value.identity_domain_sp_id].url}/fed/v1/sp/slo" : "${data.oci_identity_domain.service_provider_domain[each.key].url}/fed/v1/sp/slo"
      ### Encrypted Assertion
      encrypt_assertion        = coalesce(each.value.require_encrypted_assertion, false)
      encryption_certificate   = each.value.encryption_certificate
      encryption_algorithm     = coalesce(each.value.encryption_algorithm, "AES-128")
      key_encryption_algorithm = coalesce(each.value.key_encryption_algorithm, "RSA-v1.5")
      ### Attribute Configuration - Attribute mappings are patched using /admin/v1/MappedAttributes which is missing in OCI SDK, a workaround is to use a provisioner with oci raw-request to patch the resource
    }
  }




  #is_enterprise_app = each.value.type == "Enterprise" ? true : false
  #is_mobile_target = each.value.type == "Mobile" ? true : false


  #is_oauth_resource = each.value.type == "Confidential" ? true : false

  # Provisioning - Catalog Apps
  dynamic "urnietfparamsscimschemasoracleidcsextensionmanagedapp_app" {
    for_each = contains(local.provisioning_app_types, each.value.type) ? ["yes"] : []
    content {
      connected             = each.value.enable_provisioning
      enable_sync           = each.value.enable_synchronization
      is_authoritative      = each.value.authoritative_sync
      admin_consent_granted = each.value.admin_consent_granted
    }
  }

  urnietfparamsscimschemasoracleidcsextension_oci_tags {

    dynamic "defined_tags" {
      for_each = each.value.defined_tags != null ? each.value.defined_tags : (var.identity_domain_applications_configuration.default_defined_tags != null ? var.identity_domain_applications_configuration.default_defined_tags : {})
      content {
        key       = split(".", defined_tags["key"])[1]
        namespace = split(".", defined_tags["key"])[0]
        value     = defined_tags["value"]
      }
    }
    dynamic "freeform_tags" {
      for_each = each.value.freeform_tags != null ? each.value.freeform_tags : (var.identity_domain_applications_configuration.default_freeform_tags != null ? var.identity_domain_applications_configuration.default_freeform_tags : {})
      content {
        key   = freeform_tags["key"]
        value = freeform_tags["value"]
      }
    }

  }
  depends_on = [
    oci_identity_domains_setting.cert_public_access_setting
  ]
}

resource "null_resource" "app_patch" { #Patches SCIM app with provisioning parameters
  for_each = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k => v if v.type == "SCIM" && v.enable_provisioning == true }
  provisioner "local-exec" {
    #command = "oci identity-domains app patch --schemas '[\"urn:ietf:params:scim:api:messages:2.0:PatchOp\"]' --endpoint ${self.idcs_endpoint} --app-id ${self.id} --operations '[{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"authenticationServerUrl\\\"].value\",\"value\": [\"${each.value.authentication_server_url}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"clientid\\\"].value\",\"value\": [\"${each.value.client_id}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"clientSecret\\\"].value\",\"value\": [\"${each.value.client_secret}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"host\\\"].value\",\"value\": [\"${each.value.host_name}\"]}]'"
    #command = "[ ${oci_identity_domains_app.these[each.key].is_managed_app} = false ] && (exit 0) || oci identity-domains app patch --schemas '[\"urn:ietf:params:scim:api:messages:2.0:PatchOp\"]' --endpoint ${oci_identity_domains_app.these[each.key].idcs_endpoint} --app-id ${oci_identity_domains_app.these[each.key].id} --operations '[{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"authenticationServerUrl\\\"].value\",\"value\": [\"${each.value.authentication_server_url}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"clientid\\\"].value\",\"value\": [\"${oci_identity_domains_app.these[each.value.target_app_id].name}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"clientSecret\\\"].value\",\"value\": [\"${oci_identity_domains_app.these[each.value.target_app_id].client_secret}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"host\\\"].value\",\"value\": [\"${oci_identity_domains_app.these[each.value.target_app_id].idcs_endpoint}\"]}]'"
    #command = "[ ${self.is_managed_app} = false ] && (exit 0) || oci identity-domains app patch --schemas '[\"urn:ietf:params:scim:api:messages:2.0:PatchOp\"]' --endpoint ${self.idcs_endpoint} --app-id ${self.id} --operations '[{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"authenticationServerUrl\\\"].value\",\"value\": [\"${coalesce(each.value.authentication_server_url," ")}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"clientid\\\"].value\",\"value\": [\"${oci_identity_domains_app.these[local.target_apps[each.key]].name}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"clientSecret\\\"].value\",\"value\": [\"${coalesce(each.value.client_secret," ")}\"]},{\"op\": \"replace\",\"path\": \"urn:ietf:params:scim:schemas:oracle:idcs:extension:managedapp:App:bundleConfigurationProperties[name eq \\\"host\\\"].value\",\"value\": [\"${coalesce(each.value.host_name," ")}\"]}]'"
    command = "[ ${oci_identity_domains_app.these[each.key].is_managed_app} = false ] && (exit 0) || oci identity-domains app patch --schemas '[\"urn:ietf:params:scim:api:messages:2.0:PatchOp\"]' --endpoint ${oci_identity_domains_app.these[each.key].idcs_endpoint} --app-id ${oci_identity_domains_app.these[each.key].id} --operations '[${tostring(local.authn_server_op[each.key])},${tostring(local.provisioning_op[each.key])},${tostring(local.scope_op[each.key])}]'"

    on_failure = fail
  }
}

resource "null_resource" "fa_provisioning_patch" { #Patches FusionApps app with provisioning parameters
  for_each = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k => v if v.type == "FusionApps" && v.enable_provisioning == true }
  provisioner "local-exec" {
    command = "[ ${oci_identity_domains_app.these[each.key].is_managed_app} = false ] && (exit 0) || oci identity-domains app patch --schemas '[\"urn:ietf:params:scim:api:messages:2.0:PatchOp\"]' --endpoint ${oci_identity_domains_app.these[each.key].idcs_endpoint} --app-id ${oci_identity_domains_app.these[each.key].id} --operations '[${tostring(local.fa_provisioning_op[each.key])}]'"

    on_failure = fail
  }
}

resource "null_resource" "generic_scim_patch" { #Patches GenericSCIM app with provisioning parameters
  for_each = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k => v if v.type == "GenericSCIM" && v.enable_provisioning == true }
  provisioner "local-exec" {
    command = "[ ${oci_identity_domains_app.these[each.key].is_managed_app} = false ] && (exit 0) || oci identity-domains app patch --schemas '[\"urn:ietf:params:scim:api:messages:2.0:PatchOp\"]' --endpoint ${oci_identity_domains_app.these[each.key].idcs_endpoint} --app-id ${oci_identity_domains_app.these[each.key].id} --operations '[${tostring(local.authn_server_op[each.key])},${tostring(local.provisioning_op[each.key])},${tostring(local.scope_op[each.key])},${tostring(local.custom_auth_headers_op[each.key])},${tostring(local.http_operation_types_op[each.key])},${tostring(local.base_uri_op[each.key])}]'"

    on_failure = fail
  }
}

resource "null_resource" "MappedAttributes_patch" { #Patches MappedAttributes for SSO Attribute Configuration
  for_each = { for k, v in var.identity_domain_applications_configuration != null ? var.identity_domain_applications_configuration.applications : {} : k => v if contains(local.sso_app_types, v.type) && v.attribute_configuration != null }
  provisioner "local-exec" {
    command = "[ ${try(each.value.attribute_configuration == null ? false : true, true)} = false ] && (exit 0) || oci raw-request --target-uri  ${oci_identity_domains_app.these[each.key].idcs_endpoint}/admin/v1/MappedAttributes/${oci_identity_domains_app.these[each.key].urnietfparamsscimschemasoracleidcsextensionsaml_service_provider_app[0].outbound_assertion_attributes[0].value} --http-method PATCH --request-body '{\"schemas\":[\"urn:ietf:params:scim:api:messages:2.0:PatchOp\"],\"Operations\":[{\"op\": \"replace\",\"path\": \"attributeMappings\",\"value\":[${local.saml_attributemapping_op2[each.key]}]}]}'"

    on_failure = fail
  }
}


resource "oci_identity_domains_app" "saml_app_links" { #Creates app references for saml apps.  To Destroy manually remove references from App.
  for_each = tomap({
    for app_link in local.saml_app_links : "${app_link.app_name}.${app_link.name}" => app_link
  })
  schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:App", "urn:ietf:params:scim:schemas:oracle:idcs:extension:requestable:App", "urn:ietf:params:scim:schemas:oracle:idcs:extension:samlServiceProvider:App"]
  based_on_template {
    value = "CustomAppTemplateId"
  }
  idcs_endpoint    = contains(keys(oci_identity_domain.these), coalesce(each.value.identity_domain_id, "None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these), coalesce(var.identity_domain_applications_configuration.default_identity_domain_id, "None")) ? oci_identity_domain.these[var.identity_domain_applications_configuration.default_identity_domain_id].url : data.oci_identity_domain.apps_domain[each.value.app_key].url)
  is_alias_app     = true
  display_name     = each.key
  login_mechanism  = "SAML"
  landing_page_url = each.value.relay_state
  show_in_my_apps  = coalesce(each.value.visible, true)
  app_thumbnail    = coalesce(each.value.app_icon, local.default_app_icon)

}





