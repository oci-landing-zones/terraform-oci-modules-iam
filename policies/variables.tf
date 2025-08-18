# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  description = "The tenancy OCID."
  type        = string
}

variable "policies_configuration" {
  description = "Policies configuration"
  type = object({
    enable_cis_benchmark_checks = optional(bool) # Whether to check policies for CIS Foundations Benchmark recommendations. Default is true.
    supplied_policies = optional(map(object({    # A map of directly supplied policies. Use this to suplement or override the template policies.
      name           = string
      description    = string
      compartment_id = string
      statements     = list(string)
      defined_tags   = optional(map(string))
      freeform_tags  = optional(map(string))
    })))
    template_policies = optional(object({                        # An object describing the template policies. In this mode, policies are derived according to tenancy_level_settings and compartment_level_settings.
      tenancy_level_settings = optional(object({                 # Settings for tenancy level (Root compartment) policies generation.
        groups_with_tenancy_level_roles = optional(list(object({ # A list of group names and their roles at the tenancy level. Template policies are granted to each group in the Root compartment.
          name  = string
          roles = string
        })))
        oci_services = optional(object({
          enable_all_policies            = optional(bool)
          enable_scanning_policies       = optional(bool)
          enable_cloud_guard_policies    = optional(bool)
          enable_os_management_policies  = optional(bool)
          enable_block_storage_policies  = optional(bool)
          enable_file_storage_policies   = optional(bool)
          enable_oke_policies            = optional(bool)
          enable_streaming_policies      = optional(bool)
          enable_object_storage_policies = optional(bool)
        }))
        policy_name_prefix = optional(string) # A prefix to Root compartment policy names.
      }))
      compartment_level_settings = optional(object({  # Settings for compartment (non Root) level policies generation.
        supplied_compartments = optional(map(object({ # List of compartments that are policy targets.
          name           = string                     # The compartment name
          id             = string                     # The compartment id
          cislz_metadata = map(string)                # The compartment metadata. See module README.md for details.
        })))
        #policy_name_prefix = optional(string) # A prefix to compartment policy names.
      }))
    }))
    policy_name_prefix = optional(string)      # A prefix to all policy names.
    policy_name_suffix = optional(string)      # A suffix to all policy names.
    defined_tags       = optional(map(string)) # Any defined tags to apply on the template (pre-configured) policies.
    freeform_tags      = optional(map(string)) # Any freeform tags to apply on the template (pre-configured) policies.
  })
  default = null
}

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-- Note about supplied_compartments attribute:
#-- The original ideia was having the module looking up compartments obtained from a data source internal to the module. But that introduces an issue to the processing logic, as
#-- Terraform requires compartments to be known at plan time, because compartment names are used as map keys by the module. 
#-- The error is:
#--
#-- Error: Invalid for_each argument
#--│
#--│   on .terraform\modules\cislz_policies\main.tf line 23, in resource "oci_identity_policy" "these":
#--│   23:   for_each = {for k, v in local.policies : k => v if length(v.statements) > 0}
#--│     ├────────────────
#--││     │ local.policies will be known only after apply
#--││
#--││ The "for_each" map includes keys derived from resource attributes that cannot be determined until apply, 
#--|| and so Terraform cannot determine the full set of keys that will identify the instances of this resource.
#--││
#--││ When working with unknown values in for_each, it's better to define the map keys statically in your configuration and place apply-time results only in the map values.
#--││
#--││ Alternatively, you could use the -target planning option to first apply only the resources that the for_each value depends on, and then apply a second time to fully converge.
#--

variable "enable_output" {
  description = "Whether Terraform should enable module output."
  type        = bool
  default     = true
}

variable "enable_debug" {
  description = "Whether Terraform should enable module debug information."
  type        = bool
  default     = false
}

variable "module_name" {
  description = "The module name."
  type        = string
  default     = "iam-policies"
}

variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type."
  type = map(object({
    id = string
  }))
  default = null
}