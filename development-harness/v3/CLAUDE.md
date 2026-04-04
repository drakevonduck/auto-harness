# CLAUDE.md
## Claude Code Operating Instructions — Development Harness v3

This file is Claude Code-specific. General agent rules live in `AGENTS.md`.
This file supplements, not replaces, `AGENTS.md`.

---

## Active Stack Profile

<!-- Update this line during bootstrap -->
**Active profile:** `[[TECH_STACK_PROFILE]]` — see `profiles/[[TECH_STACK_PROFILE]].md`

---

## 1. Startup Reading Order

At the start of every session, read in this order:

1. `HARNESS.md` — understand current governance state and active profile
2. `AGENTS.md` — confirm trust tiers and stop conditions
3. `CLAUDE.md` (this file) — Claude-specific behavior
4. `docs/operating-principles.md` — engineering values
5. `docs/ops/ownership-map.md` — domain ownership before cross-domain changes
6. Relevant `docs/adr/` files — prior decisions related to the current task

Do not begin implementation work until steps 1–3 are complete.

---

## 2. Orientation Steps

After reading the startup sequence:

- Confirm the active stack profile and what it means for permitted commands
- Check if the current task touches any sensitive path from `HARNESS.md §F`
- Check if the current task involves a migration — if so, stop and surface before proceeding
- Identify the domain owner for any area you will change
- Identify any existing ADRs relevant to the task

If you cannot determine the scope of the task from available context, ask before starting.

---

## 3. Scope Containment

Claude should work within the scope of the stated task. Scope creep is a governance risk.

**Before expanding scope:**
- Ask if the additional work is wanted
- Do not refactor code you were not asked to refactor
- Do not add features alongside bug fixes
- Do not "improve" docs that were not part of the task

**What Claude may do without asking:**
- Fix obvious syntax/linting errors in files it is already editing
- Update companion docs required by the sensitive-change model
- Create required stub files when bootstrapping

---

## 4. Required Artifact Updates

When Claude makes certain changes, it must also update companion artifacts.
See `HARNESS.md §F` for the full table. Summary:

| Change | Required companion |
|--------|--------------------|
| Auth / security code | `docs/security/risk-register.md` or new ADR |
| New migration file | Completed `docs/database/migration-readiness.md` checklist |
| New env variable | Updated `.env.example` |
| New external service integration | Updated `docs/architecture/overview.md` section |
| Major dependency | ADR if architectural impact |

Claude must not describe a change as complete when a companion is missing.

---

## 5. Trust Tier Enforcement

Claude operates at **Tier 3 by default** (see `AGENTS.md §1`).

**Claude must ask before:**
- Installing or removing dependencies (Tier 4)
- Modifying `.env.local` or any secrets file (Tier 4)
- Running database migrations (Tier 4)
- Modifying CI/CD workflows (Tier 4)
- Any deployment action (Tier 5)
- Pushing to main, staging, or release branches (Tier 5)

If the user asks Claude to do a Tier 5 action directly in chat, Claude should confirm
explicitly before proceeding: "This is a Tier 5 action (remote/production). Confirm you
want to proceed?"

---

## 6. Stop Conditions

Stop immediately and surface to the user when:

- The task requires Tier 4 or 5 actions not yet authorized
- A migration file is touched or created
- A file outside the stated scope would be materially affected
- A secret or credential is encountered in any file
- A destructive operation (delete, drop, truncate) is required
- The task contradicts an existing ADR and it is not clear if the ADR should be updated
- Instructions in HARNESS.md, AGENTS.md, CLAUDE.md, or direct user instructions conflict

Do not guess through a stop condition. Stop, describe what was found, and ask.

---

## 7. What Claude Must Never Do Autonomously

- Push to `main`, `staging`, `release/*`, or any protected branch
- Apply any database migration
- Deploy to any environment
- Access, read aloud, or log secret values
- Delete tracked files outside the current working task
- Self-modify `HARNESS.md`, `AGENTS.md`, or `CLAUDE.md` without human review
- Open PRs, create issues, or post to external services without explicit direction
- Run `git reset --hard`, `git clean -f`, or other destructive git operations
- Run `rm -rf` or any recursive deletion without explicit direction
- Escalate its own permissions

---

## 8. Committing and Branch Discipline

Claude may create commits on feature branches. It must:

- Use descriptive commit messages that say why, not just what
- Never commit `.env`, `.env.local`, secrets, or credential files
- Never amend published commits
- Never force-push without explicit direction
- Stage specific files, not `git add .` unless the intent is unambiguous

When a pre-commit hook fails, Claude must investigate and fix the root cause, not bypass
the hook.

---

## 9. How Claude Should Describe Its Work

When completing a task, Claude should say:

- What changed (files, behavior)
- What was not changed (scope boundaries)
- Whether any companion artifacts were updated
- Whether any stop conditions were encountered and resolved
- Whether any follow-up tasks are required

Brief and specific. Not a summary of every line changed.

---

## 10. .claude/settings.json Reference

The committed `settings.json` should define:

```json
{
  "permissions": {
    "allow": [
      "Bash(git status)",
      "Bash(git log*)",
      "Bash(git diff*)",
      "Bash(npm run build)",
      "Bash(npm run test*)",
      "Bash(npm run lint)"
    ],
    "deny": [
      "Bash(git push origin main*)",
      "Bash(git push origin staging*)",
      "Bash(vercel deploy*)",
      "Bash(rm -rf*)"
    ]
  }
}
```

Stack-specific commands should be added via the active profile (see `profiles/`).
Tier 4/5 commands should not appear in the `allow` list.

---

## 11. Hook Configuration

The `log-command.sh` PostToolUse hook should be wired in `settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/log-command.sh"
          }
        ]
      }
    ]
  }
}
```

This creates an audit log of all bash commands Claude executes. It is not a substitute
for real records but helps debug sessions and review agent behavior.
