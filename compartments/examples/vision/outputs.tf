# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "compartments" {
  value = module.vision_compartments.compartments
}

output "tag_defaults" {
  value = module.vision_compartments.tag_defaults
}