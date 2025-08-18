# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {
  type        = string
  description = "The OCID of the tenancy."
}

#-------------------------------------------------------------
#-- Arbitrary compartments topology
#-------------------------------------------------------------
variable "compartments_configuration" {
  description = "The compartments configuration. Use the compartments attribute to define your topology. OCI supports compartment hierarchies up to six levels."
  type = object({
    default_parent_id     = optional(string)      # the default parent for all top (first level) compartments. Use parent_id attribute within each compartment to specify different parents.
    default_defined_tags  = optional(map(string)) # applies to all compartments, unless overriden by defined_tags in a compartment object
    default_freeform_tags = optional(map(string)) # applies to all compartments, unless overriden by freeform_tags in a compartment object
    enable_delete         = optional(bool)        # whether or not compartments are physically deleted when destroyed. Default is false.
    compartments = map(object({
      name          = string
      description   = string
      parent_id     = optional(string)
      defined_tags  = optional(map(string))
      freeform_tags = optional(map(string))
      tag_defaults = optional(map(object({
        tag_id           = string,
        default_value    = string,
        is_user_required = optional(bool)
      })))
      children = optional(map(object({
        name          = string
        description   = string
        defined_tags  = optional(map(string))
        freeform_tags = optional(map(string))
        tag_defaults = optional(map(object({
          tag_id           = string,
          default_value    = string,
          is_user_required = optional(bool)
        })))
        children = optional(map(object({
          name          = string
          description   = string
          defined_tags  = optional(map(string))
          freeform_tags = optional(map(string))
          tag_defaults = optional(map(object({
            tag_id           = string,
            default_value    = string,
            is_user_required = optional(bool)
          })))
          children = optional(map(object({
            name          = string
            description   = string
            defined_tags  = optional(map(string))
            freeform_tags = optional(map(string))
            tag_defaults = optional(map(object({
              tag_id           = string,
              default_value    = string,
              is_user_required = optional(bool)
            })))
            children = optional(map(object({
              name          = string
              description   = string
              defined_tags  = optional(map(string))
              freeform_tags = optional(map(string))
              tag_defaults = optional(map(object({
                tag_id           = string,
                default_value    = string,
                is_user_required = optional(bool)
              })))
              children = optional(map(object({
                name          = string
                description   = string
                defined_tags  = optional(map(string))
                freeform_tags = optional(map(string))
                tag_defaults = optional(map(object({
                  tag_id           = string,
                  default_value    = string,
                  is_user_required = optional(bool)
                })))
              })))
            })))
          })))
        })))
      })))
    }))
  })
  default = null
}

variable "derive_keys_from_hierarchy" {
  description = "Whether identifying keys should be derived from the provided compartments hierarchy"
  type        = bool
  default     = false
}

variable "module_name" {
  description = "The module name."
  type        = string
  default     = "iam-compartments"
}

variable "tags_dependency" {
  description = "A map of objects containing the externally managed tags this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the tag OCID) of string type. See 'External Dependencies' section in README.md for details."
  type = map(object({
    id = string
  }))
  default = null
}

variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain an 'id' attribute of string type set with the compartment OCID. See 'External Dependencies' section in README.md for details."
  type = map(object({
    id = string
  }))
  default = null
}