## Summary

*(What does this PR do? One paragraph. Focus on the why, not just the what.)*

---

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Refactor (no behavior change)
- [ ] Database migration
- [ ] Dependency update
- [ ] Docs / governance update
- [ ] Infrastructure / CI change

---

## Sensitive Change Review

Complete any applicable section. If none apply, check the box below and move on.

- [ ] None of the sensitive-change categories below apply to this PR

### Auth / Security Changes
*(Applies if this PR touches `src/auth/`, `src/middleware/`, session handling, or JWT logic)*
- [ ] `docs/security/risk-register.md` updated with any new or changed risks
- [ ] OR new ADR created for architectural security decision: `docs/adr/ADR-NNNN-*.md`
- [ ] Security domain owner reviewed: *(@ mention)*

### Database Migration
*(Applies if this PR includes or references a schema migration)*
- [ ] Migration readiness checklist completed: `docs/database/migration-records/YYYYMMDD-[slug].md`
- [ ] Migration has been applied and verified in staging before this PR is merged to main
- [ ] Rollback strategy documented in the migration record

### Infrastructure / Deploy Changes
*(Applies if this PR touches `vercel.json`, `Dockerfile`, `.github/workflows/`, `terraform/`)*
- [ ] `docs/ops/environment-inventory.md` updated if environment topology changed
- [ ] CI changes reviewed by infrastructure owner: *(@ mention)*

### Environment / Config Changes
*(Applies if this PR adds or removes environment variable keys)*
- [ ] `.env.example` updated with all new keys
- [ ] PR description lists each new key and its purpose (below)

**New environment variables in this PR:**

| Key | Purpose | Required in all envs? |
|-----|---------|----------------------|
| | | |

### Major Dependency Changes
*(Applies if this PR bumps a major version or adds a new dependency with architectural impact)*
- [ ] ADR created or updated if this dependency affects system architecture
- [ ] Dependency audit run with no new high-severity findings

---

## Testing

- [ ] Tests added or updated for the changed behavior
- [ ] All existing tests pass locally
- [ ] Edge cases considered: *(describe or N/A)*

---

## Documentation

- [ ] `docs/architecture/overview.md` updated if system topology changed
- [ ] Relevant ADR created or updated
- [ ] `CHANGELOG.md` updated (for user-visible changes)

---

## Checklist Before Requesting Review

- [ ] PR title is descriptive and not "fix stuff"
- [ ] Branch is up to date with the target branch
- [ ] No debug code, console.logs, or commented-out blocks left in
- [ ] No secrets, tokens, or credentials in any diff
- [ ] Sensitive-change sections above are complete or marked N/A

---

## Notes for Reviewers

*(Anything reviewers should know about non-obvious changes, areas of uncertainty,
or specific questions you have for them.)*
