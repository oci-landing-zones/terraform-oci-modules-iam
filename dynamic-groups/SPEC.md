## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_identity_dynamic_group.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dynamic_groups_configuration"></a> [dynamic\_groups\_configuration](#input\_dynamic\_groups\_configuration) | The dynamic groups. | <pre>object({<br>    default_defined_tags = optional(map(string)),<br>    default_freeform_tags = optional(map(string))<br>    dynamic_groups = map(object({<br>      name          = string,<br>      description   = string,<br>      matching_rule = string<br>      defined_tags  = optional(map(string)),<br>      freeform_tags = optional(map(string))<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"iam-dynamic-groups"` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The OCID of the tenancy. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamic_groups"></a> [dynamic\_groups](#output\_dynamic\_groups) | The dynamic groups. |
