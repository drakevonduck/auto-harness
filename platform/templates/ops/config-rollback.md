<!--
Copyright [[YEAR]] [[OWNER_NAME]] <[[OWNER_EMAIL]]>
SPDX-License-Identifier: [[SPDX_LICENSE]]
-->

# Configuration Rollback — [[PROJECT_NAME]]

> Owner: [[OWNER]]
> Rollback authority: [[ROLLBACK_AUTHORITY]]
> Last updated: YYYY-MM-DD
> Last exercised: YYYY-MM-DD

For a config-managed fleet, rollback means restoring known-good configuration state — not
redeploying a product version. A rollback path that has never been exercised is not a
rollback plan.

---

## Codify Before Modify

Before changing hand-tuned or production config, capture the current known-good state into
version control:

- [ ] Snapshot current config: `[[SNAPSHOT_COMMAND]]` (e.g. an extract-configs run)
- [ ] Commit the snapshot or store it at: `[[SNAPSHOT_LOCATION]]`
- [ ] Confirm the snapshot is complete before applying any change

---

## Restore Procedure

- [ ] Identify the last known-good snapshot: `[[KNOWN_GOOD_REF]]`
- [ ] Halt any in-progress apply across the fleet
- [ ] Restore config to affected hosts: `[[RESTORE_COMMAND]]`
- [ ] Reload affected services via handlers (not ad-hoc restarts)
- [ ] Verify service health on each restored host: `[[HEALTH_CHECK_COMMAND]]`

---

## Verification

- [ ] Affected hosts serve correctly post-restore
- [ ] The fleet inventory and change-control record reflect the rollback
