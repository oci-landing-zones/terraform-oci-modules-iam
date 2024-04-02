# OCI Landing Zones IAM Modules

![Landing Zone logo](./landing_zone_300.png)

This repository contains Terraform OCI (Oracle Cloud Infrastructure) modules for IAM (Identity and Access Management) related resources that help customers align their OCI implementations with the CIS (Center for Internet Security) OCI Foundations Benchmark recommendations.

The following modules are available:
- [Compartments](./compartments/)
- [Policies](./policies/)
- [Groups](./groups/)
- [Dynamic Groups](./dynamic-groups/)
- [Identity Domains](./identity-domains/)

Within each module you find an *examples* folder. Each example is a fully runnable Terraform configuration that you can quickly test and put to use by modifying the input data according to your own needs.  

The modules support being a passed an object containing references to OCIDs (Oracle Cloud IDs) that they may depend on. Every input attribute that expects an OCID (typically, attribute names ending in _id or _ids) can be given either a literal OCID or a reference (a key) to the OCID. While these OCIDs can be literally obtained from their sources and pasted when setting the modules input attributes, a superior approach is automatically consuming the outputs of producing modules. For instance, the [Compartments](./compartments/) module may depend on tags for applying tag defaults. It can be passed a *tags_dependency* map with objects representing tags produced by the [Tags](https://github.com/oracle-oci-landing-zones/terraform-oci-landing-zone-governance/tags) module. The external dependency approach helps with the creation of loosely coupled Terraform configurations with clearly defined dependencies between them, avoiding copying and pasting OCIDs.

## OCI Foundations Benchmark Modules Collection

This repository is part of a broader collection of repositories containing modules that help customers align their OCI implementations with the CIS OCI Foundations Benchmark recommendations:
- [Identity & Access Management](https://github.com/oracle-oci-landing-zones/terraform-oci-landing-zone-iam) - current repository
- [Networking](https://github.com/oracle-oci-landing-zones/terraform-oci-landing-zone-networking)
- [Governance](https://github.com/oracle-oci-landing-zones/terraform-oci-landing-zone-governance)
- [Security](https://github.com/oracle-oci-landing-zones/terraform-oci-landing-zone-security)
- [Observability & Monitoring](https://github.com/oracle-oci-landing-zones/terraform-oci-landing-zone-observability)
- [Secure Workloads](https://github.com/oracle-oci-landing-zones/terraform-oci-secure-workloads)

The modules in this collection are designed for flexibility, are straightforward to use, and enforce CIS OCI Foundations Benchmark recommendations when possible.

Using these modules does not require a user extensive knowledge of Terraform or OCI resource types usage. Users declare a JSON object describing the OCI resources according to each module’s specification and minimal Terraform code to invoke the modules. The modules generate outputs that can be consumed by other modules as inputs, allowing for the creation of independently managed operational stacks to automate your entire OCI infrastructure.

## Contributing
See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License
Copyright (c) 2023, Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](./LICENSE) for more details.

## Known Issues
None.