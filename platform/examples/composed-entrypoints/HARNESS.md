# HARNESS.md
## Compatibility Shim For The Modular Harness

This file represents the repo-facing compatibility entrypoint that older harness consumers expect.

The source of truth now lives in the modular platform:

- `platform/core/kernel/base/*.md`
- active module metadata in `platform/profiles/**/module.yaml`
- active agent packs in `platform/agents/**/module.yaml`

Use `harness.manifest.yaml` to declare which modules are active. The current implementation keeps this document as a maintained compatibility layer instead of a generated output.
