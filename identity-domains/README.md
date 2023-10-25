# CIS OCI Landing Zone Identity Domains Module

![Landing Zone logo](../landing_zone_300.png)

This module manages Identity and Access Management (IAM) Identity Domains in Oracle Cloud Infrastructure (OCI) based on a single map of objects. Identity Domains are a fundamental construct in OCI IAM, they represent a user a group population and its associated configurations and security settings (such as Federation, MFA).

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

The module defines three input variables named *identity_domains_configuration*, *identity_domain_groups_configuration*, and *identity_domain_dynamic_groups_configuration*, where all aspects of identity domains are defined.  They support the following attributes:

*identity_domains_configuration*
  - **default_compartment_id**: (Optional) defines the compartment for all identity domains, unless overriden by *compartment_id* attribute within each identity domain.  This attribute is overloaded: it can be either a compartment OCID or a reference (a key) to the compartment OCID. *tenancy_ocid* is used if undefined.
  - **default_defined_tags**: (Optional) defined tags to apply to all resources, unless overriden by *defined_tags* attribute within each resource.
  - **default_freeform_tags**: (Optional) freeform tags to apply to all resources, unless overriden by *freeform_tags* attribute within each resource.
  - **identity_domains**: (Optional) the map of objects that defines the identity domains, where each object corresponds to an identity domain resource.
    - **compartment_id**:  (Optional) The compartment for the identity domain. This attribute is overloaded: it can be either a compartment OCID or a reference (a key) to the compartment OCID. *default_compartment_id* is used if undefined.             
    - **display_name**:  (Required) The mutable display name for the identity domain.              
    - **description**:  (Required) The description of the identity domain.              
    - **home_region**:  (Required) The region name of the identity domain. The tenancy home region name is used if undefined.  Example: us-ashburn-1
    - **license_type**: (Required) The license type of the identity domain.  Examples: free, oracle-apps-premium, premium, external-user.             
    - **admin_email**:  (Optional) The email address of the identity domain administrator.               
    - **admin_first_name**: (Optional) The first name of the identity domain administrator.      
    - **admin_last_name**: (Optional) The last name of the identity domain administrator.              
    - **admin_user_name**: (Optional) The username for the identity domain administrator.             
    - **is_hidden_on_login**:  (Optional) Indicates whether the identity domain is hidden on login screen or not.  Example: true   
    - **is_notification_bypassed**:  Indicates if admin user created in the Identity Domain would like to receive notification like welcome email or not. Required field only if admin information is provided, otherwise optional.  
    - **is_primary_email_required**: (Optional) Indicates whether users in the domain are required to have a primary email address or not.  Example: true
    - **defined_tags**: (Optional) defined tags to apply to the identity domain. **default_defined_tags** is used if undefined.             
    - **freeform_tags**:  (Optional) free tags to apply to the identity domain. **default_freeform_tags** is used if undefined.       

*identity_domain_groups_configuration*  
  - **default_identity_domain_id**: (Optional) defines the identity domain for all groups, unless overriden by *identity_domain_id* attribute within each group.  This attribute is overloaded: it can be either an existing identity domain OCID (if provisioning the group in an existing identity domain) or the identity domain reference (key) in identity_domains map.
  - **default_defined_tags**: (Optional) defined tags to apply to all resources, unless overriden by *defined_tags* attribute within each resource.
  - **default_freeform_tags**: (Optional) freeform tags to apply to all resources, unless overriden by *freeform_tags* attribute within each resource.     
  - **groups**: (Optional) the map of objects that defines groups of users, where each object corresponds to a group resource.
    - **identity_domain_id**: (Optional) The identity domain for the group. This attribute is overloaded: it can be either an existing identity domain OCID (if provisioning the group in an existing identity domain) or the identity domain reference (key) in identity_domains map.          
    - **name**:  (Required) The display name of the group.                     
    - **description**: (Optional) The description of the group.             
    - **requestable**: (Optional) Flag controlling whether group membership can be requested by users through self service console.  Example: true           
    - **members**: (Optional)  List of existing user names to assign to the group.                  
    - **defined_tags**: (Optional) defined tags to apply to the group. **default_defined_tags** is used if undefined.             
    - **freeform_tags**: (Optional) free tags to apply to the group. **default_freeform_tags** is used if undefined.     

*identity_domain_dynamic_groups_configuration*
  - **default_identity_domain_id**: (Optional) defines the identity domain for all dynamic groups, unless overriden by *identity_domain_id* attribute within each dynamic group.  This attribute is overloaded: it can be either an identity domain OCID or a reference (a key) to the identity domain OCID.
  - **default_defined_tags**: (Optional) defined tags to apply to all resources, unless overriden by *defined_tags* attribute within each resource.
  - **default_freeform_tags**: (Optional) freeform tags to apply to all resources, unless overriden by *freeform_tags* attribute within each resource.      
  - **dynamic_groups**: (Optional) the map of objects that defines dynamic groups, where each object corresponds to a dynamic group resource.
    - **identity_domain_id**: (Optional) The identity domain for the dynamic group. This attribute is overloaded: it can be either an existing identity domain OCID (if provisioning the dynamic group in an existing identity domain) or the identity domain reference (key) in identity_domains map.    
    - **name**:  (Required) The display name of the dynamic group.                      
    - **description**: (Optional) The description of the dynamic group.               
    - **matching_rule**: (Required)  An expression that defines the principals assigned to the dynamic group resource.             
    - **defined_tags**:  (Optional) defined tags to apply to the group. **default_defined_tags** is used if undefined.              
    - **freeform_tags**: (Optional) free tags to apply to the group. **default_freeform_tags** is used if undefined.             

Check the [examples](./examples/) folder for module usage. Specifically, see [vision](./examples/vision/README.md) example to deploy two identity domains including groups and dynamic_groups.

## Requirements
### IAM Permissions

This module requires the following OCI IAM permission:
```
Allow group <group> to manage domains in tenancy
```
### Terraform Version < 1.3.x and Optional Object Type Attributes
This module relies on [Terraform Optional Object Type Attributes feature](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes), which is experimental from Terraform 0.14.x to 1.2.x. It shortens the amount of input values in complex object types, by having Terraform automatically inserting a default value for any missing optional attributes. The feature has been promoted and it is no longer experimental in Terraform 1.3.x.

**As is, this module can only be used with Terraform versions up to 1.2.x**, because it can be consumed by other modules via [OCI Resource Manager service](https://docs.oracle.com/en-us/iaas/Content/ResourceManager/home.htm), that still does not support Terraform 1.3.x.

Upon running *terraform plan* with Terraform versions prior to 1.3.x, Terraform displays the following warning:
```
Warning: Experimental feature "module_variable_optional_attrs" is active
```

Note the warning is harmless. The code has been tested with Terraform 1.3.x and the implementation is fully compatible.

If you really want to use Terraform 1.3.x, in [providers.tf](./providers.tf):
1. Change the terraform version requirement to:
```
required_version = ">= 1.3.0"
```
2. Remove the line:
```
experiments = [module_variable_optional_attrs]
```
## How to Invoke the Module

Terraform modules can be invoked locally or remotely. 

For invoking the module locally, just set the module *source* attribute to the module file path (relative path works). The following example assumes the module is two folders up in the file system.
```

module "identity_domains" {
  source       = "../../"
  tenancy_ocid = var.tenancy_ocid
  identity_domains_configuration                = var.identity_domains_configuration
  identity_domain_groups_configuration          = var.identity_domain_groups_configuration
  identity_domain_dynamic_groups_configuration  = var.identity_domain_dynamic_groups_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the groups module folder in this repository, as shown:
```
module "identity_domains" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam/identity-domainss"
  tenancy_id                                    = var.tenancy_id
  identity_domains_configuration                = var.identity_domains_configuration
  identity_domain_groups_configuration          = var.identity_domain_groups_configuration
  identity_domain_dynamic_groups_configuration  = var.identity_domain_dynamic_groups_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam/identity-domains?ref=v0.1.0"
```
## Related Documentation
- [Managing Identity Domains](https://docs.oracle.com/en-us/iaas/Content/Identity/domains/overview.htm)
- [Identity Domain in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_domain)

## Known Issues
Terraform will not destroy identity domains. In order do destroy an identity domain, first run ```terraform destroy``` to destroy contained resources (groups, dynamic groups...). The error ```"Error: 412-PreConditionFailed, Cannot perform DELETE_DOMAIN operation on Domain with Status CREATED"``` is returned.  Then deactivate and delete the identity domain(s) using the OCI console or OCI CLI, as in:
```
  oci iam domain deactivate --domain-id <identity domain OCID>
  oci iam domain delete --domain-id <identity domain OCID>
```

