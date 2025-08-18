# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "identity_domains" {
  description = "The identity domains."
  value       = oci_identity_domain.these
}

output "identity_domain_groups" {
  description = "The identity domain groups"
  value       = oci_identity_domains_group.these
}

output "identity_domain_dynamic_groups" {
  description = "The identity domain groups"
  value       = oci_identity_domains_dynamic_resource_group.these
}

output "identity_domain_applications" {
  description = "The identity domain applications"
  value       = oci_identity_domains_app.these
}

output "identity_domain_identity_providers" {
  description = "The identity domain groups"
  value       = oci_identity_domains_identity_provider.these
}

output "identity_domain_saml_metadata" {
  value = { for k, v in data.http.saml_metadata : k => v.response_body }
}