# OCI Identity Domains Module Usage Example - Vision identity domains
## Introduction

This example shows how to deploy Identity and Access Management (IAM) identity domain Groups and Dynamic Groups with existing Identity Domains in Oracle Cloud Infrastructure (OCI) for a hypothetical Vision entity.

It creates the following resources in one or more preexisting identity domains:

  *Groups*:  "Dev Group 1" and "Prod Group 1"

  *Dynamic Groups*: vision-sec-fun-dynamic-group, vision-appdev-fun-dynamic-group, vision-appdev-computeagent-dynamic-group, and vision-database-kms-dynamic-group



## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice. 

**NOTE**: Each object in the *Groups* and *Dynamic Groups* map is indexed by an uppercase string, like *GRP1*, *GRP2*, *SEC-FUN-DYN-GROUP*, etc. These strings are used by Terraform as keys to the actual managed resources. They can actually be any random strings, but once defined they **must not be changed**, or Terraform will try to destroy and recreate the groups.

2. Within *\<project-name\>*.auto.tfvars, provide tenancy connectivity information

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```