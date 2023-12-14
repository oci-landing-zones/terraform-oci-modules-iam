# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" {description = "Your tenancy home region"}
variable "user_ocid" {default = ""}
variable "fingerprint" {default = ""}
variable "private_key_path" {default = ""}
variable "private_key_password" {default = ""}


variable "identity_domain_identity_providers_configuration" {
  description = "The identity domain identity providers configuration."
  type = object({
    default_identity_domain_id  = optional(string)
    #default_defined_tags        = optional(map(string))
    #default_freeform_tags       = optional(map(string))
    identity_providers = map(object({
      identity_domain_id        = optional(string),
      name                      = string,
      description               = optional(string),
      enabled                   = bool,
      idp_metadata_file         = string,
      signature_hash_algorithm  = optional(string),
      send_signing_certificate  = optional(bool),
      name_id_format            = optional(string),
      user_mapping_method       = string,
      user_mapping_store_attribute = string  
      assertion_attribute          = optional(string)  #deprecated
      #defined_tags              = optional(map(string)),
      #freeform_tags             = optional(map(string))
    }))
  })
}
