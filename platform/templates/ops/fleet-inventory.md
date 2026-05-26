<!--
Copyright [[YEAR]] [[OWNER_NAME]] <[[OWNER_EMAIL]]>
SPDX-License-Identifier: [[SPDX_LICENSE]]
-->

# Fleet Inventory — [[PROJECT_NAME]]

> Owner: [[OWNER]]
> Authoritative inventory source: [[AUTHORITATIVE_INVENTORY]]
> Last updated: YYYY-MM-DD

The canonical record of hosts this project manages. If a host runs in production and is not
in this table, that is a gap to close — not an exception to tolerate.

---

## Authoritative Source

The single source of truth for fleet membership is `[[AUTHORITATIVE_INVENTORY]]`. This
document is the human-readable projection of it. When they disagree, the inventory wins and
this document is updated.

---

## Hosts

| Host | Role | Environment | OS | Purpose | Inventory entry |
| ---- | ---- | ----------- | -- | ------- | --------------- |
| [[HOST_NAME]] | [[HOST_ROLE]] | production | [[HOST_OS]] | [[HOST_PURPOSE]] | `[[INVENTORY_PATH]]` |

---

## Roles

Define each role's responsibility and which configuration (roles/playbooks) applies to it.

| Role | Responsibility | Applied configuration |
| ---- | -------------- | --------------------- |
| [[ROLE_NAME]] | [[ROLE_RESPONSIBILITY]] | [[ROLE_CONFIG]] |

---

## Topology Change Procedure

Adding, removing, or re-roling a host is a fleet-topology change. It requires:

1. An update to this table and the authoritative inventory in the same change.
2. A maintenance window and rollback path recorded in `docs/ops/change-control.md`.
