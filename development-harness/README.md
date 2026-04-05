# Development Harness

This repository now contains two parallel forms of the harness:

- `legacy/v3/`: the frozen v3 package, preserved as the baseline governance-first harness.
- `platform/`: the modular meta-harness framework, which is now the source of truth for future evolution.

The modular platform separates:

- universal kernel doctrine
- stack overlays
- architecture overlays
- data overlays
- delivery overlays
- management overlays
- agent operating packs
- reusable templates
- module-driven validators

The current implementation is intentionally `manifest + validator` first. It does not try to fully generate repo-facing outputs yet. Compatibility entrypoints are provided as maintained shims under `platform/examples/composed-entrypoints/`.
