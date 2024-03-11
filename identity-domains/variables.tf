# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  type = string
  description = "The OCID of the tenancy."
}

variable "identity_domains_configuration" {
  description = "The identity domains configuration."
  type = object({
    default_compartment_id = optional(string)
    default_defined_tags   = optional(map(string))
    default_freeform_tags  = optional(map(string))
    identity_domains = map(object({
      compartment_id            = optional(string),
      display_name              = string,
      description               = string,
      home_region               = optional(string),
      license_type              = string,
      admin_email               = optional(string),
      admin_first_name          = optional(string),
      admin_last_name           = optional(string),
      admin_user_name           = optional(string),
      is_hidden_on_login        = optional(bool),
      is_notification_bypassed  = optional(bool),
      is_primary_email_required = optional(bool),
      defined_tags              = optional(map(string)),
      freeform_tags             = optional(map(string))
    }))
  })
  default = null
}

variable "identity_domain_groups_configuration" {
  description = "The identity domain groups configuration."
  type = object({
    default_identity_domain_id  = optional(string)
    default_defined_tags        = optional(map(string))
    default_freeform_tags       = optional(map(string))
    groups = map(object({
      identity_domain_id        = optional(string),
      name                      = string,
      description               = optional(string),
      requestable               = optional(bool),
      members                   = optional(list(string)),
      defined_tags              = optional(map(string)),
      freeform_tags             = optional(map(string))
    }))
  })
  default = null
}

variable "identity_domain_dynamic_groups_configuration" {
  description = "The identity domain dynamic groups configuration."
  type = object({
    default_identity_domain_id  = optional(string)
    default_defined_tags        = optional(map(string))
    default_freeform_tags       = optional(map(string))
    dynamic_groups = map(object({
      identity_domain_id        = optional(string),
      name                      = string,
      description               = optional(string),
      matching_rule             = string,
      defined_tags              = optional(map(string)),
      freeform_tags             = optional(map(string))
    }))
  })
  default = null
}

variable "identity_domain_applications_configuration" {
  description = "The identity domain applications configuration."
  type = object({
    default_identity_domain_id  = optional(string)
    default_defined_tags        = optional(map(string))
    default_freeform_tags       = optional(map(string))
    applications = map(object({
      identity_domain_id                  = optional(string),
      name                                = string,
      display_name                        = string,
      description                         = optional(string),
      type                                = string,    # SAML, Mobile (public), Confidential, Enterprise
      active                              = optional(bool),
      #urls
      app_url                             = optional(string),
      custom_signin_url                   = optional(string),
      custom_signout_url                  = optional(string),
      custom_error_url                    = optional(string),
      custom_social_linking_callback_url  = optional(string),
      #display settings
      display_in_my_apps                   = optional(bool),
      user_can_request_access             = optional(bool),
      #autn and authz
      enforce_grants_as_authorization     = optional(bool),
      #Client Configuration
      configure_as_oauth_client           = optional(bool),
      allowed_grant_types                 = optional(list(string)),  # device_code, refresh_token, jwt_assertion (jwt-bearer), client_credentials, resource_owner (password), authorization_code, implicit, saml2_assertion(saml2-bearer), tls_client_auth
      allow_non_https_urls                = optional(bool),
      redirect_urls                       = optional(list(string)),
      post_logout_redirect_urls           = optional(list(string)),
      logout_url                          = optional(string),
      client_type                         = optional(string),          # trusted, confidential
      app_client_certificate              = optional(object({
                    alias                 = string,
                    base64certificate     = string
      })),
      allow_introspect_operation          = optional(bool),
      allow_on_behalf_of_operation        = optional(bool),
      id_token_encryption_algorithm       = optional(string),          # "A128CBC-HS256","A192CBC-HS384","A256CBC-HS512","A128GCM","A192GCM","A256GCM"
      bypass_consent                      = optional(bool),
      client_ip_address                   = optional(list(string)),
      authorized_resources                = optional(string),          # Same as trust_scope:  All(Account), Specific(Explicit)
      resources                           = optional(list(string)),    #resources listed must match scopes defined by an app
      application_roles                   = optional(list(string)),
      #Resource Server Configuration
      configure_as_oauth_resource_server  = optional(bool),
      access_token_expiration             = optional(string),
      allow_token_refresh                 = optional(bool),
      refresh_token_expiration            = optional(string),
      primary_audience                    = optional(string),
      secondary_audiences                 = optional(list(string)),
      scopes = optional(map(object({
                  scope                       = optional(string),
                  display_name                = optional(string),
                  description                 = optional(string),
                  requires_user_consent       = optional(bool)
      }))),
      # SAML SSO
        ### App Links TBA
      entity_id                           = optional(string),
      assertion_consumer_url              = optional(string),
      name_id_format                      = optional(string),
      name_id_value                       = optional(string),
      signing_certificate                 = optional(string),
      signed_sso                          = optional(string),
      include_signing_certificate         = optional(bool),
      signature_hash_algorithm            = optional(string),
      enable_single_logout                = optional(bool),
      logout_binding                      = optional(string),
      single_logout_url                   = optional(string),
      logout_response_url                 = optional(string),
         ### Encrypted Assertion TBA
         ### Atrribute Configuration TBA

      #Web Tier Policy
      web_tier_policy_json                = optional(string)

      # Catalog Apps: Oracle Identity Domain (SCIM)
      enable_provisioning                 = optional(bool)
         #Connectivity
      target_app_id                       = optional(string)
      host_name                           = optional(string)
      client_id                           = optional(string)
      client_secret                       = optional(string)
      scope                               = optional(string)
      authentication_server_url           = optional(string)
      authoritative_sync                  = optional(bool)
      enable_synchronization              = optional(bool)    
      admin_consent_granted               = optional(bool) 
      
      defined_tags              = optional(map(string)),
      freeform_tags             = optional(map(string))
    }))
  })
  default = null
}

variable module_name {
  description = "The module name."
  type = string
  default = "iam-identity-domains"
}

variable compartments_dependency {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type." 
  type = map(any)
  default = null
}
