# OCI Identity Domains Module Usage Example - Vision identity domains
## Introduction

This example shows how to deploy Identity and Access Management (IAM) identity domains in Oracle Cloud Infrastructure (OCI) for a hypothetical Vision entity.

It creates the following identity domains as shown in the picture below:

![Groups](./images/groups.PNG)

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice. 

**NOTE**: Each object in the *identity domains* map is indexed by an uppercase string, like *DEV-DOMAIN*, *PROD-DOMAIN*, etc. These strings are used by Terraform as keys to the actual managed resources. They can actually be any random strings, but once defined they **must not be changed**, or Terraform will try to destroy and recreate the groups.

1. Within *\<project-name\>*.auto.tfvars, provide tenancy connectivity information

2. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```