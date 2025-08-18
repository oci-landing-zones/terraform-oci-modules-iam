# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

variable "tenancy_ocid" {}
variable "region" { description = "Your tenancy home region" }
variable "user_ocid" { default = "" }
variable "fingerprint" { default = "" }
variable "private_key_path" { default = "" }
variable "private_key_password" { default = "" }


#-------------------------------------------------------------
#-- Arbitrary compartments topology
#-------------------------------------------------------------
variable "compartments_configuration" {
  description = "The compartments configuration. Use the compartments attribute to define your topology. OCI supports compartment hierarchies up to six levels."
  type        = any
}

variable "automation_config" {
  type = object({
    bucket_name      = string
    output_file_name = string
  })
  default = null
}