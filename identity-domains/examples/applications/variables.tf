# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" { description = "Your tenancy home region" }
variable "user_ocid" { default = "" }
variable "fingerprint" { default = "" }
variable "private_key_path" { default = "" }
variable "private_key_password" { default = "" }




variable "identity_domain_applications_configuration" {
  description = "The identity domain applications configuration."
  type = object({
    default_identity_domain_id = optional(string)
    default_defined_tags       = optional(map(string))
    default_freeform_tags      = optional(map(string))
    applications = map(object({
      identity_domain_id    = optional(string),
      name                  = string,
      display_name          = string,
      description           = optional(string),
      type                  = string, # SAML, Mobile (public), Confidential, SCIM, FusionApps
      active                = optional(bool),
      application_group_ids = optional(list(string)),
      #urls
      app_url                            = optional(string),
      custom_signin_url                  = optional(string),
      custom_signout_url                 = optional(string),
      custom_error_url                   = optional(string),
      custom_social_linking_callback_url = optional(string),
      #display settings
      display_in_my_apps      = optional(bool),
      user_can_request_access = optional(bool),
      #autn and authz
      enforce_grants_as_authorization = optional(bool),
      #Client Configuration
      configure_as_oauth_client = optional(bool),
      allowed_grant_types       = optional(list(string)), # device_code, refresh_token, jwt_assertion (jwt-bearer), client_credentials, resource_owner (password), authorization_code, implicit, saml2_assertion(saml2-bearer), tls_client_auth
      allow_non_https_urls      = optional(bool),
      redirect_urls             = optional(list(string)),
      post_logout_redirect_urls = optional(list(string)),
      logout_url                = optional(string),
      client_type               = optional(string), # trusted, confidential
      app_client_certificate = optional(object({
        alias             = string,
        base64certificate = string
      })),
      allow_introspect_operation    = optional(bool),
      allow_on_behalf_of_operation  = optional(bool),
      id_token_encryption_algorithm = optional(string), # "A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"
      bypass_consent                = optional(bool),
      client_ip_address             = optional(list(string)), #TBA
      authorized_resources          = optional(string),       # Same as trust_scope:  All(Account), Specific(Explicit)
      resources                     = optional(list(string)), #resources listed must match scopes defined by an app
      application_roles             = optional(list(string)),
      #Resource Server Configuration
      configure_as_oauth_resource_server = optional(bool),
      access_token_expiration            = optional(string),
      allow_token_refresh                = optional(bool),
      refresh_token_expiration           = optional(string),
      primary_audience                   = optional(string),
      secondary_audiences                = optional(list(string)),
      scopes = optional(map(object({
        scope                 = optional(string),
        display_name          = optional(string),
        description           = optional(string),
        requires_user_consent = optional(bool)
      }))),
      # SAML SSO
      ### App Links TBA
      identity_domain_sp_id       = optional(string),
      entity_id                   = optional(string),
      assertion_consumer_url      = optional(string),
      name_id_format              = optional(string),
      name_id_value               = optional(string),
      signing_certificate         = optional(string),
      signed_sso                  = optional(string),
      include_signing_certificate = optional(bool),
      signature_hash_algorithm    = optional(string),
      enable_single_logout        = optional(bool),
      logout_binding              = optional(string),
      single_logout_url           = optional(string),
      logout_response_url         = optional(string),
      require_encrypted_assertion = optional(bool),
      encryption_certificate      = optional(string),
      encryption_algorithm        = optional(string), #AES-128,AES-192,AES-256,AES-128-CGM,AES-256-CGM,3DES
      key_encryption_algorithm    = optional(string), #RSA-V1.5, RSA-OAEP
      attribute_configuration = optional(map(object({
        assertion_attribute       = string,
        identity_domain_attribute = string,
        format                    = optional(string)
      }))),
      app_links = optional(map(object({
        relay_state      = string,
        application_icon = optional(string),
        visible          = optional(bool)
      }))),
      fusion_service_urls = optional(object({
        crm_landing_page_url = optional(string),
        scm_landing_page_url = optional(string),
        hcm_landing_page_url = optional(string),
        erp_landing_page_url = optional(string)
      }))


      #Web Tier Policy
      web_tier_policy_json = optional(string) #TBA

      # Catalog Apps Provisioning
      enable_provisioning = optional(bool)
      #Connectivity
      target_app_id             = optional(string)
      host_name                 = optional(string) #also use as fa host name
      client_id                 = optional(string)
      client_secret             = optional(string)
      scope                     = optional(string)
      authentication_server_url = optional(string)
      authoritative_sync        = optional(bool)
      enable_synchronization    = optional(bool)
      admin_consent_granted     = optional(bool)
      # Catalog Apps: Specific for Generic SCIM
      base_uri             = optional(string)
      custom_auth_headers  = optional(string)
      http_operation_types = optional(string)
      # Catalog Apps: Specific for Oracle Fusion Applications 13 (FusionApps)
      fa_port                 = optional(string)
      fa_admin_user           = optional(string)
      fa_admin_password       = optional(string)
      fa_ssl_enabled          = optional(bool)
      fa_override_custom_sync = optional(bool)
      fa_admin_roles          = optional(list(string))


      defined_tags  = optional(map(string)),
      freeform_tags = optional(map(string))
    }))
  })
}


