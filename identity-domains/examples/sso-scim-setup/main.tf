# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "vision_identity_domains" {
  source                               = "../../"
  tenancy_ocid                         = var.tenancy_ocid
  identity_domains_configuration       = var.identity_domains_configuration
  identity_domain_groups_configuration = var.identity_domain_groups_configuration
  #identity_domain_dynamic_groups_configuration    = var.identity_domain_dynamic_groups_configuration
  identity_domain_identity_providers_configuration = var.identity_domain_identity_providers_configuration
  identity_domain_applications_configuration       = var.identity_domain_applications_configuration

}