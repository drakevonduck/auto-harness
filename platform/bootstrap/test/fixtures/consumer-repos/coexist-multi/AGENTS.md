# AGENTS.md — Custom project conventions

## About this codebase

This is a data-pipeline monorepo. Agents should understand that modifying any
file in `src/etl/` may affect downstream analytics.

## Review checklist

Before approving a PR, check:
- Pipeline tests pass
- Downstream schema compatibility verified
- CHANGELOG updated
