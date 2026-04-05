# Operating Principles
## Engineering Doctrine — Development Harness v3

These principles are durable. They are not agent-specific and not tied to any stack.
They reflect how this team works and why. Update them only through the ADR process.

---

## 1. Code Ownership

Every meaningful piece of the system has a named owner. Ownership means:

- You are the first reviewer for changes in your domain
- You are the person who understands the history and tradeoffs in your area
- You are responsible for keeping `docs/ops/ownership-map.md` accurate for your domain

Ownership does not mean gatekeeping. It means accountability.

When making changes outside your domain, notify the domain owner before merging —
not after.

---

## 2. Review Culture

Code review is not a bureaucratic checkpoint. It is the primary mechanism for
distributing knowledge across the team.

What reviewers are responsible for:
- Understanding the change, not just approving it
- Verifying that companion artifacts are substantive (not whitespace-only)
- Flagging scope creep or missing documentation
- Catching security and migration risks that CI cannot catch

What reviewers are not responsible for:
- Nitpicking style that the linter should catch
- Approving changes they do not understand

When a reviewer does not understand a change well enough to approve it, they say so.
"LGTM" on a change the reviewer did not understand is a governance failure.

---

## 3. Branch and Merge Strategy

- **main** — production-ready at all times. Protected branch. No direct pushes.
- **staging** — integration environment. Protected. Merges from feature branches.
- **feature/*** — short-lived feature branches. Branch from main or staging.
- **fix/*** — bug fix branches.
- **chore/*** — maintenance, dependency updates, documentation.

Prefer squash merges for small PRs. Prefer merge commits for PRs with meaningful
commit history that should be preserved.

Do not keep long-lived feature branches. If a branch lives more than two weeks, it is
accumulating drift that will make merging painful.

---

## 4. Test Expectations

Tests are part of the feature, not an afterthought.

- New features require tests that cover the behavior, not just the happy path
- Bug fixes require a regression test that would have caught the bug
- Refactors must not decrease coverage
- Tests that mock everything and never touch real behavior are worse than no tests

Specific expectations by stack are defined in `profiles/`.

---

## 5. Documentation as Part of the Work

Documentation is not a separate task done after the code is complete.

The following are not optional:
- ADRs for significant architectural or platform decisions
- Updated `architecture/overview.md` when system topology changes
- Updated `risk-register.md` when security posture changes
- Completed `migration-readiness.md` when a migration is applied
- Updated `.env.example` when new environment variables are introduced

A PR that changes behavior without updating relevant docs is incomplete.
CI enforces the path-based rules. Human review enforces the rest.

---

## 6. Security Posture

Security is not a compliance layer. It is an engineering concern.

Rules that are not negotiable:
- Secrets never appear in tracked files, commit messages, or log output
- `.env`, `.env.local`, and credential files are always in `.gitignore`
- `.env.example` commits only key names — never values
- Dependencies with known high-severity vulnerabilities are not merged without a mitigation plan
- New auth or session logic is reviewed by the security domain owner before merge
- External API integrations are documented in `architecture/overview.md` before shipping

When a security incident or near-miss occurs, the incident template in
`docs/security/incident-template.md` is used, and the risk register is updated.

---

## 7. Migration as an Operational Event

Database migrations are not just code changes. They have operational consequences.

Rules that apply to all migrations:
- Migrations are reviewed in isolation — not buried in feature PRs
- A completed migration readiness checklist is required before applying
- Rollback strategy must be stated explicitly
- Dangerous migrations (dropping columns, removing constraints, truncating tables)
  require a pre-migration snapshot regardless of environment
- Post-apply verification is required and documented

These rules apply in all environments, including local. The stakes differ, but the
discipline does not.

---

## 8. Ops Seriousness

Production is real. Running systems affect real people.

What this means in practice:
- The runbook index is kept current — if a runbook doesn't exist, it gets written
- Release checklists are run before every production deployment, not skipped under pressure
- Incidents produce postmortems — not blame sessions, but honest system analysis
- The rollback checklist exists and someone on every deploy knows where it is
- Environment inventory is kept accurate — "I think staging has that config" is not good enough

Cutting corners on ops debt is a trade. Acknowledge the trade; do not pretend it didn't happen.

---

## 9. Honest Limitations

This harness does not solve everything.

Things this harness cannot enforce without team commitment:
- Whether ADRs actually represent the real decision that was made
- Whether migration records are accurate after the fact
- Whether "LGTM" approvals represent genuine review
- Whether companion artifacts are substantive or just changed to pass CI

Process theater — going through the motions without the substance — is worse than no
process, because it creates false confidence. If the team is not ready to use a part of
this harness seriously, it is better to remove that part than to keep it as decoration.

---

## 10. Canonical Records

See `HARNESS.md §E` for the full definition.

The short version: if it is not in a canonical record, it did not officially happen.
Tribal knowledge, Slack history, and verbal agreements are not canonical.
