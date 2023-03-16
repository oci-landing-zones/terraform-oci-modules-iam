# CIS OCI Landing Zone IAM Modules

![Landing Zone logo](./landing_zone_300.png)

This repository contains Terraform OCI (Oracle Cloud Infrastructure) modules for IAM (Identity and Access Management) that comply with CIS (Center for Internet Security) OCI Foundations Benchmark.

The following modules are available:
- [Compartments](./compartments/)
- [Policies](./policies/)
- [Groups](./groups/)
- [Dynamic Groups](./dynamic-groups/)
- [Tags](./tags/)

Within each module you find an *examples* folder. Each example is a fully runnable Terraform configuration that you can quickly test and put to use by modifying the input data according to your own needs.  

This repository is part of a broader collection of repositories with CIS compliant modules:
- [Security]()
- [Networking]()
- [Observability & Monitoring]()
- [Governance]()

All modules in this collection are designed for flexibility and ease of use. They do not require extensive knowledge of Terraform or details about OCI resource types usage from our users. Users are required to declare a JSON object describing the resource (or set of resources) according to each module interface and minimal Terraform code to invoke the modules. All modules generate outputs that can be fed into other modules as inputs, thus allowing for the creation of independently managed operational stacks to automate your entire OCI infrastructure.

## Contributing
See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License
Copyright (c) 2023, Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](./LICENSE) for more details.

## Known Issues
None.