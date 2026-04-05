# Release Checklist

Run this checklist before every production deployment. Do not skip steps under pressure.
If a step cannot be completed, the release is blocked until it can be or a conscious
exception is recorded here with an owner and a date.

**Release version:** ___________
**Deploy date/time:** ___________
**Release owner:** ___________
**Second approver:** ___________

---

## Pre-Deploy

### Code Readiness
- [ ] All changes in this release have been reviewed and merged to the release branch
- [ ] No open PRs are intended for this release but not yet merged
- [ ] All CI checks are passing on the release commit
- [ ] No known failing tests are being skipped or suppressed for this release

### Migration Readiness
- [ ] If this release includes a migration: migration readiness checklist is complete
- [ ] If this release includes a migration: the migration has been applied to staging and verified
- [ ] If this release includes a migration: rollback strategy is confirmed and documented
- [ ] If no migrations: N/A — confirm here: ___________

### Environment Readiness
- [ ] All required environment variables are present in production
- [ ] Any new `.env.example` keys from this release have been added to production secrets
- [ ] External service integrations required by this release are confirmed live

### Rollback Readiness
- [ ] Rollback checklist has been reviewed and is reachable (see `rollback-checklist.md`)
- [ ] A backup or snapshot exists if this release includes destructive data changes
- [ ] The team knows who calls the rollback decision and how

### Communication
- [ ] Stakeholders notified of planned maintenance window (if applicable)
- [ ] On-call engineer is aware of the deployment

---

## Deploy

- [ ] Deploy initiated by: ___________
- [ ] Deploy time: ___________
- [ ] Deploy method: ___________

*(Stack-specific deploy commands are defined in the active profile — see `profiles/`.)*

---

## Post-Deploy Verification

- [ ] Application is responding to health checks
- [ ] Key user flows tested: ___________
- [ ] No unexpected error rate spike in logs or monitoring
- [ ] Any migrations applied successfully and verified
- [ ] External integrations confirmed working

### Verification performed by: ___________
### Verification time: ___________

---

## Post-Deploy Documentation

- [ ] `CHANGELOG.md` updated with this release
- [ ] Any incidents or unexpected behavior during deploy logged

---

## Exception Log

If any step above was skipped or cannot be completed, record it here:

| Step | Reason skipped | Owner | Date |
|------|---------------|-------|------|
| | | | |
