# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "identity-domain-identity-providers" {
  description = "The identity domain identity providers."
  value       = module.vision_identity_domains.identity_domain_identity_providers
}

resource "local_file" "identity-domain-metadata" {
  content  = module.vision_identity_domains.identity_domain_saml_metadata[keys(module.vision_identity_domains.identity_domain_saml_metadata)[0]]
  filename = "./identity-domain-metadata.xml"
}

output "test" {
  value = module.vision_identity_domains.test_output
}