# Copyright (c) 2026 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "compartments_configuration" {
  description = "The compartments configuration used by the example."
  type        = any
}

variable "compartments_dependency" {
  description = "Externally managed compartments keyed by logical name."
  type = map(object({
    id = string
  }))
  default = null
}

variable "tags_dependency" {
  description = "Externally managed tags keyed by logical name."
  type = map(object({
    id = string
  }))
  default = null
}
