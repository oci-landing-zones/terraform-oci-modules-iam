# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "private_key_password" {}
variable "home_region" {}

variable "cislz_tag_lookup_value" {
  description = "The cislz tag value used for looking up compartments. This module searches for compartments that are freeform tagged with cislz = <cislz_tag_lookup_value>. The selected compartments are eligible for template (pre-configured) policies. If the lookup fails, no template policies are applied."
  type = string
  default = ""
}

variable "enable_tenancy_level_template_policies" {
  description = "Enables the module to manage template (pre-configured) policies at the tenancy level (root compartment). Variable groups_with_tenancy_level_roles only applies if this is set to true."
  type = string
  default = false
}

variable "groups_with_tenancy_level_roles" {
  description = "A list of group names and their roles at the root compartment (a.k.a tenancy) level. Pre-configured policies are assigned to each group in the root compartment. Only applicable if variable enable_tenancy_level_policies is set to true."
  type = list(object({
    name = string
    roles = string
  }))
  default = []
}