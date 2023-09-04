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
| [oci_identity_compartment.level_2](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_compartment.level_3](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_compartment.level_4](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_compartment.level_5](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_compartment.level_6](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_compartment.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_tag_default.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_default) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartments_configuration"></a> [compartments\_configuration](#input\_compartments\_configuration) | The compartments configuration. Use the compartments attribute to define your topology. OCI supports compartment hierarchies up to six levels. | <pre>object({<br>    default_parent_ocid = optional(string) # the default parent for all top (first level) compartments. Use parent_ocid attribute within each compartment to specify different parents.<br>    default_defined_tags = optional(map(string)) # applies to all compartments, unless overriden by defined_tags in a compartment object<br>    default_freeform_tags = optional(map(string)) # applies to all compartments, unless overriden by freeform_tags in a compartment object<br>    enable_delete = optional(bool) # whether or not compartments are physically deleted when destroyed. Default is false.<br>    compartments = map(object({<br>      name          = string<br>      description   = string<br>      parent_ocid   = optional(string)<br>      defined_tags  = optional(map(string))<br>      freeform_tags = optional(map(string))<br>      tag_defaults     = optional(map(object({<br>        tag_id = string,<br>        default_value = string,<br>        is_user_required = optional(bool)<br>      })))<br>      children      = optional(map(object({<br>        name          = string<br>        description   = string<br>        defined_tags  = optional(map(string))<br>        freeform_tags = optional(map(string))<br>        tag_defaults     = optional(map(object({<br>            tag_id = string,<br>            default_value = string,<br>            is_user_required = optional(bool)<br>          })))<br>        children      = optional(map(object({<br>          name          = string<br>          description   = string<br>          defined_tags  = optional(map(string))<br>          freeform_tags = optional(map(string))<br>          tag_defaults     = optional(map(object({<br>            tag_id = string,<br>            default_value = string,<br>            is_user_required = optional(bool)<br>          })))<br>          children      = optional(map(object({<br>            name          = string<br>            description   = string<br>            defined_tags  = optional(map(string))<br>            freeform_tags = optional(map(string))<br>            tag_defaults     = optional(map(object({<br>              tag_id = string,<br>              default_value = string,<br>              is_user_required = optional(bool)<br>            })))<br>            children      = optional(map(object({<br>              name          = string<br>              description   = string<br>              defined_tags  = optional(map(string))<br>              freeform_tags = optional(map(string))<br>              tag_defaults     = optional(map(object({<br>                tag_id = string,<br>                default_value = string,<br>                is_user_required = optional(bool)<br>              })))<br>              children      = optional(map(object({<br>                name          = string<br>                description   = string<br>                defined_tags  = optional(map(string))<br>                freeform_tags = optional(map(string))<br>                tag_defaults     = optional(map(object({<br>                  tag_id = string,<br>                  default_value = string,<br>                  is_user_required = optional(bool)<br>                })))<br>              })))  <br>            })))<br>          })))<br>        })))<br>      })))  <br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_derive_keys_from_hierarchy"></a> [derive\_keys\_from\_hierarchy](#input\_derive\_keys\_from\_hierarchy) | Whether identifying keys should be derived from the provided compartments hierarchy | `bool` | `false` | no |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | The module name. | `string` | `"iam-compartments"` | no |
| <a name="input_tags_dependency"></a> [tags\_dependency](#input\_tags\_dependency) | A map of objects containing the externally managed tags this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute (representing the tag OCID) of string type. | `map(any)` | `null` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The OCID of the tenancy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compartments"></a> [compartments](#output\_compartments) | The compartments in a single flat map. |
| <a name="output_tag_defaults"></a> [tag\_defaults](#output\_tag\_defaults) | The tag defaults. |
