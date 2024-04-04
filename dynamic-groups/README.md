# OCI Landing Zones IAM Dynamic Groups Module

![Landing Zone logo](../landing_zone_300.png)

This module manages Identity and Access Management (IAM) dynamic groups in Oracle Cloud Infrastructure (OCI) based on a single map of objects. Dynamic groups have their members dynamically defined by rules. These rules enable principal actors other than human users as IAM policy grantees. Dynamic groups can be made of a variety of OCI resources, like Database instances, Compute Instances, Functions, to mention a few.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

The module defines a single input variable named *dynamic_groups_configuration*, supporting the following attributes:
   - **dynamic_groups**: the map of objects that define the dynamic groups. Each object correspond to a dynamic group, with *name*, *description*, *matching_rule*, *defined_tags* and *freeform_tags* attributes. *matching_rule* is an expression that defines the principals assigned to the dynamic group resource.
   - **default_defined_tags**: defined tags to apply to all dynamic groups, unless overriden by *defined_tags* attribute within each dynamic group object.
   - **default_freeform_tags**: freeform tags to apply to all dynamic groups, unless overriden by *freeform_tags* attribute within each dynamic group object.

Check the [examples](./examples/) folder for module usage. Specifically, see [vision](./examples/vision/README.md) example for the dynamic groups deployed by [OCI Base Landing Zone](https://github.com/oci-landing-zones/oci-base-landing-zone).

## Requirements
### IAM Permissions

This module requires the following OCI IAM permission:
```
Allow group <group> to manage dynamic-groups in tenancy
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
module "dynamic-groups" {
  source = "../.."
  tenancy_id     = var.tenancy_id
  dynamic_groups_configuration = var.dynamic_groups_configuration
}
```

For invoking the module remotely, set the module *source* attribute to the dynamic-groups module folder in this repository, as shown:
```
module "dynamic-groups" {
  source = "github.com/oci-landing-zones/terraform-oci-landing-zone-iam/dynamic-groups"
  tenancy_id     = var.tenancy_id
  dynamic_groups_configuration = var.dynamic_groups_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oci-landing-zones/terraform-oci-landing-zone-iam//dynamic-groups?ref=v0.1.0"
```

## Related Documentation
- [Managing Dynamic Groups](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm)
- [Dynamic Groups in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group)

## Known Issues
None.
