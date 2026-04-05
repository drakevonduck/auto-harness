# Modular Meta-Harness Platform

`platform/` is the new source-of-truth layout for the development harness framework.

## Structure

- `core/`: universal doctrine, lifecycle rules, schemas, and kernel metadata
- `profiles/`: stack, architecture, data, delivery, management, and domain overlays
- `agents/`: AI-tool operating packs and compatibility fragments
- `templates/`: reusable artifact skeletons
- `validators/`: module-driven validation entrypoints
- `compositions/`: recommended module bundles
- `examples/`: sample outputs and sample project layouts

## Operating Model

Each module declares its own:

- identity and type
- dependencies and conflicts
- required and optional artifacts
- sensitive path patterns
- companion artifact rules
- validators
- human review gates
- agent adapters
- compatibility fragments

Projects compose modules through `harness.manifest.yaml`.
