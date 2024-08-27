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
| [oci_identity_group.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_group) | resource |
| [oci_identity_user_group_membership.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_user_group_membership) | resource |
| [oci_identity_users.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_users) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_groups_configuration"></a> [groups\_configuration](#input\_groups\_configuration) | The groups configuration. | <pre>object({<br>    default_defined_tags  = optional(map(string)),<br>    default_freeform_tags = optional(map(string))<br>    groups = map(object({<br>      name          = string,<br>      description   = string,<br>      members       = optional(list(string)),<br>      defined_tags  = optional(map(string)),<br>      freeform_tags = optional(map(string))<br>    }))<br>  })</pre> | `null` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"iam-groups"` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The OCID of the tenancy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_groups"></a> [groups](#output\_groups) | The groups. |
| <a name="output_memberships"></a> [memberships](#output\_memberships) | The group memberships. |
