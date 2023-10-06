# CIS OCI Landing Zone IAM Compartments Module

![Landing Zone logo](../landing_zone_300.png)

This module manages arbitrary Identity and Access Management (IAM) compartment topologies in Oracle Cloud Infrastructure (OCI) based on a map of objects that can be nested up to six levels. Appropriate compartments usage is a key consideration for OCI tenancy design and it is a recommendation of CIS (Center for Internet Security) OCI Foundations Benchmark. 

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

A fundamental principle in using a map of objects is the ability to quickly visualize the actual compartment structure by simply looking at the variable definition. The input variable is an object named *compartments_configuration*, with the following attributes:
- **default_parent_id** &ndash; (Optional) determines the parent compartment for all your top (first level) compartments defined by the *compartments* attribute. This attribute is overloaded: it can be either a compartment OCID or a reference (a key) to the compartment OCID. *tenancy_ocid* is used if undefined.
- **enable_delete** &ndash; (Optional) determines whether or not OCI should physically delete compartments when destroyed by Terraform. Default is false.
- **default_defined_tags** &ndash; (Optional) defined tags to apply to all compartments, unless overriden by *defined_tags* attribute within each compartment object.
- **default_freeform_tags** &ndash; (Optional) freeform tags to apply to all compartments, unless overriden by *freeform_tags* attribute within each compartment object. Freeform tags are limited to 10 tags per OCI resource.
- **compartments** &ndash; (Optional) the map of objects that define compartments hierarchies. Each top (first level) compartment has a *parent_id* attribute to identify the compartment's parent (in other words, where the particular tree descends from). It overrides *default_parent_id*. Each compartment object has a *children* attribute that defines its sub-compartments. The *compartments* map supports up to **six** levels of nesting, which is the maximum supported by OCI.
  - **name** &ndash; The compartment name.
  - **description** &ndash; The compartment description.
  - **parent_id** &ndash; (Optional) The compartment's parent compartment. Only available for first-level compartments. This attribute is overloaded: it can be either a compartment OCID or a reference (a key) to the compartment OCID. *default_parent_id* is used if undefined.
  - **defined_tags** &ndash; (Optional) The compartment defined_tags. *default_defined_tags* is used if undefined.
  - **freeform_tags** &ndash; (Optional) The compartment freeform_tags. *default_freeform_tags* is used if undefined.
  - **tag_defaults** &ndash; (Optional) A map of tag defaults to apply to the compartment. Every resource created in the compartmet is tagged per this setting.
    - **tag_id** &ndash; The tag default tag id. This attribute is overloaded: it can be either a tag OCID or a reference (a key) to the tag OCID. 
    - **default_value** &ndash; The default value to assign to the tag.
    - **is_user_required** &ndash; (Optional) Whether the user must provide a tag value for resources created in the compartment.
  - **children**:  &ndash; (Optional) The map of sub-compartments. It has the same structure of the *compartments* map, except for the *parent_id* attribute.  

Note it is possible to apply tag defaults to compartments. Tag defaults are tag values that are automatically applied or required from users on any resources eventually created in the compartments and in their sub-compartments. Use tag defaults to enforce organization wide governance practices in your cloud infrastructure, like automatically applying the cost center identifier to specific compartments. Before using a tag default, a defined tag must be defined in OCI. For configuring tags, you can use the [Tags module in CIS OCI Landing Zone Governance repository](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-governance/tags/).

Tag defaults are defined using *tag_defaults* attribute within each compartment in *compartments* attribute. You can have multiple tag defaults in a single compartment. Each tag default requires an immutable key (use an uppercase string as a convention), a tag id (*tag_id*), the default value (*default_value*) and whether or not the value is required from users when creating resources (*is_user_required*). If *is_user_required* is not provided or set to false, the default value is automatically applied upon resource creation.  

## Identifying Keys

Each compartment is identified by Terraform with an artificial key provided in the input variable. For example, in the snippet below, *DATABASE* (rows 4-13) identifies the *database-cmp* compartment, while *PROD* (rows 8-11) identifies its child *database-production-cmp* compartment.
```
1  compartments_configuration = { 
2    default_parent_id = "<COMPARTMENT-OCID>"
3    compartments = {
4      DATABASE = { 
5        name = "database-cmp" 
6        description = "Database compartment"
7        children = {
8          PROD = {
9            name = "database-production-cmp"
10           description = "Database production compartment"
11         }
12       }      
13     }
14   }
15 }    
```

These identifying keys are used in Terraform state file as resource addresses. By default, the keys are written "as-is" to the state file. As such, they must be unique across all compartment definitions. However, when defining complex hierarchies where distinct compartment subtrees has similar characteristics, it is desirable to use the same identifying key across the subtrees, as in when both *DATABASE* and *APPLICATION* compartments have PROD compartments. In use cases like this, set the variable **derive_keys_from_hierarchy** to true and the *PROD* compartments will be identified as *DATABASE-PROD* and *APPLICATION-PROD*. It works at all levels in the hierarchy, i.e., if *DATABASE*'s *PROD* had a child defined as *HR* in the variable declaration, the *HR* compartment would be identified as *DATABASE-PROD-HR* in Terraform state file.

**derive_keys_from_hierarchy**: whether identifying keys should be derived from the provided compartments hierarchy. It allows for using the same identifying key in different compartment subtrees, thus removing the requirement of unique keys. Default is false.

Check the [examples](./examples) folder for module usage with actual input data. 

## External Dependencies

An optional feature, external dependencies are resources managed elsewhere that resources managed by this module may depend on. The following dependencies are supported:

- **tags_dependency** &ndash; (Optional) A map of objects containing the externally managed tags this module may depend on. All map objects must have the same type and must contain at least an *id* attribute with the tag OCID.
- **compartments_dependency** &ndash; (Optional) A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an *id* attribute with the tag OCID. This is typically used when using separate configurations for managing compartments.

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
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam/compartments"
  compartments_configuration = var.compartments_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//compartments?ref=v0.1.0"
```

## Related Documentation
- [Account and Access Concepts](https://docs.oracle.com/en-us/iaas/Content/GSG/Concepts/concepts-account.htm#concepts-access)
- [Managing Compartments](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingcompartments.htm)
- [Compartments in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment)
- [Managing Tag Defaults](https://docs.oracle.com/en-us/iaas/Content/Tagging/Tasks/managingtagdefaults.htm)
- [Tag Defaults in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_default)

## Known Issues
None.
