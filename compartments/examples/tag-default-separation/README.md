# Tag-default separation example

This example shows how to keep compartment outputs independent from tag-default lifecycle changes. The compartments module normalizes tag-default intent but does not create the resources; the sibling tag-defaults module owns them.

The example preserves the existing nested `compartments_configuration` input. It is intended for module composition validation and does not require a preliminary targeted apply.
