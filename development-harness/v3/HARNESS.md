# Development Harness v3
## AI-Assisted Software Delivery — Governance-First Operating Model

> **Default stack:** Node.js / TypeScript (see `profiles/node-typescript.md`).
> A Python overlay is provided in `profiles/python.md`.
> If you are using a different stack, create a new profile before proceeding.

---

## A. v3 Overview

v3 is a hardening pass on v2. It does not change the governance philosophy — it closes the distance between the policy and what actually runs.

The main problems fixed:
- Every file referenced here exists in this package
- Placeholders have a convention and a validation script
- "Bootstrap Complete" and "Harness Ready" are defined separately and concretely
- Trust tiers are defined once and used consistently across all agent-facing documents
- Sensitive-change companions are specific enough to be reviewable, not just checkable
- Migrations are treated as operational events, not code diffs
- Canonical and derivative records are explicitly distinguished
- The default stack is honest about being Node/TypeScript-first

---

## B. Repository Layout

Every path listed here has a corresponding file in this package or is created during bootstrap.

```
project-root/
│
├── HARNESS.md                              # This document
├── AGENTS.md                               # Cross-agent operating rules (all AI tools)
├── CLAUDE.md                               # Claude Code-specific instructions only
├── CHANGELOG.md                            # Release notes (canonical record)
├── CODEOWNERS -> .github/CODEOWNERS        # Ownership enforcement
│
├── .github/
│   ├── CODEOWNERS
│   ├── pull_request_template.md
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug.md
│   │   └── incident.md
│   └── workflows/
│       ├── harness.yml                     # Placeholder + doc-companion checks
│       └── stack.yml                       # Stack-specific lint/test/build
│
├── .claude/
│   ├── settings.json                       # Committed: hook wiring, permissions
│   └── hooks/
│       └── log-command.sh                  # PostToolUse: logs all bash commands
│
├── .env.example                            # Required keys, no values — committed
├── .gitignore
│
├── docs/
│   ├── operating-principles.md             # Durable engineering doctrine
│   ├── dev-journal.md                      # Derivative narrative — NOT canonical
│   │
│   ├── adr/
│   │   ├── ADR-TEMPLATE.md
│   │   └── ADR-0001-[first-decision].md    # Created during bootstrap
│   │
│   ├── architecture/
│   │   └── overview.md
│   │
│   ├── contributing/
│   │   ├── developer-workflow.md
│   │   └── getting-started.md
│   │
│   ├── database/
│   │   ├── migration-readiness.md          # Checklist template — copy per migration
│   │   └── migration-records/              # One markdown file per applied migration
│   │       └── .gitkeep
│   │
│   ├── ops/
│   │   ├── runbook-index.md
│   │   ├── release-checklist.md
│   │   ├── rollback-checklist.md
│   │   ├── environment-inventory.md
│   │   └── ownership-map.md
│   │
│   ├── product/
│   │   └── PRD-TEMPLATE.md
│   │
│   └── security/
│       ├── incident-template.md
│       └── risk-register.md
│
├── profiles/
│   ├── node-typescript.md                  # Default overlay (active)
│   └── python.md                           # Second overlay example
│
└── scripts/
    ├── validate-placeholders.sh            # Fails if [[PLACEHOLDER]] found
    └── check-doc-companions.sh             # Fails if sensitive paths lack companions
```

---

## C. Trust Tier Model

All agent actions — regardless of which agent — fall into one of six tiers. Tiers are defined once here and referenced in `AGENTS.md` and `CLAUDE.md`.

| Tier | Name | Permitted Actions |
|------|------|-------------------|
| 0 | Read-only inspection | Read files, list dirs, search, grep, view git status/log |
| 1 | Local analysis | Run builds, tests, linters locally; read output |
| 2 | Workspace mutation | Edit files, create docs, scaffold new files, create branches |
| 3 | Git-writing | Commits, pushes to feature branches (not main/release/staging) |
| 4 | Environment-altering | Env var changes, local DB migrations, config updates |
| 5 | Remote / production | Deploy, production migration, remote infra, service secrets |

**Default permitted tier for all agents: 3**

- Tier 4 requires explicit human direction before each action. Not delegatable.
- Tier 5 requires explicit human direction **plus** a second human sign-off. Never autonomous.
- An agent may always drop to a lower tier.
- An agent must never self-elevate to a higher tier.

Stop conditions that apply regardless of tier are defined in `AGENTS.md`.

---

## D. Placeholder Convention

All unresolved scaffold values use double-bracket format in SCREAMING_SNAKE_CASE:

```
[[PLACEHOLDER_NAME]]
```

Examples used in this package:
- `[[PROJECT_NAME]]` — npm package name or repo slug
- `[[APP_TITLE]]` — human-readable app name
- `[[OWNER_GITHUB_HANDLE]]` — primary GitHub owner handle
- `[[PACKAGE_MANAGER]]` — npm, pnpm, yarn, or pip
- `[[PRODUCTION_URL]]` — production domain
- `[[STAGING_URL]]` — staging domain
- `[[TECH_STACK_PROFILE]]` — node-typescript or python

The `scripts/validate-placeholders.sh` script scans all tracked files for any `[[...]]` pattern and fails with a list of findings if any remain.

**Exceptions:** The script excludes:
- `HARNESS.md` itself (defines the convention)
- `profiles/` directory (uses placeholders as documentation examples)
- Files explicitly listed in `.placeholder-ignore`

Bootstrap is not complete until `validate-placeholders.sh` exits 0.

---

## E. Definitions

### Bootstrap Complete

All of the following must be true:

- [ ] Required files created (matches repo layout in §B)
- [ ] All `[[PLACEHOLDER]]` values resolved
- [ ] `scripts/validate-placeholders.sh` exits 0
- [ ] Stack profile selected and noted in `CLAUDE.md` (§ Active Stack Profile)
- [ ] `.env.example` populated with all required key names
- [ ] `.gitignore` covers `.env`, `.env.local`, secrets, build artifacts

### Harness Ready

All Bootstrap Complete items, plus:

- [ ] `.github/CODEOWNERS` is valid and covers all sensitive paths in §F
- [ ] `harness.yml` CI workflow is active and passing on the default branch
- [ ] `docs/ops/environment-inventory.md` has at least one real environment entry
- [ ] `docs/ops/ownership-map.md` has at least one real owner per domain
- [ ] At least one ADR exists for the most significant early architectural decision
- [ ] PR template is in place and has been used at least once
- [ ] At least one team member other than the bootstrapper has reviewed the harness

### Canonical Records

These are authoritative. They are not summaries — they are the source of truth.

| Record type | Location |
|-------------|----------|
| Architecture decisions | `docs/adr/ADR-NNNN-*.md` |
| Feature requirements | `docs/product/PRD-NNN-*.md` |
| Significant changes | GitHub PRs and issues |
| Release notes | `CHANGELOG.md` |
| Migration records | `docs/database/migration-records/YYYYMMDD-*.md` |
| Incidents | `docs/security/` incident instances |
| Risk register | `docs/security/risk-register.md` |
| Runbooks | `docs/ops/` (indexed in `runbook-index.md`) |

### Derivative Records

These narrate or summarize, but are not authoritative.

| Record | Notes |
|--------|-------|
| `docs/dev-journal.md` | Useful narrative context; not a substitute for ADRs or PRs |
| Agent session logs | Debugging aid only |
| Commit messages (squash workflows) | Not reliable as narrative — see below |

**Why git history is not a canonical narrative:** In squash-merge and rebase-heavy workflows, individual commits are routinely rewritten, dropped, or collapsed before merge. The commit hash on main does not tell you why a decision was made, what was rejected, or who approved it. PRs, ADRs, and issues survive that rewriting. Raw commit messages do not.

---

## F. Sensitive-Change Companion Model

These path-based rules are enforced by `scripts/check-doc-companions.sh` in CI.

A companion must contain substantive changes. A whitespace-only edit or date bump is not a valid companion. Reviewers must verify.

| Change type | Sensitive paths | Required companion |
|-------------|-----------------|-------------------|
| Auth / security logic | `src/auth/**`, `src/middleware/**`, `**/session*` | Updated `risk-register.md` entry **or** new ADR if architectural |
| Database migrations | `migrations/**`, `supabase/migrations/**`, `alembic/**` | Completed `migration-readiness.md` checklist instance in PR body or linked file |
| Infra / deploy changes | `vercel.json`, `Dockerfile`, `.github/workflows/**`, `terraform/**` | Updated `environment-inventory.md` if topology changes |
| New environment keys | `.env.example` | PR description must list each new key and its purpose |
| Major dependency changes | `package.json` (major version bumps), `requirements.txt` (new transitive dep with security implications) | New or updated ADR if the dependency affects architecture |
| New service boundary | `src/services/**` (new service), new external API integration | New section in `architecture/overview.md` + ADR |
| CODEOWNERS changes | `.github/CODEOWNERS` | Requires review from at least one existing listed owner |

---

## G. Migration Discipline

Migrations are operational events. Do not bury them in feature PRs.

Every schema migration requires:

1. **Isolation** — migration lives in its own PR or clearly isolated commit set, not mixed with feature code
2. **Readiness checklist** — completed instance of `docs/database/migration-readiness.md`
3. **Rollback statement** — either a down migration, or an explicit "forward-only" justification
4. **Pre-migration snapshot** — backup or snapshot confirmed before destructive changes
5. **Post-apply verification** — specific checks run after apply, documented in the migration record
6. **Migration record** — created in `docs/database/migration-records/YYYYMMDD-description.md` after apply

Migrations are never applied automatically by CI without explicit human direction.

---

## H. v2 → v3 Upgrade Summary

| Problem in v2 | v3 fix |
|---------------|--------|
| Referenced files that didn't exist | All referenced files included in this package |
| No placeholder validation | `[[PLACEHOLDER]]` convention + `validate-placeholders.sh` |
| Claimed stack-agnostic but defaulted to JS everywhere | Default profile labeled as Node/TS; `profiles/` directory separates overlays |
| Trust tiers introduced but inconsistent across docs | Defined once in §C, referenced in AGENTS.md and CLAUDE.md |
| Sensitive-change companion easy to fake | Companions are specific; reviewer verification explicitly required in CI and PR template |
| Migration support was partly ceremonial | Readiness checklist + migration-records/ + post-apply requirements |
| Bootstrap Complete undefined | Defined separately from Harness Ready with concrete checklists |
| Canonical and derivative records muddled | Explicit tables defining each |
| Dev journal implied as canonical | Labeled as derivative only, in multiple places |
| Agent command permissions too broad | Tier 4/5 require human direction; tier 5 requires second sign-off |
| Security section was a checklist | Full companion model with path-based CI enforcement |
