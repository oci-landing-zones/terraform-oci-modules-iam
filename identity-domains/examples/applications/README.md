
# OCI Identity Domains Module Usage Example - Applications

## Introduction

This example shows how to configure Applications for an existing Identity Domain in Oracle Cloud Infrastructure (OCI) using the [Identity Domains module](../../README.md).

It creates the following resources in one preexisting identity domain:

- **SAML Application: "SAML_APP"**, SAML application that allows users to use single sign-on (SSO) to access your software as a service (SaaS) applications that support SAML for SSO.
- **Confidential Application: "CONF_APP"**, web-server/server-side application that uses OAuth 2.0.
- **Mobile Application: "MOBILE_APP"**, mobile/single-page application that uses OAuth 2.0.
- **Catalog Application Oracle Identity Domain: "SCIM_APP"**, SCIM application for provisioning to an Oracle Identity Domain.
- **Catalog Application GenericScim - Client Credentials: "GENERIC_SCIM_APP"**, SCIM application for provisioning to a scim application.
- **Catalog Application Oracle Fusion Applications Release 13: "FUSION_APP"**, SCIM/SAML application for provisioning/SSO to Oracle Fusion Applications.

## Using this example

1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the *identity_domain_applications_configuration* input variable, by making the appropriate substitutions:

   - Replace *\<REPLACE-BY-DOMAIN-OCID>* placeholder by the identity domain OCID.

    **NOTE**: Each object in the *applications* map is indexed by an uppercase string, like *APP1*. These strings are used by Terraform as keys to the actual managed resources. They can actually be any random strings, but once defined they **must not be changed**, or Terraform will try to destroy and recreate the applications.

3. In this folder, run the typical Terraform workflow:

   ```
   terraform init
   terraform plan -out plan.out
   terraform apply plan.out
   ```
