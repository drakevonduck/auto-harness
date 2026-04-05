# Architecture Overview

High-level map of the system. Update this when new components are added or
service topology changes. A PR that introduces a new external integration or
service boundary without updating this file is incomplete.

**Owner:** `[[OWNER_GITHUB_HANDLE]]`
**Last updated:** `[[DATE]]`

---

## System Summary

**App:** `[[APP_TITLE]]`
**Stack profile:** See `profiles/[[TECH_STACK_PROFILE]].md`
**Production URL:** `[[PRODUCTION_URL]]`

*(Replace this section with a one-paragraph description of what the system does
and its primary user-facing capabilities.)*

---

## Component Map

```
[Client / Browser]
    │
    ├── Next.js App Router (SSR + RSC)
    │       ├── UI Components (React)
    │       ├── Server Actions
    │       └── API Routes
    │
    └── [Mobile Shell — if applicable]
            └── Capacitor (iOS / Android)

[Backend / Data]
    │
    ├── Supabase / PostgreSQL
    │       ├── Auth (sessions, JWT)
    │       ├── Database (RLS-enforced)
    │       └── Storage (if applicable)
    │
    └── [External Services]
            ├── *(list each external API / service here)*
            └── ...
```

**Instructions:** Replace this diagram with an accurate representation of your actual
system. Remove placeholder services that do not apply. Add any that are missing.

---

## External Integrations

| Service | Purpose | Auth method | Owner | Documented in |
|---------|---------|-------------|-------|---------------|
| *(add entries for each external service)* | | | | |

When a new external integration is added, this table must be updated in the same PR.

---

## Data Flow Summary

*(Describe how data moves through the system at a high level. E.g., "User submits form →
Server Action validates + writes to Supabase → client refreshes via revalidatePath."
This does not need to be exhaustive — it needs to be accurate enough to reason about
security and failure modes.)*

---

## Key Constraints and Non-Obvious Decisions

*(List any architectural constraints or decisions that are not obvious from the code.
E.g., "All writes go through Server Actions — direct client-side Supabase writes are
prohibited except for auth." These belong here until they are promoted to ADRs.)*

---

## ADRs Affecting Architecture

| ADR | Decision | Status |
|-----|----------|--------|
| ADR-0001 | *(first architectural decision)* | Accepted |

---

## Known Technical Debt

*(Be honest. List architectural debt that is known and accepted, with context.
Not a complaint log — a working map of where the floor is uneven.)*

| Area | Debt | Impact | Owner | Planned to address? |
|------|------|--------|-------|---------------------|
| | | | | |
