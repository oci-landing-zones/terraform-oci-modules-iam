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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compartments"></a> [compartments](#input\_compartments) | The compartments topology, given as a map of objects nested up to six levels. | <pre>map(object({<br>    name          = string<br>    description   = string<br>    parent_ocid   = string<br>    defined_tags  = optional(map(string))<br>    freeform_tags = optional(map(string))<br>    children      = optional(map(object({<br>      name          = string<br>      description   = string<br>      defined_tags  = optional(map(string))<br>      freeform_tags = optional(map(string))<br>      children      = optional(map(object({<br>        name          = string<br>        description   = string<br>        defined_tags  = optional(map(string))<br>        freeform_tags = optional(map(string))<br>        children      = optional(map(object({<br>          name          = string<br>          description   = string<br>          defined_tags  = optional(map(string))<br>          freeform_tags = optional(map(string))<br>          children      = optional(map(object({<br>            name          = string<br>            description   = string<br>            defined_tags  = optional(map(string))<br>            freeform_tags = optional(map(string))<br>            children      = optional(map(object({<br>              name          = string<br>              description   = string<br>              defined_tags  = optional(map(string))<br>              freeform_tags = optional(map(string))<br>            })))  <br>          })))<br>        })))<br>      })))<br>    })))  <br>  }))</pre> | `{}` | no |
| <a name="input_enable_compartments_delete"></a> [enable\_compartments\_delete](#input\_enable\_compartments\_delete) | Whether compartments are physically deleted upon destroy. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_compartments"></a> [compartments](#output\_compartments) | The compartments in a single flat map. |
