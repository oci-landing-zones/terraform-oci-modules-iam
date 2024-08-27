# OCI Landing Zones IAM Groups Module

![Landing Zone logo](../landing_zone_300.png)

This module manages Identity and Access Management (IAM) groups of user principals in Oracle Cloud Infrastructure (OCI) based on a single map of objects. Groups are a fundamental construct in OCI IAM, acting as beneficiaries of IAM policies. 

CIS (Center for Internet Security) OCI Foundations Benchmark recommends the usage of service level admins to manage resources of a particular service. These admins can be local or federated groups. This modules manages local groups.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

The module defines a single input variable named *groups_configuration*, supporting the following attributes:
   - **groups**: the map of objects that define the groups. Each object correspond to a group, with *name*, *description*, *members*, *defined_tags* and *freeform_tags* attributes. *members* is a list of existing user names to assign to the group.
   - **default_defined_tags**: defined tags to apply to all groups, unless overriden by *defined_tags* attribute within each group object.
   - **default_freeform_tags**: freeform tags to apply to all groups, unless overriden by *freeform_tags* attribute within each group object.
     **Note**: Freeform tags are limited to 10 tags per OCI resource.

Check the [examples](./examples/) folder for module usage. Specifically, see [vision](./examples/vision/README.md) example for the groups deployed by [OCI Base Landing Zone](https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart).

## Requirements
### Terraform Version >= 1.3.0

This module requires Terraform binary version 1.3.0 or greater, as it relies on Optional Object Type Attributes feature. The feature shortens the amount of input values in complex object types, by having Terraform automatically inserting a default value for any missing optional attributes.

### IAM Permissions

This module requires the following OCI IAM permission:
```
Allow group <group> to manage groups in tenancy
```

## How to Invoke the Module

Terraform modules can be invoked locally or remotely. 

For invoking the module locally, just set the module *source* attribute to the module file path (relative path works). The following example assumes the module is two folders up in the file system.
```
module "groups" {
  source = "../.."
  tenancy_id = var.tenancy_id
  groups     = var.groups
}
```

For invoking the module remotely, set the module *source* attribute to the groups module folder in this repository, as shown:
```
module "groups" {
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam/groups"
  tenancy_id = var.tenancy_id
  groups     = var.groups
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam//groups?ref=v0.1.0"
```

## Related Documentation
- [Managing Groups](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managinggroups.htm)
- [Groups in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_group)

## Known Issues
None.
