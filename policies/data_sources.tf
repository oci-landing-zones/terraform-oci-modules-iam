# Copyright (c) 2022 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

data "oci_identity_compartments" "all" {
  compartment_id = var.tenancy_ocid
  compartment_id_in_subtree = true
  access_level = "ANY"
  state = "ACTIVE"
}