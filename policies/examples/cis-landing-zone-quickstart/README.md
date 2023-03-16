# OCI Policy Module Example - CIS Landing Zone Quick Start

## Introduction

This example shows how to manage IAM (Identity & Access Management) policy resources in Oracle Cloud Infrastructure as in [CIS Landing Zone Quick Start](https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart)

It showcases the two supported usage modes of the [policy module](../..): template policies and supplied policies.

In template policies mode, both compartment level and tenancy level policies are enabled.

- Compartment level policies are managed based on freeform tags applied to compartments. It selects compartments where *cislz* freeform tag matches *cislz_tag_lookup_value* input variable. Then it applies template policies based on *cislz-cmp-type* and *cislz-consumer-groups-\<suffix\>* freeform tags. 

- Tenancy level policies are managed based on *enable_tenancy_level_template_policies* and *groups_with_tenancy_level_roles* variables passed to the module.

Supplied policies mode is enabled by passing *custom_policies* variable to the module.

Check the [policy module documentation](../../README.md) for details.

## Using this example
1. See [input.auto.tfvars.template](./input.auto.tfvars.template) for providing tenancy connectivity information and setting the module input variables. 

Note this example depends on compartments properly tagged with required metadata for CIS Landing Zone policies. A matching coompartments example is available [here](../../../compartments/examples/cis-landing-zone-quickstart/).

2. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```