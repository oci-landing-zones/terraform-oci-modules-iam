# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" {description = "Your tenancy home region"}
variable "user_ocid" {default = ""}
variable "fingerprint" {default = ""}
variable "private_key_path" {default = ""}
variable "private_key_password" {default = ""}

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
      home_region               = string,
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
      defined_tags              = optional(map(string)),
      freeform_tags             = optional(map(string))
    }))
  })
}

variable "oci_identity_domains_dependency" {
  type = map(object({
    id = string
  }))
  default = null
}

variable "oci_compartments_dependency" {
  type = map(object({
    id = string
  }))
  default = null
}