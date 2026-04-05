# Lifecycle Controls

The kernel distinguishes baseline harness states from project-specific overlays.

## Bootstrap Complete

Bootstrap is complete when:

- the active manifest validates
- all selected modules resolve without dependency or conflict errors
- placeholder scanning passes
- required compatibility entrypoints exist
- required artifact templates have been instantiated or explicitly waived

## Harness Ready

Harness readiness requires bootstrap completeness plus:

- ownership and review gates are active
- validator set is wired into CI or an equivalent local gate
- operational readiness artifacts required by active delivery modules exist
- at least one human reviewer besides the bootstrapper has reviewed the harness

Delivery overlays may add stricter readiness states.
