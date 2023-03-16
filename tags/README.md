# CIS OCI Landing Zone IAM Tags Module

![Landing Zone logo](../landing_zone_300.png)

This module manages defined tags resources in Oracle Cloud Infrastructure. A defined tag requires an enclosing tag namespace and can be auto-assigned default values in specific compartments.

Per CIS (Center for Internet Security) OCI Foundations Benchmark recommendation, the module checks for a potentially pre-configured tag namespace (tipically named *Oracle-Tags*). If the namespace does not exist and input variable *enable_cislz_namespace* is set to true, the module manages a tag namespace with two tags used to identify resource creators (*CreatedBy*) and when resources are created (*CreatedOn*). This namespace and associated tags can have their names customized through input variables *cislz_namespace_name*, *cislz_created_by_tag_name*, and *cislz_created_on_tag_name*, respectively.

Check [module specification](./SPEC.md) for a full description of module requirements, supported variables, managed resources and outputs.

Check the [examples](./examples/) folder for module usage with actual input data.

## How to Invoke the Module

Terraform modules can be invoked locally or remotely. 

For invoking the module locally, just set the module *source* attribute to the module file path (relative path works). The following example assumes the module is two folders up in the file system.
```
module "tags" {
  source = "../.."
  # <input variables>

}
```

For invoking the module remotely, set the module *source* attribute to the tags module folder in this repository, as shown:
```
module "tags" {
  source = "git@github.com:oracle-quickstart/terraform-oci-cis-landing-zone-iam-modules.git//tags"
  # <input variables>
}
```
For referring to a specific module version, append *ref=\<version\>* to the *source* attribute value, as in:
```
  source = "git@github.com:oracle-quickstart/terraform-oci-cis-landing-zone-iam-modules.git//tags?ref=v0.1.0"
```

## Related Documentation
- [OCI Tagging Documentation](https://docs.oracle.com/en-us/iaas/Content/Tagging/home.htm)
- [Tags in Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/4.112.0/docs/resources/identity_tag)

## Known Issues
None.
