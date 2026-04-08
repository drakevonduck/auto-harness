# Development Harness

A modular governance framework for AI-assisted software development.

**Version:** Alpha (April 2026)
**Audience:** Developers, tech leads, and AI agents working with governed codebases
**License:** Apache-2.0

---

## What Is This?

The development harness gives AI coding agents (Claude Code, Cursor, GitHub Copilot, and
others) a structured operating contract. It defines what agents can do, what artifacts must
exist, when human review is required, and what documentation must accompany every
significant change.

You declare which modules are active in a `harness.manifest.yaml`. The harness provides
trust tiers, companion rules, artifact requirements, sensitive path governance, and a
validator chain that enforces all of the above locally and in CI.

For the full introduction, see the [top-level README](../README.md).

---

## Quick Start

| Starting point | Guide |
| -------------- | ----- |
| Raw idea, no stack chosen | [Discovery to Composition](workflow/discovery-to-composition.md) |
| Know your stack, ready to build | [Bootstrap Quickstart](workflow/bootstrap-quickstart.md) |
| Web3 project | [Web3 Bootstrap Quickstart](workflow/bootstrap-web3-quickstart.md) |
| Existing codebase, not built with the harness | [Brownfield Onboarding](workflow/brownfield-onboarding.md) |

**Intake questionnaire:** [templates/discovery/intake-questionnaire.md](templates/discovery/intake-questionnaire.md)
— an 8-section instrument usable with clients, stakeholders, or as a self-interview.

**Starter compositions:** [compositions/](compositions/) — copy the closest match to
`harness.manifest.yaml` and adjust.

---

## How to Read This Documentation

This platform is organized as a GitBook. The full table of contents is in
[SUMMARY.md](SUMMARY.md).

**Recommended reading order for new users:**

1. This page (you're here)
2. [Bootstrap Quickstart](workflow/bootstrap-quickstart.md) or [Brownfield Onboarding](workflow/brownfield-onboarding.md) depending on your situation
3. [Trust Model](core/kernel/base/trust-model.md) — the six tiers that govern agent behavior
4. [Doctrine](core/kernel/base/doctrine.md) — the design principles behind the harness
5. [Skills and Agents](workflow/skills-and-agents.md) — how the harness integrates with AI tools
6. [Validators Overview](validators/README.md) — the enforcement chain

For projects using the harness that want GitBook navigation for their own docs, activate
the `domains/gitbook` module.

---

## Platform Structure

```text
platform/
├── core/           # Kernel doctrine, trust model, lifecycle controls, schemas
├── profiles/       # Stack, architecture, data, delivery, management, domain overlays
├── agents/         # AI-tool operating packs: base, claude-code, generic-llm
├── skills/         # Agent Skills: harness-governance, harness-testing, harness-web3, harness-onboarding
├── templates/      # Artifact skeletons — see templates/README.md for placeholder reference
├── validators/     # Validator scripts, shared Ruby library, test suite, fixtures
├── compositions/   # Starter manifests for common project types
├── examples/       # Sample project with all artifacts filled in
└── workflow/       # Guides: bootstrap, discovery, brownfield, CI, troubleshooting
```

---

## Operating Model

Each module (`module.yaml`) declares its own governance contract:

- identity, type, version, dependencies, conflicts
- required and optional artifacts
- sensitive path patterns and companion artifact rules
- validator IDs and human review gates
- agent adapter paths and compiled fragments
- recommended skills (Agent Skills format + OpenClaw/ClawHub)

Projects compose modules through `harness.manifest.yaml`. The validator chain enforces
the contract at development time and in CI.
