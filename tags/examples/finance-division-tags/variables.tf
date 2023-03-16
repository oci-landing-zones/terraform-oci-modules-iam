# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "home_region" {}

variable "defined_tags" {
  type = map(object({
    compartment_id        = string,
    namespace_name        = string,
    namespace_description = string,
    is_namespace_retired  = bool,
    defined_tags          = map(string),
    freeform_tags         = map(string)
    tags = map(object({
      name = string,
      description = string,
      is_cost_tracking = bool,
      is_retired = bool,
      valid_values = list(string),
      apply_default_to_compartments = list(string),
      default_value = string,
      is_default_required = bool,
      defined_tags          = map(string),
      freeform_tags         = map(string)
    }))
  }))
}