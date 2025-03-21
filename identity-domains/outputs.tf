# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "identity_domains" {
  description = "The identity domains."
  value = oci_identity_domain.these
}

output "identity_domain_groups" {
  description = "The identity domain groups"
  value = oci_identity_domains_group.these
}

output "identity_domain_dynamic_groups" {
  description = "The identity domain groups"
  value = oci_identity_domains_dynamic_resource_group.these
}

output "identity_domain_applications" {
  description = "The identity domain applications"
  value = oci_identity_domains_app.these
}



output "identity_domain_identity_providers" {
  description = "The identity domain groups"
  value = oci_identity_domains_identity_provider.these
}

output "identity_domain_saml_metadata" {
  value = { for k,v in data.http.saml_metadata : k=> v.response_body }
}

output "debug_ignored_users" {
  description = "(Debug) Ignored users."
  value = try(var.identity_domain_groups_configuration.enable_debug,false) ? { for k,v in local.identity_domains : "${k} with url ${v}" => [for u in local.all_users[k] : u if length([for u1 in local.all_users[k] : u1.user_name if u1.user_name == u.user_name]) > 1] } : null
}

output "all_users" {
  value = try(var.identity_domain_groups_configuration.enable_debug,false) ? { for k,v in local.identity_domains : "${k} with url ${v}" => [for u in local.all_users[k] : u]} : null
}
