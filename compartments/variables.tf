# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  type = string
  description = "The OCID of the tenancy."
}

#-------------------------------------------------------------
#-- Arbitrary compartments topology
#-------------------------------------------------------------
variable "compartments_configuration" {
  description = "The compartments configuration. Use the compartments attribute to define your topology. OCI supports compartment hierarchies up to six levels."
  type = object({
    default_parent_ocid = optional(string) # the default parent for all top (first level) compartments. Use parent_ocid attribute within each compartment to specify different parents.
    default_defined_tags = optional(map(string)) # applies to all compartments, unless overriden by defined_tags in a compartment object
    default_freeform_tags = optional(map(string)) # applies to all compartments, unless overriden by freeform_tags in a compartment object
    enable_delete = optional(bool) # whether or not compartments are physically deleted when destroyed. Default is false.
    compartments = map(object({
      name          = string
      description   = string
      parent_ocid   = optional(string)
      defined_tags  = optional(map(string))
      freeform_tags = optional(map(string))
      tag_defaults     = optional(map(object({
        tag_ocid = string,
        default_value = string,
        is_user_required = optional(bool)
      })))
      children      = optional(map(object({
        name          = string
        description   = string
        defined_tags  = optional(map(string))
        freeform_tags = optional(map(string))
        tag_defaults     = optional(map(object({
            tag_ocid = string,
            default_value = string,
            is_user_required = optional(bool)
          })))
        children      = optional(map(object({
          name          = string
          description   = string
          defined_tags  = optional(map(string))
          freeform_tags = optional(map(string))
          tag_defaults     = optional(map(object({
            tag_ocid = string,
            default_value = string,
            is_user_required = optional(bool)
          })))
          children      = optional(map(object({
            name          = string
            description   = string
            defined_tags  = optional(map(string))
            freeform_tags = optional(map(string))
            tag_defaults     = optional(map(object({
              tag_ocid = string,
              default_value = string,
              is_user_required = optional(bool)
            })))
            children      = optional(map(object({
              name          = string
              description   = string
              defined_tags  = optional(map(string))
              freeform_tags = optional(map(string))
              tag_defaults     = optional(map(object({
                tag_ocid = string,
                default_value = string,
                is_user_required = optional(bool)
              })))
              children      = optional(map(object({
                name          = string
                description   = string
                defined_tags  = optional(map(string))
                freeform_tags = optional(map(string))
                tag_defaults     = optional(map(object({
                  tag_ocid = string,
                  default_value = string,
                  is_user_required = optional(bool)
                })))
              })))  
            })))
          })))
        })))
      })))  
    }))
  })
}

variable module_name {
  description = "The module name."
  type = string
  default = "iam-compartments"
}