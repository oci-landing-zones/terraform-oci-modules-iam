# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "policies" {
  value = module.cislz_policies.policies
}

output "template_target_compartments" {
  value = module.cislz_policies.template_target_compartments
}