# OCI Landing Zones IAM Tag Defaults Module

This module manages OCI tag defaults from a flat map with stable logical keys. It is designed to consume the `tag_defaults_configuration` output of the sibling Compartments module when tag-default lifecycle changes must remain outside the compartment dependency graph.

Check the [module specification](./SPEC.md) for the complete input, resource, and output contract.

```hcl
module "compartments" {
  source = "../compartments"

  tenancy_ocid               = var.tenancy_ocid
  compartments_configuration = var.compartments_configuration
  compartments_dependency    = var.compartments_dependency
  tags_dependency            = var.tags_dependency
  enable_tag_defaults        = false
}

module "tag_defaults" {
  source = "../tag-defaults"

  tag_defaults_configuration = module.compartments.tag_defaults_configuration
}
```

The Compartments module continues to manage tag defaults by default. Disable that behavior only when another module instance takes ownership of the normalized configuration.
