# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "cislz_policies" {
  source                 = "../.."
  tenancy_ocid           = var.tenancy_ocid
  policies_configuration = var.policies_configuration
}  