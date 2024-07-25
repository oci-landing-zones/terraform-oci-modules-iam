# OCI Landing Zones IAM Compartments Module Example - External Dependencies

This example shows how to deploy Identity and Access Management (IAM) compartments in Oracle Cloud Infrastructure (OCI) with external dependencies. 

It creates one compartment within the compartment referred by "\<REPLACE-BY-COMPARTMENT-REFERENCE\>" and applies a default value for the tag referred by "\<REPLACE-BY-TAG-REFERENCE\>". See [input.auto.tfvars.template](./input.auto.tfvars.template).

- "\<REPLACE-BY-COMPARTMENT-REFERENCE\>" compartment is expected to be found in "\<REPLACE-BY-OBJECT-NAME-FOR-COMPARTMENTS\>" object within "\<REPLACE-BY-BUCKET-NAME\>" bucket.
- "\<REPLACE-BY-TAG-REFERENCE\>" tag is expected to be found in "\<REPLACE-BY-OBJECT-NAME-FOR-TAGS\>" object within "\<REPLACE-BY-BUCKET-NAME\>" bucket.

As this example needs to read from an OCI Object Storage bucket, the following extra permissions are required for the executing user, in addition to the permissions required by the [compartments module](../..) itself.

```
allow group <group> to read objectstorage-namespaces in tenancy
allow group <group> to read buckets in compartment <bucket-compartment-name>
allow group <group> to read objects in compartment <bucket-compartment-name> where target.bucket.name = '<REPLACE-BY-BUCKET-NAME>'
```
Note: *\<bucket-compartment-name\>* is *\<REPLACE-BY-BUCKET-NAME\>*'s compartment.

## External Dependencies

The OCI Object Storage objects with external dependencies are expected to have structures like the following:
- **oci_compartments_dependency**
```
{
  "APP-CMP" : {
    "id" : "ocid1.compartment.oc1..aaaaaa...zrt"
  }
}
```
- **oci_tags_dependency**
```
{
  "COST-CENTER-TAG" : {
   "id" : "ocid1.tag.oc1.iad.aaaaaaaax...e7a"
  }
} 
```

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*, where *\<project-name\>* is any name of your choice.

2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the input variables, by making the appropriate substitutions:
   - Replace *\<REPLACE-BY-\*\>* placeholders with appropriate values. 

Refer to [compartment's module README.md](../../README.md) for overall attributes usage.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```