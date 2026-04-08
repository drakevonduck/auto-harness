# CLAUDE.md
## Compatibility Shim For Claude Code

Claude-specific behavior should be assembled from:

- `platform/agents/base/module.yaml`
- `platform/agents/claude-code/module.yaml`
- active stack overlays that affect command permissions

This shim exists so current harness users still have a familiar entrypoint while composition stays module-driven.
