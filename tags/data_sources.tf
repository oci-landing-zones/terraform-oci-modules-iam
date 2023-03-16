# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#---------------------------------------------------------------------------
#-- Data sources to handle Oracle-Tags namespace existence
#---------------------------------------------------------------------------
#-- Looking for the CreatedBy tag in Oracle default tag namespace
data "oci_identity_tag" "default_created_by" {
  count = length(data.oci_identity_tag_namespaces.oracle_default.tag_namespaces) > 0 ? 1 : 0
  tag_name = var.oracle_default_created_by_tag_name
  tag_namespace_id = data.oci_identity_tag_namespaces.oracle_default.tag_namespaces[0].id
}

#-- Looking for the CreatedOn tag in Oracle default tag namespace
data "oci_identity_tag" "default_created_on" {
  count = length(data.oci_identity_tag_namespaces.oracle_default.tag_namespaces) > 0 ? 1 : 0
  tag_name = var.oracle_default_created_on_tag_name
  tag_namespace_id = data.oci_identity_tag_namespaces.oracle_default.tag_namespaces[0].id
}

#-- Looking for the Oracle default tag namespace
data "oci_identity_tag_namespaces" "oracle_default" {
  compartment_id = var.tenancy_ocid
  filter {
    name  = "name"
    values = [var.oracle_default_namespace_name]
  }    
}