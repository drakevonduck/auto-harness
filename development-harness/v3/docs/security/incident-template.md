# Incident Template

Copy this file to `docs/security/incidents/YYYY-MM-DD-[slug].md` when an incident occurs.
Fill it out in real time or immediately after — do not reconstruct from memory days later.

---

# Incident: [Short Title]

**Date:** ___________
**Severity:** P0 (service down) / P1 (degraded) / P2 (contained, limited impact)
**Incident commander:** ___________
**Status:** Ongoing / Resolved / Postmortem pending

---

## Summary

*(One paragraph. What happened, who was affected, and for how long.)*

---

## Timeline

All times in UTC.

| Time | Event |
|------|-------|
| HH:MM | Incident detected / first symptom |
| HH:MM | *(key events in chronological order)* |
| HH:MM | Incident resolved |

---

## Impact

- **Users affected:** *(number or %, or "unknown")*
- **Data affected:** *(yes/no/unknown — if yes, describe what and whether it is recoverable)*
- **Duration:** *(time from first impact to resolution)*
- **Features affected:** *(list)*

---

## Root Cause

*(What actually caused this? Be specific. "Human error" is not a root cause — it is a
symptom. What made the error possible or likely?)*

---

## Detection

- **How was it detected?** *(monitoring alert / user report / engineer noticed)*
- **How long between occurrence and detection?**
- **Would better monitoring have caught this faster?** *(yes/no — if yes, note in action items)*

---

## Response

*(What was done to mitigate and resolve the incident?)*

---

## Action Items

Required: at least one action item per P0/P1 incident.

| Action | Owner | Due | Status |
|--------|-------|-----|--------|
| | | | |

---

## Risk Register Update

- [ ] `docs/security/risk-register.md` updated with any new or modified risks identified
- [ ] N/A — this incident did not reveal new risks

---

## Lessons Learned

*(What did the team learn? What would you do differently? What assumptions were wrong?
This section is not optional for P0/P1 incidents.)*

---

## Communication Log

*(Who was notified, when, and through what channel. Include external stakeholders if applicable.)*

| Time | Channel | Message summary | Sent by |
|------|---------|-----------------|---------|
| | | | |
