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
      display_in_myapps                   = optional(bool),
      user_can_request_access             = optional(bool),
      #autn and authz
      enforce_grants_as_authorization     = optional(bool),
      #Client Configuration
      allowed_grant_types                 = optional(list(string)),  # device_code, refresh_token, jwt_assertion (jwt-bearer), client_credentials, resource_owner (password), authorization_code, implicit, saml2_assertion(saml2-bearer), tls_client_auth
      allow_non_https_urls                = optional(bool),
      redirect_urls                       = optional(map(string)),
      post_logout_redirect_urls           = optional(map(string)),
      logout_url                          = optional(string),
      certificate                         = optional(string),
      allow_instrospect_operation         = optional(bool),
      allow_on_behalf_of_operation        = optional(bool),
      id_token_encryption_algorithm       = optional(string),  #default None
      bypass_consent                      = optional(bool),
      client_ip_address                   = optional(map(string)),
      resources                           = optional(map(string)),
      app_roles                           = optional(map(string)),
      #Resource Server Configuration
      access_token_expiration             = optional(string),
      allow_token_refresh                 = optional(bool),
      refresh_token_expiration            = optional(string),
      primary_audience                    = optional(string),
      secondary_audiences                 = optional(map(string)),
      scopes = map(object({
                  scope                       = optional(string),
                  display_name                = optional(string),
                  description                 = optional(string),
                  requires_user_consent       = optional(bool)
      })),
      #Web Tier Policy
      web_tier_policy_json                = optional(string)


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
