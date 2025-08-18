# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  description = "The OCID of the tenancy."
}

variable "dynamic_groups_configuration" {
  description = "The dynamic groups."
  type = object({
    default_defined_tags  = optional(map(string)),
    default_freeform_tags = optional(map(string))
    dynamic_groups = map(object({
      name          = string,
      description   = string,
      matching_rule = string
      defined_tags  = optional(map(string)),
      freeform_tags = optional(map(string))
    }))
  })
  default = null
}

variable "module_name" {
  description = "The module name."
  type        = string
  default     = "iam-dynamic-groups"
}