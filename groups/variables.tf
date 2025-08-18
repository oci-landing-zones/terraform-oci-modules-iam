# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  type        = string
  description = "The OCID of the tenancy."
}

variable "groups_configuration" {
  description = "The groups configuration."
  type = object({
    enable_debug          = optional(bool, false)
    default_defined_tags  = optional(map(string)),
    default_freeform_tags = optional(map(string))
    groups = map(object({
      name          = string,
      description   = string,
      members       = optional(list(string)),
      defined_tags  = optional(map(string)),
      freeform_tags = optional(map(string))
    }))
  })
  default = null
}

variable "module_name" {
  description = "The module name."
  type        = string
  default     = "iam-groups"
}