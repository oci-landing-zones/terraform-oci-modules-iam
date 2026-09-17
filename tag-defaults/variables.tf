# Copyright (c) 2026 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tag_defaults_configuration" {
  description = "Tag defaults keyed by stable logical identifiers."
  type = map(object({
    compartment_id    = string
    tag_definition_id = string
    default_value     = string
    is_user_required  = bool
  }))
  default = {}
}
