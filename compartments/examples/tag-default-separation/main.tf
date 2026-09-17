# Copyright (c) 2026 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "compartments" {
  source = "../.."

  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = var.compartments_configuration
  compartments_dependency    = var.compartments_dependency
  tags_dependency            = var.tags_dependency
  enable_tag_defaults        = false
}

module "tag_defaults" {
  source = "../../../tag-defaults"

  tag_defaults_configuration = module.compartments.tag_defaults_configuration
}
