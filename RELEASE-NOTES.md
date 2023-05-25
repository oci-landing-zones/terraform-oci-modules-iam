# May 25, 2023 Release Notes - 0.1.2

## Updates
1. [Policy Module](#0-1-2-policies)
### <a name="0-1-2-policies">Policy Module</a>
- Compartments metadata (compartment type and consumer groups) must be passed as attributes (*cislz_metadata*) to *supplied_compartments* attribute. This has been done to minimize the usage of freeform tags, limited on 10 per resource. See [compartments example](./compartments/examples/vision/main.tf) for usage.

# May 15, 2023 Release Notes - 0.1.1

## Updates
1. [Policy Module](#0-1-1-policies)
### <a name="0-1-1-policies">Policy Module</a>
- Policy target compartments must be passed as a map of objects via *supplied_compartments* attribute.
- Policy examples updated, showcasing template policies and supplied policies.

# March 30, 2023 Release Notes - 0.1.0

## Added
1. [Initial Release](#0-1-0-initial)

### <a name="0-1-0-initial">Initial Release</a>
Modules for compartments, policies, groups and dynamic groups.
