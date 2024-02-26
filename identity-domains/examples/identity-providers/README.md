# OCI Identity Domains Module Usage Example - Identity Providers
## Introduction

This example shows how to configure identity providers for an existing Identity Domain in Oracle Cloud Infrastructure (OCI) using the [Identity Domains module](../../).

It creates the following resources in one preexisting identity domain:

- **Identity Provider: "ID_Provider_1"**, using a SAML metadata file obtained from the Identity Provider configuration.
- **Identity Provider: "ID_Provider_2"**, using individual parameters obtained from the Identity Provider configuration.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *identity_domain_identity_providers_configuration* input variable, by making the appropriate substitutions:
- Replace *\<REPLACE-BY-DOMAIN-OCID>* placeholder by the identity domain OCID.

**NOTE**: Each object in the *identity-providers* map is indexed by an uppercase string, like *IDP1*. These strings are used by Terraform as keys to the actual managed resources. They can actually be any random strings, but once defined they **must not be changed**, or Terraform will try to destroy and recreate the groups.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```