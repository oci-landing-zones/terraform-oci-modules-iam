# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#-------------------------------------------------------------
#-- Arbitrary compartments topology
#-------------------------------------------------------------
variable "compartments" {
  description = "The compartments topology, given as a map of objects nested up to six levels."
  type = map(object({
    name          = string
    description   = string
    parent_ocid   = string
    defined_tags  = optional(map(string))
    freeform_tags = optional(map(string))
    children      = optional(map(object({
      name          = string
      description   = string
      defined_tags  = optional(map(string))
      freeform_tags = optional(map(string))
      children      = optional(map(object({
        name          = string
        description   = string
        defined_tags  = optional(map(string))
        freeform_tags = optional(map(string))
        children      = optional(map(object({
          name          = string
          description   = string
          defined_tags  = optional(map(string))
          freeform_tags = optional(map(string))
          children      = optional(map(object({
            name          = string
            description   = string
            defined_tags  = optional(map(string))
            freeform_tags = optional(map(string))
            children      = optional(map(object({
              name          = string
              description   = string
              defined_tags  = optional(map(string))
              freeform_tags = optional(map(string))
            })))  
          })))
        })))
      })))
    })))  
  }))
  default = {}
}

variable "enable_compartments_delete" {
  description = "Whether compartments are physically deleted upon destroy."
  type = bool
  default = true
}