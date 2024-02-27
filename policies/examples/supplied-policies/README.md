# CIS OCI IAM Policy Module Example - Supplied policies

## Introduction

This example shows how to use [CIS Landing Zone IAM policy module](../..) to manage policies that are directly supplied to the module.

Directly supplied policies are passed to the module via the *supplied_policies* attribute.

Check the [module documentation](../../README.md) for details.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *policies_configuration* input variable, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-COMPARTMENT-OCID\>* placeholder by a compartment OCID. This determines the compartment the sample policy gets attached to. Alternatively, instead of an OCID, you can replace the placeholder by the string "TENANCY-ROOT" for attaching the policy to the Root compartment.
   
Refer to [README.md](../../README.md) for overall module functioning and to [SPEC.md](../../SPEC.md) for attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```