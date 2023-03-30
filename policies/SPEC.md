## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | < 1.3.0 |

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
| <a name="input_policies_configuration"></a> [policies\_configuration](#input\_policies\_configuration) | Policies configuration | <pre>object({<br>    enable_cis_benchmark_checks = optional(bool) # Whether to check policies for CIS Foundations Benchmark recommendations. Default is true.<br>    enable_tenancy_level_template_policies = optional(bool) # Enables the module to manage template (pre-configured) policies at the root compartment) (a.k.a tenancy) level. Attribute groups_with_tenancy_level_roles only applies if this is set to true. Default is false.<br>    groups_with_tenancy_level_roles = optional(list(object({ # A list of group names and their roles at the root compartment (a.k.a tenancy) level. Pre-configured policies are assigned to each group in the root compartment. Only applicable if attribute enable_tenancy_level_template_policies is set to true.<br>      name = string<br>      roles = string<br>    })))<br>    enable_compartment_level_template_policies = optional(bool) # Enables the module to manage template (pre-configured) policies at the compartment level (compartments other than root). Default is true.<br>    cislz_tag_lookup_value = optional(string) # The tag value used for looking up compartments. This module searches for compartments that are freeform tagged with cislz = <cislz_tag_lookup_value>. The selected compartments are eligible for template (pre-configured) policies. If the lookup fails, no template policies are applied.<br>    policy_name_prefix = optional(string) # A prefix to be prepended to all policy names<br>    policy_name_suffix = optional(string) # A suffix to be appended to all policy names<br>    supplied_compartments = optional(list(object({ # List of compartments that are policy targets. This is a workaround to Terraform behavior. Please see note below.<br>      name = string<br>      ocid = string<br>      freeform_tags = map(string)<br>    })))<br>    defined_tags = optional(map(string)) # Any defined tags to apply on the template (pre-configured) policies.<br>    freeform_tags = optional(map(string)) # Any freeform tags to apply on the template (pre-configured) policies.<br>    supplied_policies = optional(map(object({ # A map of directly supplied policies. Use this to suplement the template (pre-configured) policies. For completely overriding the template policies, set attributes enable_compartment_level_template_policies and enable_tenancy_level_template_policies to false.<br>      name             = string<br>      description      = string<br>      compartment_ocid = string<br>      statements       = list(string)<br>      defined_tags     = map(string)<br>      freeform_tags    = map(string)<br>    })))<br>    enable_output = optional(bool) # Whether the module generates output. Default is false.<br>    enable_debug = optional(bool) # # Whether the module generates debug output. Default is false.<br>  })</pre> | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The tenancy OCID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_list_of_compartments_types_tagged_with_cislz_tag_lookup_value"></a> [list\_of\_compartments\_types\_tagged\_with\_cislz\_tag\_lookup\_value](#output\_list\_of\_compartments\_types\_tagged\_with\_cislz\_tag\_lookup\_value) | An internal list with compartments tagged with cislz\_tag\_lookup\_value. Used to find if an enclosing compartment is available. Enabled if enable\_debug attribute is true. |
| <a name="output_map_of_compartments_tagged_with_cislz_tag_lookup_value"></a> [map\_of\_compartments\_tagged\_with\_cislz\_tag\_lookup\_value](#output\_map\_of\_compartments\_tagged\_with\_cislz\_tag\_lookup\_value) | An internal map driving the assignment of pre-configured policies according to cislz tags. Enabled if enable\_debug attribute is true. |
| <a name="output_policies"></a> [policies](#output\_policies) | The policies. Enabled if enable\_output attribute is true. |
