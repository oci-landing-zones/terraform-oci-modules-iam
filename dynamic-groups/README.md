# OCI Landing Zones IAM Dynamic Groups Module

![Landing Zone logo](../landing_zone_300.png)

This module manages Identity and Access Management (IAM) dynamic groups in Oracle Cloud Infrastructure (OCI) based on a single map of objects. Dynamic groups have their members dynamically defined by rules. These rules enable principal actors other than human users as IAM policy grantees. Dynamic groups can be made of a variety of OCI resources, like Database instances, Compute Instances, Functions, to mention a few.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

The module defines a single input variable named *dynamic_groups_configuration*, supporting the following attributes:
   - **dynamic_groups**: the map of objects that define the dynamic groups. Each object correspond to a dynamic group, with *name*, *description*, *matching_rule*, *defined_tags* and *freeform_tags* attributes. *matching_rule* is an expression that defines the principals assigned to the dynamic group resource.
   - **default_defined_tags**: defined tags to apply to all dynamic groups, unless overriden by *defined_tags* attribute within each dynamic group object.
   - **default_freeform_tags**: freeform tags to apply to all dynamic groups, unless overriden by *freeform_tags* attribute within each dynamic group object.

Check the [examples](./examples/) folder for module usage. Specifically, see [vision](./examples/vision/README.md) example for the dynamic groups deployed by [OCI Base Landing Zone](https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart).

## Requirements
### IAM Permissions

This module requires the following OCI IAM permission:
```
Allow group <group> to manage dynamic-groups in tenancy
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
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam/dynamic-groups"
  tenancy_id     = var.tenancy_id
  dynamic_groups_configuration = var.dynamic_groups_configuration
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//dynamic-groups?ref=v0.1.0"
```

## Related Documentation
- [Managing Dynamic Groups](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingdynamicgroups.htm)
- [Dynamic Groups in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group)

## Known Issues
None.
