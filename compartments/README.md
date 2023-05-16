# CIS OCI Landing Zone IAM Compartments Module

![Landing Zone logo](../landing_zone_300.png)

This module manages arbitrary Identity and Access Management (IAM) compartment topologies in Oracle Cloud Infrastructure (OCI) based on a map of objects that can be nested up to six levels. Appropriate compartments usage is a key consideration for OCI tenancy design and it is a recommendation of CIS (Center for Internet Security) OCI Foundations Benchmark. 

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

A fundamental principle in using a map of objects is the ability to quickly visualize the actual compartment structure by simply looking at the variable definition. The input variable is an object named *compartments_configuration*, with the following attributes:
- **compartments**: the map of objects that define compartments hierarchies. Each top (first level) compartment has a *parent_ocid* attribute to identify the compartment's parent (in other words, where the particular tree descends from). It overrides *default_parent_ocid*. Each compartment object as a *children* attribute that defines its sub-compartments. The *compartments* map supports up to **six** levels of nesting, which is the maximum supported by OCI.
- **default_parent_ocid**: determines the parent compartment for all your top (first level) compartments defined by the *compartments* attribute.
- **enable_delete**: determines whether or not OCI should physically delete compartments when destroyed by Terraform. Default is false.
- **default_defined_tags**: defined tags to apply to all compartments, unless overriden by *defined_tags* attribute within each compartment object.
- **default_freeform_tags**: freeform tags to apply to all compartments, unless overriden by *freeform_tags* attribute within each compartment object.
  **Note**: Freeform tags are limited to 10 tags per OCI resource.

It is also possible to apply tag defaults to compartments. Tag defaults are tag values that are automatically applied or required from users on any resources eventually created in the compartments and in their sub-compartments. Use tag defaults to enforce organization wide governance practices in your cloud infrastructure, like automatically applying the cost center identifier to specific compartments. Before using a tag default, a defined tag must be defined in OCI. For configuring tags, you can use the [Tags module in CIS OCI Landing Zone Governance repository](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-governance/tags/).

Tag defaults are defined using *tag_defaults* attribute within each compartment in *compartments* attribute. You can have multiple tag defaults in a single compartment. Each tag default requires an immutable key (use an uppercase string as a convention), a tag ocid (*tag_ocid*), the default value (*default_value*) and whether or not the value is required from users when creating resources (*is_user_required*). If *is_user_required* is not provided or set to false, the default value is automatically applied upon resource creation.  

**NOTE**: optional metadata added to compartments through *freeform_tags* attribute can be read by the [Policy Module](../policies/) for the automatic generation of pre-configured policies.

Check the [examples](./examples) folder for module usage with actual input data. 

## Requirements
### IAM Permissions

This module requires the following OCI IAM permission in compartments referred by *default_parent_ocid* and/or *parent_ocid*:
```
Allow group <group> to manage compartments in compartment <parent_compartment_name>
```
If parent is the root compartment, the permission becomes:
```
Allow group <group> to manage compartments in tenancy
```

#### For Tag Defaults
In case you are applying tag defaults to compartments, the following permissions are required:
```
Allow group <group> to manage tag-defaults in compartment <tag_default_compartment_name>
Allow group <group> to use tag-namespaces in compartment <tag_namespace_compartment_name>
Allow group <group> to inspect tag-namespaces in tenancy
```
- *\<tag_default_compartment_name\>* is the compartment where the tag default is applied.
- *\<tag_namespace_compartment_name\>* is the compartment where the tag namespace is available.

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
module "compartments" {
  source = "../.."
  compartments_configuration = var.compartments_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the compartments module folder in this repository, as shown:
```
module "compartments" {
  source = "git@github.com:oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//compartments"
  compartments_configuration = var.compartments_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "git@github.com:oracle-quickstart/terraform-oci-cis-landing-zone-iam.git//compartments?ref=v0.1.0"
```

## Related Documentation
- [Account and Access Concepts](https://docs.oracle.com/en-us/iaas/Content/GSG/Concepts/concepts-account.htm#concepts-access)
- [Managing Compartments](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingcompartments.htm)
- [Compartments in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment)
- [Managing Tag Defaults](https://docs.oracle.com/en-us/iaas/Content/Tagging/Tasks/managingtagdefaults.htm)
- [Tag Defaults in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_default)

## Known Issues
None.
