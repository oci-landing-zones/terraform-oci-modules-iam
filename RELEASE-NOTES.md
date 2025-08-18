# August 18, 2025 Release Notes - 0.3.0
## Updates
1. [Compartments module](./compartments/)
    - Module now allows users to create a compartment with a tag default, that uses a tag from a tag namespace created in the same terraform run.
2. [Identity Domains module](./identity-domains/)
    - User lookup optimized. Users are now searched once for each provided identity domain and only for identity domains where the members attribute is non empty.  
3. Code formatted per Terraform standards.    
    

# April 01, 2025 Release Notes - 0.2.9
## Updates
1. [Identity Domains module](./identity-domains/)
    - Group membership updates managed through some means other than via the module can be either ignored or honored. This is enabled by new attribute *ignore_external_membership_updates* within *identity_domain_groups_configuration* variable. See it in [variables.tf](./identity-domains/variables.tf). The attribute behavior is described in [Identity Domains module README.md](./identity-domains/README.md#functioning).
    - Removed *attribute_sets = ["all"]* from *oci_identity_domains_group* resource block, as it has been observed it prevents tags from being updated. A solution for the less harmful side effect of unsolicited updates during *terraform plan* is being sought.
    - Added module default freeform tags to groups and dynamic groups.
2. [Policies module](./policies/)  
    - Moved permissions in template policies to application administrators for reading Tag namespaces, Compute images, Catalog listings and repositories to the tenancy level, even when an enclosing compartment is deployed.
    - Description of policies updated to "Core Landing Zone policy for...".


# March 25, 2025 Release Notes - 0.2.8
## Updates
1. [Identity Domains module](./identity-domains/)
    - Only ACTIVE users are looked up for group membership assignments in identity domains.


# January 10, 2025 Release Notes - 0.2.7
## Updates
1. [Groups module](./groups/)
    - Only ACTIVE users are looked up for group membership assignments.


# December 09, 2024 Release Notes - 0.2.6
## Updates
1. [Identity Domains module](./identity-domains/)
    - Added *attribute_sets = ["all"]* to *oci_identity_domains_group* resource block to avoid group memberships being updated when there are no updates to group memberships. Bug https://github.com/oracle/terraform-provider-oci/issues/1933.


# November 01, 2024 Release Notes - 0.2.5
## Updates
1. [Policies module](./policies/)
    - Added IAM policies for OCI Network Firewall and ZPR.
        - OCI Network Firewall granted manage permissions to Network admins.
        - ZPR granted manage permissions to Security admins.   


# October 07, 2024 Release Notes - 0.2.4
## Updates
1. [Identity Domains module](./identity-domains/)
    - Typo fixed in *defined_tags* and *freeform_tags* for dynamic groups.


# August 27, 2024 Release Notes - 0.2.3
## Updates
1. All modules now require Terraform binary equal or greater than 1.3.0.
2. *cislz-terraform-module* tag renamed to *ocilz-terraform-module*.


# July 24, 2024 Release Notes - 0.2.2
## New
1. [Identity Domains module](./identity-domains/)
    - Ability to define Identity Domain applications, with support for SAML applications, mobile applications, confidential applications, and the following catalog applications: Oracle Identity Domain, Generic SCIM (Client Credentials), and Oracle Fusion Applications Release 13.
## Updates    
1. Auditor policies aligned with documentation.
2. Aligned [README.md](./README.md) structure to Oracle's GitHub organizations requirements.


# April 17, 2024 Release Notes - 0.2.1
## Updates
### All Modules
1. Dependency variables are now strongly typed, enhancing usage guidance.
### Policies Module
1. FSS (File System Service) principal names fixed in realms with keys greater than 10.


# February 27, 2024 Release Notes - 0.2.0
## Updates
### Identity Domains Module
1. The Identity Domains module now supports creating SAML Identity Providers through a new configuration variable. The variable *identity_domain_identity_providers_configuration* includes parameters to manage identity providers using either a SAML metadata file or individual metadata parameter values.
### Compartments Module
1. The reserved key "TENANCY-ROOT" has been introduced. It is used for referring to the root compartment OCID. It can be assigned to *default_parent_id* and *parent_id* attributes.
### Policies Module
2. The reserved key "TENANCY-ROOT" has been introduced. It is used for referring to the root compartment OCID. It can be assigned to *compartment_id* attribute within *supplied_policies* attribute.

# January 08, 2024 Release Notes - 0.1.9
## Updates
### Policies Module
1. Policies Module can now declare dependencies on externally managed compartments. The dependencies are used to resolve compartment OCIDs within *supplied_policies* and *supplied_compartments* attributes.
2. The following attributes had their names changed. Make sure to update any existing input variables.
    - *compartment_ocid* to *compartment_id* in *supplied_policies* attribute.
    - *ocid* to *id* in *supplied_compartments* attribute.

# December 08, 2023 Release Notes - 0.1.8
## Updates
### Policies Module
1. Grants added for supporting OKE deployments with NPN (Native Pod Networking) and in a split compartment topology, where OKE networking and OKE clusters are deployed in different compartments.

# November 01, 2023 Release Notes - 0.1.7
## New
1. Identity Domains module, supporting identity domains, groups, and dynamic groups. 
2. Groups and dynamic groups can be created in existing identity domains.

## Updates
### Policies Module
1. Multiple intents can be declared for a specific compartment through *cislz-cmp-type* attribute. This configures the compartment (through the creation of necessary policy grants) to host resources that can be managed by different groups.

# October 06, 2023 Release Notes - 0.1.6

## Updates
### Compartments Module
1. The Compartments module can now declare dependency on externally managed compartments. This is useful when managing compartments with multiple configurations.
2. Attributes *default_parent_ocid* and *parent_ocid* renamed to *default_parent_id* and *parent_id*, respectively. Existing clients must adjust accordingly.

# September 27, 2023 Release Notes - 0.1.5

## Updates
1. All modules now support assigning *null* value to the top level variables or not setting them at all (as they are defaulted to null). These variables are *compartments_configuration*, *dynamic_groups_configuration*, *groups_configuration* and *policies_configuration*. This facilitates the writing of clients that orchestrate the IAM modules.

# September 04, 2023 Release Notes - 0.1.4

## Updates
1. [Policies Module](#0-1-4-policies)
2. [Compartments Module](#0-1-4-compartments)

### <a name="0-1-4-policies">Policies Module</a>
1.  Policies Module now supports group names that include spaces like: 'vision security adm group'. It's supported for tenancy and compartment level groups.  Please see [main.tf](./policies/examples/template-policies/main.tf) for an example.
2.  Policies Module now supports a list of groups for each role at tenancy and compartment levels, like : "cislz-consumer-groups-security":"vision-security-admin-group,'vision security adm group2'".  Please see [main.tf](./policies/examples/template-policies/main.tf) for an example.

### <a name="0-1-4-compartments">Compartments Module</a>
1. Compartments identifying keys can now be derived from the hierarchy provided in *compartment_configuration* definition. This allow for using the same key across different compartment subtrees, a desirable feature when defining complex compartment hierarchies with similar subtree structures. For using this feature, set *derive_keys_from_hierarchy* variable to true.
2. Compartments module can now declare dependency on externally managed tags for tag defaults.

# July 03, 2023 Release Notes - 0.1.3

## Updates
1. [Policies Module](#0-1-3-policies)

### <a name="0-1-3-policies">Policies Module</a>
1.  Policies Module now requires compartments metadata to be explicitly passed in along the compartments. Instead of reading off compartments freeform tags, the module now reads from *cislz_metadata* attribute of *supplied_compartments* attribute. This has been done to avoid customers going beyond freeform tags limit in OCI, which is 10 per resource. Note however, that you can keep tagging your compartments if you wish, but you now need to read those tags and explicitly pass them to the Policies Module. Please see [main.tf](./policies/examples/template-policies/main.tf) for an example and [Compartment Level Policies](./policies/README.md#22-compartment-level-policies) for details on *cislz_metadata* attribute.
2.  Input variable *policies_configuration* has been restructured for easier usage. A *template_policies* attribute has been introduced to clearly separate settings from *supplied_policies*.  Within *template_policies*, *tenancy_level_settings* drive Root compartment policies while *compartment_level_settings* drive non-Root compartment policies. Please see [Template Policies](./policies/README.md#2-template-policies) for details.
3.  Support for template OCI service policies introduced. These policies can be enabled all at once or on a per service basis. Please see [Tenancy Level Policies](./policies/README.md#21-tenancy-level-policies) for details.
4.  Common grants on security and network compartments have been combined into single statements, with group principals in a comma-separated list.
5.  Workload admins (Application, Database and Exainfra) have been granted manage permissions over encryption keys in their compartments, within a Vault managed by Security admin.

# June 19, 2023 Release Notes - 0.1.2

## Updates
1. [Policies Module](#0-1-2-policies)
### <a name="0-1-2-policies">Policies Module</a>
- Policy names disambiguated in the case where a single compartment has multiple values in the *cislz-cmp-type* tag.

# May 15, 2023 Release Notes - 0.1.1

## Updates
1. [Policies Module](#0-1-1-policies)
### <a name="0-1-1-policies">Policies Module</a>
1.  Policy target compartments must be passed as a map of objects via *supplied_compartments* attribute.
2.  Policy examples updated, showcasing template policies and supplied policies.

# March 30, 2023 Release Notes - 0.1.0

## Added
1. [Initial Release](#0-1-0-initial)

### <a name="0-1-0-initial">Initial Release</a>
- Modules for compartments, policies, groups and dynamic groups.
