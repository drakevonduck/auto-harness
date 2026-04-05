# Ownership Map

Maps product and engineering domains to responsible owners.
Used by agents and humans to determine who to notify before cross-domain changes.

**Last updated:** `[[DATE]]`

Cross-reference with `.github/CODEOWNERS` for file-level enforcement.
This file captures intent and context; CODEOWNERS handles the CI gate.

---

## Domain Owners

| Domain | Description | Primary Owner | Secondary Owner | Sensitive? |
|--------|-------------|---------------|-----------------|------------|
| Auth & Session | Login, tokens, session management | `[[OWNER_GITHUB_HANDLE]]` | — | Yes |
| Database / Migrations | Schema, migrations, RLS policies | `[[OWNER_GITHUB_HANDLE]]` | — | Yes |
| API / Backend | Server routes, business logic | `[[OWNER_GITHUB_HANDLE]]` | — | No |
| Frontend | UI components, routing, state | `[[OWNER_GITHUB_HANDLE]]` | — | No |
| Infrastructure | CI/CD, hosting, environment config | `[[OWNER_GITHUB_HANDLE]]` | — | Yes |
| Security | Risk register, incident response | `[[OWNER_GITHUB_HANDLE]]` | — | Yes |
| Docs / Governance | Harness, ADRs, principles | `[[OWNER_GITHUB_HANDLE]]` | — | No |

**Sensitive domains** require the domain owner's review before merging changes.
This is enforced via CODEOWNERS for paths where that is possible.
For logic-level concerns (e.g., auth changes in non-auth paths), reviewers are expected
to flag these during review.

---

## Escalation Path

When the primary owner is unavailable:
1. Contact secondary owner (if listed)
2. Escalate to `[[OWNER_GITHUB_HANDLE]]` (project lead)
3. Document the escalation in the PR

---

## Rotation Log

Record when ownership changes so history is preserved:

| Date | Domain | Previous Owner | New Owner | Reason |
|------|--------|----------------|-----------|--------|
| | | | | |
