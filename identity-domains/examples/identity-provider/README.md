# OCI Identity Domains Module Usage Example - Vision identity domains
## Introduction

This example shows how to configure and Identity Provider for an existing Identity Domain in Oracle Cloud Infrastructure (OCI) for a hypothetical Vision entity.

It creates the following resources in one preexisting identity domain:

  *Identity Provider*:  "ENTRAID1"


## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice. 

**NOTE**: Each object in the *Identity Providers* map is indexed by an uppercase string, like *ENDTRAID1*. These strings are used by Terraform as keys to the actual managed resources. They can actually be any random strings, but once defined they **must not be changed**, or Terraform will try to destroy and recreate the groups.

2. Within *\<project-name\>*.auto.tfvars, provide tenancy connectivity information

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```