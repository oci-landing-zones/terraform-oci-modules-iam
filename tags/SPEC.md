## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_identity_tag.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag) | resource |
| [oci_identity_tag_default.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_default) | resource |
| [oci_identity_tag_namespace.these](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_tag_namespace) | resource |
| [oci_identity_tag.default_created_by](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tag) | data source |
| [oci_identity_tag.default_created_on](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tag) | data source |
| [oci_identity_tag_namespaces.oracle_default](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_tag_namespaces) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cislz_created_by_tag_name"></a> [cislz\_created\_by\_tag\_name](#input\_cislz\_created\_by\_tag\_name) | A user provided name for the tag to identify resource creators. Only applicable if Only applicable if *enable\_cislz\_namespace* is true and tenancy is not pre-configured with OCI tag defined by *oracle\_default\_created\_by\_tag\_name*. | `string` | `null` | no |
| <a name="input_cislz_created_on_tag_name"></a> [cislz\_created\_on\_tag\_name](#input\_cislz\_created\_on\_tag\_name) | A user provided name for the tag to identify when resources are created. Only applicable if Only applicable if *enable\_cislz\_namespace* is true and tenancy is not pre-configured with OCI tag defined by *oracle\_default\_created\_on\_tag\_name*. | `string` | `null` | no |
| <a name="input_cislz_defined_tags"></a> [cislz\_defined\_tags](#input\_cislz\_defined\_tags) | Any defined tags to apply on the default namespace and tags (those prefixed with cislz\_). | `map(string)` | `null` | no |
| <a name="input_cislz_freeform_tags"></a> [cislz\_freeform\_tags](#input\_cislz\_freeform\_tags) | Any freeform tags to apply on the default namespace and tags (those prefixed with cislz\_). | `map(string)` | `null` | no |
| <a name="input_cislz_namespace_compartment_id"></a> [cislz\_namespace\_compartment\_id](#input\_cislz\_namespace\_compartment\_id) | The compartment ocid where to create a default tag namespace. Only applicable if *enable\_cislz\_namespace* is true and tenancy is not pre-configured with OCI tag namespace defined by *oracle\_default\_namespace\_name*. | `string` | n/a | yes |
| <a name="input_cislz_namespace_name"></a> [cislz\_namespace\_name](#input\_cislz\_namespace\_name) | A user provided name for the default namespace. Only applicable if Only applicable if *enable\_cislz\_namespace* is true and tenancy is not pre-configured with OCI tag namespace defined by *oracle\_default\_namespace\_name*. | `string` | `null` | no |
| <a name="input_cislz_tag_name_prefix"></a> [cislz\_tag\_name\_prefix](#input\_cislz\_tag\_name\_prefix) | A string used as a prefix for resource naming. | `string` | `"cislz"` | no |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | A map of user defined tags, made of tag namespaces, and tags themselves along with optional tag defaults. | <pre>map(object({<br>    compartment_id        = string,<br>    namespace_name        = string,<br>    namespace_description = string,<br>    is_namespace_retired  = bool,<br>    defined_tags          = map(string),<br>    freeform_tags         = map(string)<br>    tags = map(object({<br>      name = string,<br>      description = string,<br>      is_cost_tracking = bool,<br>      is_retired = bool,<br>      valid_values = list(string),<br>      apply_default_to_compartments = list(string),<br>      default_value = string,<br>      is_default_required = bool,<br>      defined_tags  = map(string),<br>      freeform_tags = map(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_enable_cislz_namespace"></a> [enable\_cislz\_namespace](#input\_enable\_cislz\_namespace) | Whether the default namespace required by CIS OCI Benchmark is enabled. | `bool` | `true` | no |
| <a name="input_oracle_default_created_by_tag_name"></a> [oracle\_default\_created\_by\_tag\_name](#input\_oracle\_default\_created\_by\_tag\_name) | OCI's pre-configured tag name for identifying resource creators. | `string` | `"CreatedBy"` | no |
| <a name="input_oracle_default_created_on_tag_name"></a> [oracle\_default\_created\_on\_tag\_name](#input\_oracle\_default\_created\_on\_tag\_name) | OCI's pre-configured tag name for identifying when resources are created. | `string` | `"CreatedOn"` | no |
| <a name="input_oracle_default_namespace_name"></a> [oracle\_default\_namespace\_name](#input\_oracle\_default\_namespace\_name) | OCI's pre-configured tag namespace. | `string` | `"Oracle-Tags"` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | The tenancy ocid, used to search on tag namespaces. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tag_namespaces"></a> [tag\_namespaces](#output\_tag\_namespaces) | The tag namespaces. |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags. |
