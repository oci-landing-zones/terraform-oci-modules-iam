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
| [oci_identity_policy.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_region_subscriptions.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_region_subscriptions) | data source |
| [oci_identity_tenancy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tenancy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartments_dependency"></a> [compartments\_dependency](#input\_compartments\_dependency) | A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the compartment OCID) of string type. | <pre>map(object({<br>    id = string<br>  }))</pre> | `null` | no |
| <a name="input_enable_debug"></a> [enable\_debug](#input\_enable\_debug) | Whether Terraform should enable module debug information. | `bool` | `false` | no |
| <a name="input_enable_output"></a> [enable\_output](#input\_enable\_output) | Whether Terraform should enable module output. | `bool` | `true` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"iam-policies"` | no |
| <a name="input_policies_configuration"></a> [policies\_configuration](#input\_policies\_configuration) | Policies configuration | <pre>object({<br>    enable_cis_benchmark_checks = optional(bool) # Whether to check policies for CIS Foundations Benchmark recommendations. Default is true.<br>    supplied_policies = optional(map(object({ # A map of directly supplied policies. Use this to suplement or override the template policies.<br>      name             = string<br>      description      = string<br>      compartment_id   = string<br>      statements       = list(string)<br>      defined_tags     = optional(map(string))<br>      freeform_tags    = optional(map(string))<br>    })))<br>    template_policies = optional(object({ # An object describing the template policies. In this mode, policies are derived according to tenancy_level_settings and compartment_level_settings.<br>      tenancy_level_settings = optional(object({ # Settings for tenancy level (Root compartment) policies generation.<br>        groups_with_tenancy_level_roles = optional(list(object({ # A list of group names and their roles at the tenancy level. Template policies are granted to each group in the Root compartment.<br>          name = string<br>          roles = string<br>        })))<br>        oci_services = optional(object({<br>          enable_all_policies = optional(bool)<br>          enable_scanning_policies = optional(bool)<br>          enable_cloud_guard_policies = optional(bool)<br>          enable_os_management_policies = optional(bool)<br>          enable_block_storage_policies = optional(bool)<br>          enable_file_storage_policies = optional(bool)<br>          enable_oke_policies = optional(bool)<br>          enable_streaming_policies = optional(bool)<br>          enable_object_storage_policies = optional(bool)<br>        }))<br>        policy_name_prefix = optional(string) # A prefix to Root compartment policy names.<br>      }))<br>      compartment_level_settings = optional(object({ # Settings for compartment (non Root) level policies generation.<br>        supplied_compartments = optional(map(object({ # List of compartments that are policy targets.<br>          name = string # The compartment name<br>          id   = string # The compartment id<br>          cislz_metadata = map(string) # The compartment metadata. See module README.md for details.<br>        })))<br>        #policy_name_prefix = optional(string) # A prefix to compartment policy names.<br>      }))<br>    }))<br>    policy_name_prefix = optional(string) # A prefix to all policy names.<br>    policy_name_suffix = optional(string) # A suffix to all policy names.<br>    defined_tags = optional(map(string)) # Any defined tags to apply on the template (pre-configured) policies.<br>    freeform_tags = optional(map(string)) # Any freeform tags to apply on the template (pre-configured) policies.<br>  })</pre> | `null` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The tenancy OCID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policies"></a> [policies](#output\_policies) | The policies. Enabled if enable\_output attribute is true. |
| <a name="output_template_target_compartments"></a> [template\_target\_compartments](#output\_template\_target\_compartments) | An internal map driving the assignment of template policies according to compartment metadata. Enabled if enable\_debug attribute is true. |
