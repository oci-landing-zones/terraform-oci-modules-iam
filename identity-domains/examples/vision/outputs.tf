# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "identity-domains" {
  description = "The identity domains."
  value       = module.vision_identity_domains.identity_domains
}

output "identity-domain-groups" {
  description = "The identity domain groups."
  value       = module.vision_identity_domains.identity_domain_groups
}

