# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" {description = "Your tenancy home region"}
variable "user_ocid" {default = ""}
variable "fingerprint" {default = ""}
variable "private_key_path" {default = ""}
variable "private_key_password" {default = ""}


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
      allowed_grant_types                 = optional(list(string)),
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
      scopes = optional(map(object({
                  scope                       = optional(string),
                  display_name                = optional(string),
                  description                 = optional(string),
                  requires_user_consent       = optional(bool)
      }))),
      #Web Tier Policy
      web_tier_policy_json                = optional(string)


      defined_tags              = optional(map(string)),
      freeform_tags             = optional(map(string))
    }))
  })
}
