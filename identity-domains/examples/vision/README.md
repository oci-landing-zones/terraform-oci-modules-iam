# OCI Identity Domains Module Usage Example - Vision identity domains
## Introduction

This example shows how to deploy Identity and Access Management (IAM) identity domains in Oracle Cloud Infrastructure (OCI) for a hypothetical Vision entity.

It creates the following resources:

*Identity Domains*: "VISION_DEV_Identity_Domain" and "VISION_PROD_Identity_Domain".  Each in a different compartment specified by their OCID.   

*Groups*:  "Dev Group 1" and "Prod Group 1".  One on each identity domain.

*Dynamic Groups*: vision-sec-fun-dynamic-group, vision-appdev-fun-dynamic-group, vision-appdev-computeagent-dynamic-group, and vision-database-kms-dynamic-group.  In both Identity Domains


## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice. 

**NOTE**: Each object in the *Identity Domains*, *Groups* and *Dynamic Groups* map is indexed by an uppercase string, like *DEV-DOMAIN*, *PROD-DOMAIN*, *GRP1*, *SEC-FUN-DYN-GROUP*, etc. These strings are used by Terraform as keys to the actual managed resources. They can actually be any random strings, but once defined they **must not be changed**, or Terraform will try to destroy and recreate the groups.

2. Within *\<project-name\>*.auto.tfvars, provide tenancy connectivity information

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```