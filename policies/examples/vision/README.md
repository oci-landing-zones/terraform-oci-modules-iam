# CIS OCI IAM Policy Module Example - Vision policies

## Introduction

This example shows how to manage Identity and Access Management (IAM) policies in Oracle Cloud Infrastructure (OCI) for a hypothetical Vision entity. The policies are generated based on freeform tags applied to compartments managed by the [Vision compartments module example](../../../compartments/examples/vision/). These policies are the same as those deployed by [CIS Landing Zone Quick Start](https://github.com/oracle-quickstart/oci-cis-landingzone-quickstart).

It showcases the two supported usage modes of the [policy module](../..): template policies and supplied policies.

In template mode, both compartment level and tenancy level policies are enabled.

- Compartment level policies are managed based on freeform tags applied to compartments. It selects compartments where *cislz* freeform tag matches *cislz_tag_lookup_value* attribute. Then it applies template policies based on *cislz-cmp-type* and *cislz-consumer-groups-\<suffix\>* freeform tags. 

- Tenancy level policies are managed based on *enable_tenancy_level_template_policies* and *groups_with_tenancy_level_roles* variables passed to the module.

Supplied policies mode is enabled by passing *supplied_policies* variable to the module.

Check the [policy module documentation](../../README.md) for details.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *policies_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-COMPARTMENT-OCID\>* placeholder by a compartment OCID. This determines the compartment that sample *supplied_policies* get attached to. If you are not interested in supplying your own policies, you can remove *supplied_policies* attribute altogether.

Refer to [README.md](../../README.md) for overall module functioning and to [SPEC.md](../../SPEC.md) for attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```