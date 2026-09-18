# Upgrade Guide

## Upcoming 0.4.0

### Identity Domains group requestability

The default value of `identity_domain_groups_configuration.groups[*].requestable` changes from `true` to `false`.

- Set `requestable = true` explicitly for groups that must remain available in the Identity Domains self-service catalog.
- Omitted and explicitly null values now resolve to `false`.
- Existing group memberships and IAM policies are not removed or changed.
- Existing groups managed with `ignore_external_membership_updates = false` and an omitted or null `requestable` value can be updated to `false` on the next apply.
- Groups managed with `ignore_external_membership_updates = true` use `ignore_changes = all`; upgrading the module alone does not update their existing remote `requestable` value. Review and remediate those groups separately through an approved OCI administration process.

See [issue #50](https://github.com/oci-landing-zones/terraform-oci-modules-iam/issues/50).
