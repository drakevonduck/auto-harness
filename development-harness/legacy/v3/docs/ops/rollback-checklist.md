# Rollback Checklist

Use this when a production deployment needs to be reversed.

The rollback decision belongs to the release owner or on-call engineer.
Do not wait for consensus under pressure — make the call, execute, then debrief.

---

## Decision Gate

Answer these before rolling back:

1. **Is the problem confirmed production-affecting?**
   If the issue is limited to staging or internal tooling, do not roll back production.

2. **Is rollback faster than a hotfix?**
   If the fix is one line and can be deployed in < 10 minutes, a hotfix may be better.

3. **Does this release include a database migration?**
   If yes, rollback is significantly more complex — see §Migration Rollback below.
   If no, proceed to §Standard Rollback.

---

## Standard Rollback (no migration)

- [ ] Confirm rollback target commit/version: ___________
- [ ] Confirm the rollback target was previously stable in production
- [ ] Notify on-call and stakeholders that rollback is in progress
- [ ] Execute rollback deploy

*(Stack-specific rollback commands are in the active profile — see `profiles/`.)*

- [ ] Confirm application is healthy post-rollback
- [ ] Confirm key user flows are working
- [ ] Log the rollback: version rolled back from, version rolled back to, time, owner

---

## Migration Rollback

Database migrations complicate rollbacks significantly. The decision tree:

### Does a down migration exist?
- **Yes:** Run the down migration on production before rolling back application code.
  - [ ] Backup/snapshot confirmed before running down migration
  - [ ] Down migration tested in staging before running in production
  - [ ] Down migration applied: time ___________
  - [ ] Data integrity verified post-down-migration
  - [ ] Application code rolled back

- **No (forward-only migration):** Application rollback is likely not safe without data
  migration. Options:
  1. **Hotfix forward** — patch the application to handle the current schema state
  2. **Manual data remediation** — human-authored data fix to restore previous state
  3. **Accept the state** — if data impact is minimal, proceed without rollback

  Do not roll back application code against an incompatible schema without
  explicit sign-off from the database owner and at least one other engineer.

---

## Post-Rollback

- [ ] Root cause identified or investigation initiated
- [ ] Incident record created if rollback affected users
- [ ] Release checklist reviewed to identify what verification step was missed
- [ ] Follow-up ticket or ADR created if the release process needs updating

---

## Rollback Log

| Date | Release rolled back | Rolled back to | Reason | Owner |
|------|---------------------|---------------|--------|-------|
| | | | | |
