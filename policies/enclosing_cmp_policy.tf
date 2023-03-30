# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  #--------------------------------------------------------------------------------------------
  #-- Enclosing compartments policies
  #--------------------------------------------------------------------------------------------

  #-- Read grants on enclosing compartment.
  read_grants_on_enclosing_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"enclosing") && values["read-group"] != null) ? [
      "allow group ${values["read-group"]} to read all-resources in compartment ${cmp}"
    ] : []
  }

  #-- IAM admin grants on enclosing compartment.
  iam_admin_grants_on_enclosing_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"enclosing") && values["iam-group"] != null) ? [
      "allow group ${values["iam-group"]} to manage policies in compartment ${cmp}", 
      "allow group ${values["iam-group"]} to manage compartments in compartment ${cmp}"
    ] : []
  }  

  #-- Security admin grants on enclosing compartment.
  security_admin_grants_on_enclosing_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"enclosing") && values["sec-group"] != null) ? [
      "allow group ${values["sec-group"]} to manage tag-namespaces in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage tag-defaults in compartment ${cmp}",
      "allow group ${values["sec-group"]} to manage repos in compartment ${cmp}",
      "allow group ${values["sec-group"]} to read audit-events in compartment ${cmp}",
      "allow group ${values["sec-group"]} to read app-catalog-listing in compartment ${cmp}",
      "allow group ${values["sec-group"]} to read instance-images in compartment ${cmp}",
      "allow group ${values["sec-group"]} to inspect buckets in compartment ${cmp}"
    ] : []
  }   

  #-- Application admin grants on enclosing compartment.
  application_admin_grants_on_enclosing_cmp_map = {
    for cmp, values in local.cmp_name_to_cislz_tag_map : cmp => (contains(split(",",values["cmp-type"]),"enclosing") && values["app-group"] != null) ? [
      "allow group ${values["app-group"]} to read app-catalog-listing in compartment ${cmp}",
      "allow group ${values["app-group"]} to read instance-images in compartment ${cmp}",
      "allow group ${values["app-group"]} to read repos in compartment ${cmp}"
    ] : []
  }   
  
  #-- Policies
  enclosing_cmps_policies = {for cmp, values in local.cmp_name_to_cislz_tag_map : 
    (upper("${cmp}-policy")) => {
      name             = "${local.policy_name_prefix}${cmp}${local.policy_name_suffix}"
      compartment_ocid = values.ocid
      description      = "CIS Landing Zone policy for enclosing compartment."
      defined_tags     = var.policies_configuration.defined_tags
      freeform_tags    = var.policies_configuration.freeform_tags
      statements       = concat(local.read_grants_on_enclosing_cmp_map[cmp],local.iam_admin_grants_on_enclosing_cmp_map[cmp],
                                local.security_admin_grants_on_enclosing_cmp_map[cmp],local.application_admin_grants_on_enclosing_cmp_map[cmp])
    }
  }
}