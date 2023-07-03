# June 28, 2023 Release Notes - 0.1.3

## Updates
1. [Policy Module](#0-1-3-policies)

### <a name="0-1-3-policies">Policy Module</a>
1.  Policy module now requires compartments metadata to be explicitly passed in along the compartments. Instead of reading off compartments freeform tags, the module now reads from *cislz_metadata* attribute of *supplied_compartments* attribute. This has been done to avoid customers going beyond freeform tags limit in OCI, wich is 10 per resource. Note however, that you can keep tagging your compartments if you wish, but you now need to read those tags and explicitly pass them to the policy module. Please see [main.tf](./policies/examples/template-policies/main.tf) for an example and [Compartment Level Policies](./policies/README.md#22-compartment-level-policies) for details on *cislz_metadata* attribute.
2.  Input variable *policies_configuration* has been restructured for easier usage. A *template_policies* attribute has been introduced to clearly separate settings from *supplied_policies*.  Within *template_policies*, *tenancy_level_settings* drive Root compartment policies while *compartment_level_settings* drive non-Root compartment policies. Please see [Template Policies](./policies/README.md#2-template-policies) for details.
3.  Support for template OCI service policies introduced. These policies can be enabled all at once or on a per service basis. Please see [Tenancy Level Policies](./policies/README.md#21-tenancy-level-policies) for details.
4.  Common grants on security and network compartments have been combined into single statements, with group principals in a comma-separated list.
5.  Workload admins (Application, Database and Exainfra) have been granted manage permissions over encryption keys in their compartments, within a Vault managed by Security admin.

# June 19, 2023 Release Notes - 0.1.2

## Updates
1. [Policy Module](#0-1-2-policies)
### <a name="0-1-2-policies">Policy Module</a>
- Policy names disambiguated in the case where a single compartment has multiple values in the *cislz-cmp-type* tag.

# May 15, 2023 Release Notes - 0.1.1

## Updates
1. [Policy Module](#0-1-1-policies)
### <a name="0-1-1-policies">Policy Module</a>
1.  Policy target compartments must be passed as a map of objects via *supplied_compartments* attribute.
2.  Policy examples updated, showcasing template policies and supplied policies.

# March 30, 2023 Release Notes - 0.1.0

## Added
1. [Initial Release](#0-1-0-initial)

### <a name="0-1-0-initial">Initial Release</a>
- Modules for compartments, policies, groups and dynamic groups.
