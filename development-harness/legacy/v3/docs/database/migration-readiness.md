# Migration Readiness Checklist

**Usage:** Copy this file to `docs/database/migration-records/YYYYMMDD-[slug].md`
for each migration event. Fill it out before applying the migration.
Do not apply the migration until the checklist is complete.

---

## Migration Identity

**Migration name/file:** ___________
**Target environment:** local / staging / production
**Date/time of apply:** ___________
**Applied by:** ___________
**Migration type:** Additive / Destructive / Schema-only / Data migration

---

## Description

*(What does this migration do? Be specific. "Adds user_preferences table" is fine.
"Updates schema" is not.)*

---

## Pre-Migration Checklist

### Review

- [ ] Migration file reviewed by at least one engineer who did not write it
- [ ] SQL reviewed for unintended side effects (locks, cascade deletes, etc.)
- [ ] Migration is isolated from feature code (in its own PR or clearly separated commit)

### Compatibility

- [ ] Application code is compatible with both pre- and post-migration schema
  *(or deploy is coordinated as a single atomic event with awareness of downtime risk)*
- [ ] Any RLS policies affected by schema changes have been reviewed
- [ ] Any views, functions, or triggers affected by schema changes have been reviewed

### Rollback

- [ ] A down migration exists and has been reviewed
  - If no down migration: explain why this is forward-only: ___________
- [ ] Down migration has been tested in a non-production environment (if applicable)

### Snapshot / Backup

- [ ] A database snapshot or backup exists prior to this migration
  - Snapshot/backup location: ___________
  - If snapshot not taken: explain why it was deemed unnecessary: ___________

*(For local/development environments, a snapshot may be skipped with justification.
For staging and production, a snapshot is required for any destructive migration.)*

---

## Apply

- [ ] Migration applied successfully
- [ ] Apply timestamp: ___________
- [ ] No unexpected errors or warnings during apply

---

## Post-Apply Verification

*(List specific checks run after the migration was applied. "Looks fine" is not verification.)*

- [ ] Schema reflects expected state (specific tables/columns confirmed)
- [ ] Application health check passing
- [ ] Key features affected by this migration tested: ___________
- [ ] Row counts, data integrity checks (if data migration): ___________

---

## Migration Record

After apply is verified:
- [ ] This checklist filed in `docs/database/migration-records/YYYYMMDD-[slug].md`
- [ ] PR or ticket linked to this migration record: ___________
- [ ] Risk register updated if this migration introduced or resolved a risk

---

## Notes

*(Anything that went wrong or was unexpected during apply. Be honest. Future you will
thank current you.)*
