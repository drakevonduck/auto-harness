# Runbook Index

All operational runbooks are tracked here. A runbook that is not indexed is invisible
to on-call and may as well not exist.

**Owner:** `[[OWNER_GITHUB_HANDLE]]`
**Last reviewed:** `[[DATE]]`

---

## How to Add a Runbook

1. Create the runbook file in `docs/ops/runbooks/[topic].md`
2. Add an entry to the table below with: name, trigger, file link, owner, last-tested date
3. Include in the next PR that references the runbook

A runbook that has never been tested is a hypothesis, not a procedure.

---

## Active Runbooks

| Runbook | Trigger / When to Use | File | Owner | Last Tested |
|---------|----------------------|------|-------|-------------|
| *(none yet — add your first runbook)* | — | — | — | — |

---

## Runbook Template

When creating a new runbook, use this structure:

```markdown
# Runbook: [Title]

**Trigger:** When does this runbook apply?
**Owner:** @github-handle
**Last tested:** YYYY-MM-DD
**Escalation:** Who to contact if this runbook fails

---

## Prerequisites

- What access is needed
- What tools must be available
- What state is assumed

## Steps

1. Step one — describe exactly what to do, not what to think about
2. Step two
3. ...

## Verification

How to confirm the procedure worked.

## Rollback

What to do if the procedure makes things worse.

## Notes

Known edge cases, gotchas, or historical context.
```

---

## Retired Runbooks

| Runbook | Reason Retired | Date |
|---------|---------------|------|
| *(none yet)* | — | — |
