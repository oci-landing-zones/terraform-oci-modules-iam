# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.





output "identity-domain-identity-providers" {
  description = "The identity domain groups."
  value       = module.vision_identity_domains.identity_domain_identity_providers
}

