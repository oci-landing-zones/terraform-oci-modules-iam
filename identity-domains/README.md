# CIS OCI Landing Zone Identity Domains Module

![Landing Zone logo](../landing_zone_300.png)

This module manages Identity and Access Management (IAM) Identity Domains, Identity Domain Groups, Identity Domain Dynamic Groups, and SAML Identity Providers in Oracle Cloud Infrastructure (OCI) based on maps of objects. Identity Domains are a fundamental construct in OCI IAM, they represent a user a group population and its associated configurations and security settings (such as Federation, MFA).

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

Check the [examples](./examples/) folder for actual module usage.

- [Requirements](#requirements)
- [How to Invoke the Module](#invoke)
- [Module Functioning](#functioning)
- [Related Documentation](#related)
- [Known Issues](#issues)

## <a name="requirements">Requirements</a>

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

## <a name="invoke">How to Invoke the Module</a>

Terraform modules can be invoked locally or remotely. 

For invoking the module locally, just set the module *source* attribute to the module file path (relative path works). The following example assumes the module is two folders up in the file system.
```

module "identity_domains" {
  source       = "../../"
  tenancy_ocid = var.tenancy_ocid
  identity_domains_configuration                   = var.identity_domains_configuration
  identity_domain_groups_configuration             = var.identity_domain_groups_configuration
  identity_domain_dynamic_groups_configuration     = var.identity_domain_dynamic_groups_configuration
  identity_domain_identity_providers_configuration = var.identity_domain_identity_providers_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the groups module folder in this repository, as shown:
```
module "identity_domains" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam/identity-domains"
  tenancy_id                                       = var.tenancy_id
  identity_domains_configuration                   = var.identity_domains_configuration
  identity_domain_groups_configuration             = var.identity_domain_groups_configuration
  identity_domain_dynamic_groups_configuration     = var.identity_domain_dynamic_groups_configuration
  identity_domain_identity_providers_configuration = var.identity_domain_identity_providers_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//identity-domains?ref=v0.1.0"
```

## <a name="functioning">Module Functioning</a>

The module defines four top-level input variables named *identity_domains_configuration*, *identity_domain_groups_configuration*, *identity_domain_dynamic_groups_configuration*, and *identity_domain_identity_providers_configuration* for identity domains related attributes. A fourth top-level input variable, *compartments_dependency*, is used for bringing in externally managed compartments into identity domains configuration. See [External Dependencies](#extdep) section.

## Defining Identity Domains
Use *identity_domains_configuration* attribute. It supports the following attributes:

  - **default_compartment_id**: (Optional) defines the compartment for all identity domains, unless overriden by *compartment_id* attribute within each identity domain.  This attribute is overloaded: it can be either a compartment OCID or a reference (a key) to the compartment OCID. *tenancy_ocid* is used if undefined. See [External Dependencies](#extdep) section.
  - **default_defined_tags**: (Optional) defined tags to apply to all resources, unless overriden by *defined_tags* attribute within each resource.
  - **default_freeform_tags**: (Optional) freeform tags to apply to all resources, unless overriden by *freeform_tags* attribute within each resource.
  - **identity_domains**: (Optional) the map of objects that defines the identity domains, where each object corresponds to an identity domain resource.
    - **compartment_id**:  (Optional) The compartment for the identity domain. This attribute is overloaded: it can be either a compartment OCID or a reference (a key) to the compartment OCID. *default_compartment_id* is used if undefined. See [External Dependencies](#extdep).            
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
    - **defined_tags**: (Optional) defined tags to apply to the identity domain. *default_defined_tags* is used if undefined.             
    - **freeform_tags**:  (Optional) free tags to apply to the identity domain. *default_freeform_tags* is used if undefined.       

## Defining Identity Domain Groups
Use *identity_domain_groups_configuration* attribute. It supports the following attributes:

  - **default_identity_domain_id**: (Optional) defines the identity domain for all groups, unless overriden by *identity_domain_id* attribute within each group.  This attribute is overloaded: it can be either an existing identity domain OCID (if provisioning the group in an existing identity domain) or the identity domain reference (key) in identity_domains map.
  - **default_defined_tags**: (Optional) defined tags to apply to all resources, unless overriden by *defined_tags* attribute within each resource.
  - **default_freeform_tags**: (Optional) freeform tags to apply to all resources, unless overriden by *freeform_tags* attribute within each resource.     
  - **groups**: (Optional) the map of objects that defines groups of users, where each object corresponds to a group resource.
    - **identity_domain_id**: (Optional) The identity domain for the group. This attribute is overloaded: it can be either an existing identity domain OCID (if provisioning the group in an existing identity domain) or the identity domain reference (key) in identity_domains map.          
    - **name**:  (Required) The display name of the group.                     
    - **description**: (Optional) The description of the group.             
    - **requestable**: (Optional) Flag controlling whether group membership can be requested by users through self service console.  Example: true           
    - **members**: (Optional)  List of existing user names to assign to the group.                  
    - **defined_tags**: (Optional) defined tags to apply to the group. *default_defined_tags* is used if undefined.             
    - **freeform_tags**: (Optional) free tags to apply to the group. *default_freeform_tags* is used if undefined.     

## Defining Identity Domain Dynamic Groups
Use *identity_domain_dynamic_groups_configuration* attribute. It supports the following attributes:

  - **default_identity_domain_id**: (Optional) defines the identity domain for all dynamic groups, unless overriden by *identity_domain_id* attribute within each dynamic group.  This attribute is overloaded: it can be either an identity domain OCID or a reference (a key) to the identity domain OCID.
  - **default_defined_tags**: (Optional) defined tags to apply to all resources, unless overriden by *defined_tags* attribute within each resource.
  - **default_freeform_tags**: (Optional) freeform tags to apply to all resources, unless overriden by *freeform_tags* attribute within each resource.      
  - **dynamic_groups**: (Optional) the map of objects that defines dynamic groups, where each object corresponds to a dynamic group resource.
    - **identity_domain_id**: (Optional) The identity domain for the dynamic group. This attribute is overloaded: it can be either an existing identity domain OCID (if provisioning the dynamic group in an existing identity domain) or the identity domain reference (key) in identity_domains map.    
    - **name**:  (Required) The display name of the dynamic group.                      
    - **description**: (Optional) The description of the dynamic group.               
    - **matching_rule**: (Required)  An expression that defines the principals assigned to the dynamic group resource.             
    - **defined_tags**:  (Optional) defined tags to apply to the group. *default_defined_tags* is used if undefined.              
    - **freeform_tags**: (Optional) free tags to apply to the group. *default_freeform_tags* is used if undefined.   

## Defining Identity Domain Identity Providers
Use *identity_domain_identity_providers_configuration* attribute. It supports SAML Identity Providers which can be configured either by importing the IDP SAML Metadata (XML file) or by directly specifying the IDP parameters.  It supports the following attributes:

  - **default_identity_domain_id**: (Optional) defines the identity domain for all identity proviers, unless overriden by *identity_domain_id* attribute within each identity provider.  This attribute is overloaded: it can be either an identity domain OCID or a reference (a key) to the identity domain OCID.    
  - **identity_providers**: (Optional) the map of objects that defines identity providers, where each object corresponds to an identity provider resource.
    - **identity_domain_id**: (Optional) The identity domain for the identity provider. This attribute is overloaded: it can be either an existing identity domain OCID (if provisioning the identity provider in an existing identity domain) or the identity domain reference (key) in identity_domains map.    
    - **name**:  (Required) The display name of the identity provider.                      
    - **description**: (Optional) The description of the identity provider.               
    - **enabled**: (Required)  Flag controlling whether the identiy provider is enabled or disabled.
    - **name_id_format**: (Optional) The requested Name ID format.  Possible values:  *saml-emailaddress*, *saml-x509*, *saml-kerberos*, *saml-persistent*, *saml-transient*, *saml-unspecified*, *saml-windowsnamequalifier*.  Default is *saml-none*.
    - **user_mapping_method**: (Optional)  The user identity mapping network for the identity provider.  Possible values: *NameIDToUserAttribute*, *AssertionAttributeToUserAttribute*, or *CorrelationPolicyRule*. 
    - **user_mapping_store_attribute**: (Optional)  The identity domain user mapping attribute, e.g. *userName*.
    - **assertion_attribute**: (Optional) The assertion attribute name from the IDP when using *user_mapping_method = AssertionAttributeToUserAttribute*.
    - **signature_hash_algorithm**: (Optional) The signature has algorithm of the identity provider, either *SHA-256* (Default) or *SHA-1*.
    - **send_signing_certificate**: (Optional) Flag controlling whether to send signing certificate with SAML message.  Default is *false*.
    - **idp_metadata_file**: (Optional)  Full path in the local system to the xml file with the Identity Provider SAML metadata.  If this parameter is null then the following parameters are used to configure the identity provider entry: *idp_issuer_uri*, *sso_service_url*, *sso_service_binding*, *idp_signing_certificate*, *enable_global_logout*, *idp_logout_request_url*, *idp_logout_response_url*, *idp_logout_binding*.
    - **idp_issuer_uri**: The unique identifier of the IdP, also called its Entity ID or Provider ID. This will be the value of the Issuer field in SAML messages sent by this IdP.  This parameter is ignored if *idp_metadata_file* is used. 
    - **sso_service_url**: The service endpoint URL at the Identity provider to which identity domain service will send SAML authentication requests.  This parameter is ignored if *idp_metadata_file* is used. 
    - **sso_service_binding**:  Specify either "Post" or "Redirect" whether the identity domain will send SAML authentication requests to the IdP using the HTTP Redirect or HTTP POST method. This must agree with the methods supported by the IdP for the configured IdP SSO service URL.  This parameter is ignored if *idp_metadata_file* is used. 
    - **idp_signing_certificate**:  The public key certificate that will be used to verify the signature on SAML messages sent by this IdP. This should be the text containing the base-64-encoded bytes of the certificate, also known as PEM format without the BEGIN CERTIFICATE and END CERTIFICATE lines.  This parameter is ignored if *idp_metadata_file* is used. 
    - **enable_global_logout**:  If true (Default value), identity domain will send a SAML logout request to the IdP when the user logs out. If false, no SAML logout request will be sent.  This parameter is ignored if *idp_metadata_file* is used. 
    - **idp_logout_request_url**: The service endpoint URL at the Identity provider to which the identity domain will send SAML logout requests when the user logs out.  This parameter is ignored if *idp_metadata_file* is used. 
    - **idp_logout_response_url**:  The service endpoint URL at the Identity provider to which identity domain will send SAML logout responses, when the IdP initiates SAML logout.  This parameter is ignored if *idp_metadata_file* is used. 
    - **idp_logout_binding**:  Specify either "Post" or "Redirect" whether the identity domain will send SAML logout requests and responses to the IdP using the HTTP Redirect or HTTP POST method. This must agree with the method supported by the IdP for the configured IdP Logout Request and Response URLs.  This parameter is ignored if *idp_metadata_file* is used. 

          

Check the [examples](./examples/) folder for module usage. Specifically, see [vision](./examples/vision/README.md) example to deploy two identity domains including groups and dynamic_groups.


### <a name="extdep">External Dependencies</a>

An optional feature, external dependencies are resources managed elsewhere that resources managed by this module may depend on. The following dependencies are supported:

- **compartments_dependency**: A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an *id* attribute with the compartment OCID. This mechanism allows for the usage of referring keys (instead of OCIDs) in identity domains *default_compartment_id* and *compartment_id* attributes. The module replaces the keys by the OCIDs provided within *compartments_dependency* map. Contents of *compartments_dependency is typically the output of a [Compartments module](../compartments/) client.

## <a name="related">Related Documentation</a>
- [Managing Identity Domains](https://docs.oracle.com/en-us/iaas/Content/Identity/domains/overview.htm)
- [Identity Domains in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_domain)
- [Federating with Identity Providers](https://docs.oracle.com/en-us/iaas/Content/Identity/federating/federating_section.htm)
- [SSO Between OCI and Microsoft Azure](https://docs.oracle.com/en-us/iaas/Content/Identity/tutorials/azure_ad/sso_azure/azure_sso.htm)
- [SSO With OCI and Okta](https://docs.oracle.com/en-us/iaas/Content/Identity/tutorials/okta/sso_okta/sso_okta.htm)


## <a name="issues">Known Issues</a>
1. Terraform will not destroy identity domains. In order do destroy an identity domain, first run ```terraform destroy``` to destroy contained resources (groups, dynamic groups, identity providers...). The error ```"Error: 412-PreConditionFailed, Cannot perform DELETE_DOMAIN operation on Domain with Status CREATED"``` is returned.  Then deactivate and delete the identity domain(s) using the OCI console or OCI CLI, as in:
```
  oci iam domain deactivate --domain-id <identity domain OCID>
  oci iam domain delete --domain-id <identity domain OCID>
```

