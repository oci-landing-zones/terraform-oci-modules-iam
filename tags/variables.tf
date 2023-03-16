# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  description = "The tenancy ocid, used to search on tag namespaces."
  type = string
} 

variable "enable_cislz_namespace" {
  description = "Whether the default namespace required by CIS OCI Benchmark is enabled."
  type = bool
  default = true
}

variable "cislz_tag_name_prefix" {
  description = "A string used as a prefix for resource naming."
  type = string
  default = "cislz"
}
variable "cislz_namespace_compartment_id" {
  description = "The compartment ocid where to create a default tag namespace. Only applicable if *enable_cislz_namespace* is true and tenancy is not pre-configured with OCI tag namespace defined by *oracle_default_namespace_name*."
  type = string
}

variable "oracle_default_namespace_name" {
  description = "OCI's pre-configured tag namespace."
  type = string
  default = "Oracle-Tags"
}

variable "oracle_default_created_by_tag_name" {
  description = "OCI's pre-configured tag name for identifying resource creators."
  type = string
  default = "CreatedBy"
}

variable "oracle_default_created_on_tag_name" {
  description = "OCI's pre-configured tag name for identifying when resources are created."
  type = string
  default = "CreatedOn"
}

variable "cislz_namespace_name" {
  description = "A user provided name for the default namespace. Only applicable if Only applicable if *enable_cislz_namespace* is true and tenancy is not pre-configured with OCI tag namespace defined by *oracle_default_namespace_name*."
  type = string
  default = null
}

variable "cislz_created_by_tag_name" {
  description = "A user provided name for the tag to identify resource creators. Only applicable if Only applicable if *enable_cislz_namespace* is true and tenancy is not pre-configured with OCI tag defined by *oracle_default_created_by_tag_name*."
  type = string
  default = null
}

variable "cislz_created_on_tag_name" {
  description = "A user provided name for the tag to identify when resources are created. Only applicable if Only applicable if *enable_cislz_namespace* is true and tenancy is not pre-configured with OCI tag defined by *oracle_default_created_on_tag_name*."
  type = string
  default = null
}

variable "cislz_defined_tags" {
  description = "Any defined tags to apply on the default namespace and tags (those prefixed with cislz_)." 
  type = map(string)
  default = null
}

variable "cislz_freeform_tags" {
  description = "Any freeform tags to apply on the default namespace and tags (those prefixed with cislz_)."
  type = map(string)
  default = null
}

variable "defined_tags" {
  description = "A map of user defined tags, made of tag namespaces, and tags themselves along with optional tag defaults."
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
      defined_tags  = map(string),
      freeform_tags = map(string)
    }))
  }))
  default = {}
}