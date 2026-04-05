# Risk Register

Tracks known architectural and security risks. This is a living document.
It is a canonical record — update it whenever new risks are identified or existing
risks change status.

**Owner:** `[[OWNER_GITHUB_HANDLE]]`
**Last reviewed:** `[[DATE]]`

Review this register at minimum:
- Before each major release
- After any security incident
- When a new external integration is added
- When auth or data handling logic changes significantly

---

## Active Risks

| ID | Area | Risk Description | Likelihood | Impact | Mitigation | Owner | Status |
|----|------|-----------------|------------|--------|------------|-------|--------|
| R-001 | Auth | *(describe the risk)* | Low/Med/High | Low/Med/High | *(what is in place)* | `[[OWNER_GITHUB_HANDLE]]` | Open |

**Likelihood:** How likely is this to occur given current controls?
**Impact:** What is the potential impact if it occurs?
**Status:** Open / Mitigated / Accepted / Transferred

---

## Risk Severity Matrix

```
         │  Low Impact  │  Med Impact  │  High Impact
─────────┼──────────────┼──────────────┼─────────────
High     │   Medium     │    High      │   Critical
Likelihood│             │              │
─────────┼──────────────┼──────────────┼─────────────
Med      │   Low        │    Medium    │    High
Likelihood│             │              │
─────────┼──────────────┼──────────────┼─────────────
Low      │   Acceptable │    Low       │    Medium
Likelihood│             │              │
```

Critical and High risks must have a named owner and active mitigation plan.
Accepted risks must have an explicit acceptance note.

---

## Mitigated / Closed Risks

| ID | Risk | Closed date | Closure reason |
|----|------|-------------|----------------|
| | | | |

---

## Accepted Risks

Document risks the team has explicitly decided to accept:

| ID | Risk | Accepted by | Date | Reason | Review date |
|----|------|-------------|------|--------|-------------|
| | | | | | |

---

## Adding a New Risk

When adding an entry:
1. Assign the next sequential ID
2. Be specific — "XSS attack" is not a risk entry; "User-supplied markdown rendered without sanitization in the comment feed" is
3. Identify a mitigation or an explicit acceptance reason
4. Assign an owner

A risk with no owner and no mitigation is just a worry written down. That is not useful.

---

## Incident Cross-References

| Incident | Related risk IDs | Date |
|----------|-----------------|------|
| | | |
