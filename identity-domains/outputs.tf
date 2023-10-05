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

output "domain-users" {
  description = "the domain users"
  value = local.users
}