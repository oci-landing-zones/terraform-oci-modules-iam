# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" {description = "Your tenancy home region"}
variable "user_ocid" {default = ""}
variable "fingerprint" {default = ""}
variable "private_key_path" {default = ""}
variable "private_key_password" {default = ""}


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
}
