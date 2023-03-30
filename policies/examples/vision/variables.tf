# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" {description = "Your tenancy home region"}
variable "user_ocid" {default = ""}
variable "fingerprint" {default = ""}
variable "private_key_path" {default = ""}
variable "private_key_password" {default = ""}

variable "policies_configuration" {
  description = "Policies configuration"
  type = object({
    enable_cis_benchmark_checks = optional(bool) # Whether to check policies for CIS Foundations Benchmark recommendations. Default is true.
    enable_tenancy_level_template_policies = optional(bool) # Enables the module to manage template (pre-configured) policies at the root compartment) (a.k.a tenancy) level. Attribute groups_with_tenancy_level_roles only applies if this is set to true. Default is false.
    groups_with_tenancy_level_roles = optional(list(object({ # A list of group names and their roles at the root compartment (a.k.a tenancy) level. Pre-configured policies are assigned to each group in the root compartment. Only applicable if attribute enable_tenancy_level_template_policies is set to true.
      name = string
      roles = string
    })))
    enable_compartment_level_template_policies = optional(bool) # Enables the module to manage template (pre-configured) policies at the compartment level (compartments other than root). Default is true.
    cislz_tag_lookup_value = optional(string) # The tag value used for looking up compartments. This module searches for compartments that are freeform tagged with cislz = <cislz_tag_lookup_value>. The selected compartments are eligible for template (pre-configured) policies. If the lookup fails, no template policies are applied.
    policy_name_prefix = optional(string) # A prefix to be prepended to all policy names. Default is ""
    policy_name_suffix = optional(string) # A suffix to be appended to all policy names. Default is "-policy"
    supplied_compartments = optional(list(object({ # List of compartments that are policy targets. This is a workaround to Terraform behavior. Please see note below.
      name = string
      ocid = string
      freeform_tags = map(string)
    })))
    defined_tags = optional(map(string)) # Any defined tags to apply on the template (pre-configured) policies.
    freeform_tags = optional(map(string)) # Any freeform tags to apply on the template (pre-configured) policies.
    supplied_policies = optional(map(object({ # A map of directly supplied policies. Use this to suplement the template (pre-configured) policies. For completely overriding the template policies, set attributes enable_compartment_level_template_policies and enable_tenancy_level_template_policies to false.
      name             = string
      description      = string
      compartment_ocid = string
      statements       = list(string)
      defined_tags     = map(string)
      freeform_tags    = map(string)
    })))
    enable_output = optional(bool) # Whether the module generates output. Default is false.
    enable_debug = optional(bool) # # Whether the module generates debug output. Default is false.
  })
}