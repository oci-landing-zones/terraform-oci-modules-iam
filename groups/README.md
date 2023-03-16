# CIS OCI Landing Zone IAM Groups Module

![Landing Zone logo](../landing_zone_300.png)

This module manages IAM (Identity & Access Management) groups in OCI (Oracle Cloud Infrastructure) based on a single map of objects. Groups are a fundamental construct in OCI IAM, acting as beneficiaries of IAM policies. 

CIS (Center for Internet Security) OCI Foundations Benchmark recommends the usage of service level admins to manage resources of a particular service. These admins can be local or federated groups. This modules manages local groups.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

Check the [examples](./examples/) folder for module usage. Specifically, see [cis-landing-zone-quickstart](./examples/cis-landing-zone-quickstart/README.md) example for the groups deployed by [CIS OCI Landing Zone Quick Start](https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart).

## Requirements
### IAM Permissions

This module requires the following OCI IAM permission:
```
Allow group <group> to manage groups in tenancy
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
module "groups" {
  source = "../.."
  tenancy_id = var.tenancy_id
  groups     = var.groups
}
```

For invoking the module remotely, set the module *source* attribute to the groups module folder in this repository, as shown:
```
module "groups" {
  source = "git@github.com:oracle-quickstart/terraform-oci-cis-landing-zone-iam-modules.git//groups"
  tenancy_id = var.tenancy_id
  groups     = var.groups
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "git@github.com:oracle-quickstart/terraform-oci-cis-landing-zone-iam-modules.git//groups?ref=v0.1.0"
```

## Related Documentation
- [Managing Groups](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managinggroups.htm)
- [Groups in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_group)

## Known Issues
None.
