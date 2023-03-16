## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) |  >= 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_identity_policy.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_compartments.all](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartments) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cislz_tag_lookup_value"></a> [cislz\_tag\_lookup\_value](#input\_cislz\_tag\_lookup\_value) | The cislz tag value used for looking up compartments. This module searches for compartments that are freeform tagged with cislz = <cislz\_tag\_lookup\_value>. The selected compartments are eligible for template (pre-configured) policies. If the lookup fails, no template policies are applied. | `string` | `""` | no |
| <a name="input_custom_policies"></a> [custom\_policies](#input\_custom\_policies) | A map of custom policies. Use this to suplement the template (pre-configured) policies. For completely overriding the template policies, set variables enable\_compartment\_level\_template\_policies and enable\_tenancy\_level\_template\_policies to false. | <pre>map(object({<br>    name             = string<br>    description      = string<br>    compartment_ocid = string<br>    statements       = list(string)<br>    defined_tags     = map(string)<br>    freeform_tags    = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Any defined tags to apply on the template (pre-configured) policies. | `map(string)` | `null` | no |
| <a name="input_enable_cis_benchmark_checks"></a> [enable\_cis\_benchmark\_checks](#input\_enable\_cis\_benchmark\_checks) | Whether to check policies for CIS Benchmark recommendations. | `bool` | `true` | no |
| <a name="input_enable_compartment_level_template_policies"></a> [enable\_compartment\_level\_template\_policies](#input\_enable\_compartment\_level\_template\_policies) | Enables the module to manage template (pre-configured) policies at the compartment level (compartments other than root). | `string` | `true` | no |
| <a name="input_enable_debug"></a> [enable\_debug](#input\_enable\_debug) | Whether to show module debug output. | `bool` | `false` | no |
| <a name="input_enable_output"></a> [enable\_output](#input\_enable\_output) | Whether to show module output. | `bool` | `false` | no |
| <a name="input_enable_tenancy_level_template_policies"></a> [enable\_tenancy\_level\_template\_policies](#input\_enable\_tenancy\_level\_template\_policies) | Enables the module to manage template (pre-configured) policies at the tenancy level (root compartment). Variable groups\_with\_tenancy\_level\_roles only applies if this is set to true. | `string` | `false` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | Any freeform tags to apply on the template (pre-configured) policies. | `map(string)` | `null` | no |
| <a name="input_groups_with_tenancy_level_roles"></a> [groups\_with\_tenancy\_level\_roles](#input\_groups\_with\_tenancy\_level\_roles) | A list of group names and their roles at the root compartment (a.k.a tenancy) level. Pre-configured policies are assigned to each group in the root compartment. Only applicable if variable enable\_tenancy\_level\_policies is set to true. | <pre>list(object({<br>    name = string<br>    roles = string<br>  }))</pre> | `[]` | no |
| <a name="input_policy_name_prefix"></a> [policy\_name\_prefix](#input\_policy\_name\_prefix) | A string used as naming prefix to template (pre-configured) policy names. | `string` | `null` | no |
| <a name="input_target_compartments"></a> [target\_compartments](#input\_target\_compartments) | List of compartments that are policy targets. | <pre>list(object({<br>    name = string<br>    ocid = string<br>    freeform_tags = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The tenancy ocid. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_list_of_compartments_types_tagged_with_cislz_tag_lookup_value"></a> [list\_of\_compartments\_types\_tagged\_with\_cislz\_tag\_lookup\_value](#output\_list\_of\_compartments\_types\_tagged\_with\_cislz\_tag\_lookup\_value) | An internal list with compartments tagged with cislz\_tag\_lookup\_value. Used to find if an enclosing compartment is available. Enabled if enable\_debug variable is true. |
| <a name="output_map_of_compartments_tagged_with_cislz_tag_lookup_value"></a> [map\_of\_compartments\_tagged\_with\_cislz\_tag\_lookup\_value](#output\_map\_of\_compartments\_tagged\_with\_cislz\_tag\_lookup\_value) | An internal map driving the assignment of pre-configured policies according to cislz tags. Enabled if enable\_debug variable is true. |
| <a name="output_policies"></a> [policies](#output\_policies) | The policies. Enabled if enable\_output variable is true. |
