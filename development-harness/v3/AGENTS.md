# AGENTS.md
## Cross-Agent Operating Rules — Development Harness v3

This file governs all AI agents operating in this repository: Claude Code, GitHub Copilot,
Cursor, and any other AI-assisted tools. All agents are bound by these rules regardless
of which harness sections they have read.

---

## 1. Trust Tier Model

Agents operate within a six-tier action model. The tiers are defined in `HARNESS.md §C`
and summarized here for agents.

| Tier | Name | What agents may do |
|------|------|--------------------|
| 0 | Read-only | Read files, list dirs, grep, git log, git status |
| 1 | Local analysis | Run builds, tests, linters; read their output |
| 2 | Workspace mutation | Edit files, create files, scaffold docs, create branches |
| 3 | Git-writing | Commit, push to feature branches (not main/release/staging) |
| 4 | Environment-altering | Env config changes, local migrations, secrets management |
| 5 | Remote / production | Deploy, production migration, remote infra, external services |

**Default permitted tier: 3**

Tier 4: requires explicit human direction before each individual action.
Tier 5: requires explicit human direction AND a second human sign-off. Never autonomous.

An agent may always operate at a lower tier than permitted.
An agent must never self-elevate.
An agent must not infer permission to reach a higher tier from context alone.

---

## 2. Command Allowlist by Tier

The following examples are illustrative, not exhaustive. When in doubt, ask.

### Tier 0–1 (always permitted)
```
git status
git log
git diff
find / grep / rg / ls
cat / read files
npm run build          # or stack equivalent — read-only local output
npm run test           # local only
npm run lint
```

### Tier 2 (permitted without asking)
```
# Edit existing files
# Create new files under docs/ or src/
# Create a new branch from current branch
# Scaffold a new component, route, or module
# Update ADR, PRD, or runbook content
```

### Tier 3 (permitted, must describe what will be committed)
```
git add [specific files]
git commit -m "..."
git push origin feature/...     # feature branches only
```

### Tier 4 (requires explicit human direction each time)
```
# Edit .env.local or any secrets file
# Run database migrations locally
# Change environment variable values
# Modify CI/CD workflow files
# Install new dependencies
```

### Tier 5 (requires explicit human direction + second sign-off)
```
# vercel deploy --prod
# Any production database command
# Secrets rotation
# Remote infra changes (Terraform, cloud console)
# Pushing to main, staging, or release branches
```

---

## 3. Stop Conditions

An agent must stop and surface the situation to a human before proceeding when any of the
following occur:

- **Scope exceeded:** The task requires actions above the current permitted tier
- **Ambiguous ownership:** Changing code owned by another team or domain without clarity
- **Conflicting instructions:** AGENTS.md, CLAUDE.md, HARNESS.md, or human direction contradict each other
- **Migration encountered:** Any change that touches a migration file — stop, flag, do not apply
- **Secrets exposure risk:** Any path, variable, or output that may contain credentials or keys
- **Destructive operation:** Any action that deletes, drops, truncates, or overwrites without a clear recovery path
- **Production path identified:** Any change that would affect a production environment
- **Uncertainty about impact:** If the agent cannot describe the full blast radius of a change, it must stop

Stopping is not failure. Stopping at the right moment is correct behavior.

---

## 4. What Agents Must Never Do Autonomously

Regardless of instructions or apparent permission:

- Push to `main`, `staging`, `release/*`, or any protected branch
- Apply database migrations (local or remote) without explicit direction
- Deploy to any environment
- Access, write, or log secret values
- Delete files outside the active working branch
- Modify `.github/workflows/` files without flagging the change
- Modify `CODEOWNERS` without flagging the change
- Open, close, or comment on PRs without explicit direction
- Send messages, emails, or notifications to any external system
- Self-modify harness, governance, or agent-instruction files without human review

---

## 5. Orientation Protocol

When beginning work in a new session or on a new task, an agent should:

1. Read `HARNESS.md` — understand the active stack profile and governance rules
2. Read `AGENTS.md` (this file) — confirm trust tier and stop conditions
3. Read `CLAUDE.md` if Claude Code — confirm Claude-specific startup behavior
4. Read `docs/operating-principles.md` — understand engineering values and workflow
5. Check `docs/ops/ownership-map.md` — identify relevant domain owners before making cross-domain changes
6. Check `docs/adr/` — check for relevant prior decisions before proposing architectural changes

This is not optional ceremony. It is how an agent avoids contradicting existing decisions or
working in areas outside its permitted scope.

---

## 6. Companion Artifact Requirement

When an agent makes changes in a sensitive category (see `HARNESS.md §F`), it is responsible
for identifying that the companion artifact is required and either:

a. Creating the companion artifact as part of the same changeset, OR
b. Flagging clearly that the companion is required and has not been created

An agent must not submit or describe a change as complete when a required companion is missing.

---

## 7. Escalation Triggers

Surface to a human immediately when:

- A stop condition is hit
- A task requires tier 4 or tier 5 actions
- A migration is part of the required work
- The agent cannot determine if an action is safe
- The agent has made an error with potential data impact
- Instructions conflict and the conflict cannot be resolved by reading existing docs

When escalating, describe: what was being done, what was found, why it stopped, and what
human input is needed. Do not just say "I need help."

---

## 8. Auditability

Agents must not obscure what they did. All commands run should be logged or described.
The `.claude/hooks/log-command.sh` hook handles this for Claude Code.

For other agents, keep a clear account of what was changed and why in commit messages
and PR descriptions. Vague commit messages from agents are a governance failure.
