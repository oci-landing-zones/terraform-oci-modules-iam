<!-- BEGIN_TF_DOCS -->
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
| [oci_identity_tag_default.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_default) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tag_defaults_configuration"></a> [tag\_defaults\_configuration](#input\_tag\_defaults\_configuration) | Tag defaults keyed by stable logical identifiers. | <pre>map(object({<br/>    compartment_id    = string<br/>    tag_definition_id = string<br/>    default_value     = string<br/>    is_user_required  = bool<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tag_defaults"></a> [tag\_defaults](#output\_tag\_defaults) | The tag defaults. |
<!-- END_TF_DOCS -->