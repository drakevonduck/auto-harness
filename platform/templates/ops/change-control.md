<!--
Copyright [[YEAR]] [[OWNER_NAME]] <[[OWNER_EMAIL]]>
SPDX-License-Identifier: [[SPDX_LICENSE]]
-->

# Change Control — [[PROJECT_NAME]]

> Owner: [[OWNER]]
> Change authority: [[CHANGE_AUTHORITY]]
> Last updated: YYYY-MM-DD

How configuration reaches live hosts. Applying config to production is a human-directed
action; this document defines the gate it passes through.

---

## The Apply Gate

No configuration reaches a live host without passing, in order:

- [ ] Dry run: `[[DRY_RUN_COMMAND]]` (e.g. `ansible-playbook ... --check`) reviewed by a human
- [ ] Staged rollout: applied to a single canary host first (`[[CANARY_LIMIT_COMMAND]]`)
- [ ] Verification on the canary before fleet-wide apply
- [ ] Fleet-wide apply authorized by [[CHANGE_AUTHORITY]]

---

## Maintenance Windows

| Environment | Allowed window | Notification |
| ----------- | -------------- | ------------ |
| production | [[MAINTENANCE_WINDOW]] | [[NOTIFICATION_TARGET]] |

---

## Change Record

| Date | Change | Hosts affected | Dry-run reviewed by | Applied by | Rollback ref |
| ---- | ------ | -------------- | ------------------- | ---------- | ------------ |
| YYYY-MM-DD | [[CHANGE_SUMMARY]] | [[HOSTS]] | [[REVIEWER]] | [[APPLIER]] | `docs/ops/config-rollback.md` |
