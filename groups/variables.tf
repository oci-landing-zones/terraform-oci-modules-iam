# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  description = "The OCID of the tenancy."
}

variable "groups" {
  description = "The groups."
  type = map(object({
    name          = string,
    description   = string,
    members       = optional(list(string)),
    defined_tags  = optional(map(string)),
    freeform_tags = optional(map(string))
  }))
}