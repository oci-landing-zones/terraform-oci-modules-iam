# CIS OCI IAM Policy Module Example - Template policies

## Introduction

This example shows how to use [CIS Landing Zone IAM policy module](../..) to manage policies that are generated based on freeform tags applied to existing compartments. A matching compartments example is available at https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam-modules/compartments/examples/vision.

For compartment level policies (excluding Root compartment), the target compartments are obtained from a data source whose output is filtered based on freeform tag "cislz" with value "vision". The returned compartments are passed to the policy module via the *supplied_compartments* attribute. 

For tenancy level policies (policies attached to Root compartment), a list of group names with their respective roles are passed to the module via the *groups_with_tenancy_level_roles* attribute.

See [main.tf](./main.tf).

Check the [module documentation](../../README.md) for details.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```