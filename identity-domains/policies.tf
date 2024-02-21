# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.  

data "oci_identity_domain" "policy_domain" {
  for_each = (var.identity_domain_policies_configuration != null ) ? (var.identity_domain_policies_configuration["policies"] != null ? var.identity_domain_policies_configuration["policies"] : {}) : {}
    domain_id = each.value.identity_domain_id != null ? each.value.identity_domain_id : var.identity_domain_policies_configuration.default_identity_domain_id
}
  
locals {
  rules = flatten([
    for k1, v1 in (var.identity_domain_policies_configuration != null ? var.identity_domain_policies_configuration.policies : null) : [
      for k2, v2 in v1.policy_rules : {
        key                           = k2
        name                          = v2.name
        description                   = v2.description
        assign_idps                   = v2.assign_idps
        user_name_expression          = v2.user_name_expression
        starts_with_expression        = v2.starts_with_expression
        exclude_users                 = v2.exclude_users
        group_membership              = v2.group_membership
        filter_by_network_perimeter   = v2.filter_by_network_perimeter
        idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(v1.identity_domain_id,"None")) ? oci_identity_domain.these[v1.identity_domain_id].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_policies_configuration.default_identity_domain_id,"None") ) ? oci_identity_domain.these[var.identity_domain_policies_configuration.default_identity_domain_id].url : data.oci_identity_domain.policy_domain[k1].url)
        sequence = index(keys(v1.policy_rules),k2)+1
        #value = oci_domains_rule.these[k2].id

      } 
    ] if v1.policy_rules != null
  ])
}

resource "oci_identity_domains_policy" "these" {
    for_each  = var.identity_domain_policies_configuration != null ? var.identity_domain_policies_configuration.policies : {} 
        name = each.value.name
        idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_policies_configuration.default_identity_domain_id,"None") ) ? oci_identity_domain.these[var.identity_domain_policies_configuration.default_identity_domain_id].url : data.oci_identity_domain.policy_domain[each.key].url)

        policy_type {
            value = "IdentityProvider"
        } 
        schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:Policy"]

        dynamic "rules" {
          for_each = each.value.policy_rules
          content {
              value = oci_identity_domains_rule.these[rules.key].id
              sequence = index(keys(each.value.policy_rules),rules.key)+1
              #sequence = 1
          }
        }

}

resource "oci_identity_domains_rule" "default_idp_rule" {
  for_each = var.identity_domain_identity_providers_configuration.identity_providers != null ? var.identity_domain_identity_providers_configuration.identity_providers  : {}

    condition = ""
    idcs_endpoint = contains(keys(oci_identity_domain.these),coalesce(each.value.identity_domain_id,"None")) ? oci_identity_domain.these[each.value.identity_domain_id].url : (contains(keys(oci_identity_domain.these),coalesce(var.identity_domain_identity_providers_configuration.default_identity_domain_id,"None") ) ? oci_identity_domain.these[var.identity_domain_identity_providers_configuration.default_identity_domain_id].url : data.oci_identity_domain.idp_domain[each.key].url)
    name = "Default IDP Rule"
    policy_type {
        value = "IdentityProvider"
    }
    return {
        name = "LocalIDPs"
        value = "WithPassword"
        return_groovy = null
    }
    return {
        name = "SamlIDPs"
        value = oci_identity_domains_identity_provider.these[each.key].id
        return_groovy = null
    }
    schemas = ["urn:ietf:params:scim:api:messages:2.0:PatchOp"]
    
    
}

resource "oci_identity_domains_rule" "these" {
  for_each = {for c in local.rules : c.key => {  name: c.name, 
                                                 description: c.description,
                                                 assign_idps: c.assign_idps,
                                                 user_name_expression: c.user_name_expression,
                                                 starts_with_expression: c.starts_with_expression,
                                                 exclude_users: c.exclude_users,
                                                 group_memberships: c.group_membership,
                                                 filter_by_network_perimeter: c.filter_by_network_perimeter
                                                 idcs_endpoint: c.idcs_endpoint
                                                 sequence: c.sequence
                                                 }}

    condition = ""
    idcs_endpoint = each.value.idcs_endpoint
    name = each.value.name
    description = each.value.description
    policy_type {
        value = "IdentityProvider"
    }
    return {
        name = "LocalIDPs"
        value = "[\"PUSH\",\"TOTP\",\"UserNamePassword\",\"FIDO_AUTHENTICATOR\"]"
        return_groovy = null
    }
    schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:Rule"]

    /*condition_group {
        type = "Condition"
        #value = oci_identity_domains_condition.idp_condition_user_expression[each.key].id
        #value = oci_identity_domains_condition.idp_condition_exclude_users[each.key].id
        value = oci_identity_domains_condition.idp_condition_group_membership[each.key].id
    }*/
    
    
}

/*resource "oci_identity_domains_condition" "idp_condition_user_expression" {    
    for_each = {for c in local.rules : c.key => {  
                                                 user_name_expression: c.user_name_expression,
                                                 starts_with_expression: c.starts_with_expression,
                                                 idcs_endpoint: c.idcs_endpoint
                                                 }}
        name              = "User Name Expression"
        attribute_name    = "actorName"
        attribute_value   = each.value.user_name_expression
        operator          = each.value.starts_with_expression ? "sw" : "ew"
        idcs_endpoint     = each.value.idcs_endpoint
        schemas           = ["urn:ietf:params:scim:schemas:oracle:idcs:Condition"]
}

resource "oci_identity_domains_condition" "idp_condition_exclude_users" {    
    for_each = {for c in local.rules : c.key => {   
                                                    exclude_users: c.exclude_users,
                                                    idcs_endpoint: c.idcs_endpoint
                                                 }}
        name              = "isNotInTheseUsers"
        attribute_name    = "userName"
        attribute_value   = jsonencode(each.value.exclude_users)
        operator          = "nin"
        idcs_endpoint     = each.value.idcs_endpoint
        schemas           = ["urn:ietf:params:scim:schemas:oracle:idcs:Condition"]
}

resource "oci_identity_domains_condition" "idp_condition_group_membership" {    
    for_each = {for c in local.rules : c.key => {   
                                                    group_membership: c.group_membership,
                                                    idcs_endpoint: c.idcs_endpoint
                                                 }}
        name              = "isInTheseGroups"
        attribute_name    = "user.groups[*].value"
        attribute_value   = jsonencode(each.value.group_membership)  #group id not ocid => data source
        operator          = "coany"
        idcs_endpoint     = each.value.idcs_endpoint
        schemas           = ["urn:ietf:params:scim:schemas:oracle:idcs:Condition"]
}*/

