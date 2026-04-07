# Skills and Agents
## How the Harness Integrates with External AI Tool Skills

The harness operates at three layers of agent knowledge. Understanding all three prevents
gaps where an agent knows governance rules but lacks domain-specific tool knowledge, or
knows a tool well but has no governance context.

---

## The Three-Layer Model

```
Layer 1 — Kernel doctrine + compiled fragments
  Provided by: harness modules (compiledFragments field)
  Contents: trust tier model, lifecycle controls, companion rules, module READMEs
  Agent reads these at session start via AGENTS.md or CLAUDE.md shims

Layer 2 — External skills (OpenClaw / ClawHub)
  Provided by: developer installs skills via `clawhub install <slug>`
  Contents: vendor-specific APIs, deployment patterns, library best practices
  Examples: supabase, next-best-practices, lb-vercel-skill, ffmpeg-master

Layer 3 — Project contract
  Provided by: project's own AGENTS.md and CLAUDE.md
  Contents: project-specific constraints, overrides, agent scope boundaries
  Agent reads this at session start
```

Layer 1 tells the agent *how to govern work*. Layer 2 tells the agent *how the tools work*.
Layer 3 tells the agent *what this specific project allows*. A project that installs Layer 2
skills without Layer 1 gets a well-informed agent with no governance. A project that enforces
Layer 1 without Layer 2 gets a well-governed agent that guesses at framework APIs.

---

## Skill Ecosystem: OpenClaw and ClawHub

Skills in this harness reference the **OpenClaw / ClawHub** ecosystem. OpenClaw is a
locally-running AI assistant; ClawHub is its public skills registry.

**Curated skill directory:** `https://github.com/unclenate/awesome-openclaw-skills`

This repository is a curated subset of the full ClawHub registry (~13,700 skills), filtered
for quality, security, and relevance. Skills referenced in harness module declarations are
drawn from this curated list unless explicitly noted otherwise.

**Installation:**

```bash
# Install a skill by slug
clawhub install <skill-slug>

# Or copy manually
cp -r <skill-folder> ~/.openclaw/skills/     # global
cp -r <skill-folder> <project>/skills/       # workspace (takes priority)
```

Skills can also be installed by pasting a skill's GitHub repository URL directly into the
OpenClaw chat — the assistant will handle setup automatically.

---

## `recommendedSkills` in module.yaml

Each module can declare `recommendedSkills` — a list of ClawHub skill slugs that provide
domain-specific knowledge relevant to that module. This field is:

- **Optional.** Modules with no relevant external skills omit it.
- **Not enforced by validators.** Skills are installed by the developer, not checked by CI.
- **Informational.** The harness documents what to install; it does not install it.

Example from `domains/supabase/module.yaml`:

```yaml
recommendedSkills:
  - supabase
```

The slug matches the ClawHub registry identifier — pass it directly to `clawhub install`.

---

## Skill Installation by Module

Skills marked **required** are effectively mandatory for correct agent behavior in that domain.
All slugs can be verified in `https://github.com/unclenate/awesome-openclaw-skills`.

| Active module | Slug | Priority | Purpose |
| ------------- | ---- | -------- | ------- |
| `stacks/node-typescript` (Next.js) | `next-best-practices` | Recommended | File conventions, RSC boundaries, data patterns, async APIs |
| `stacks/node-typescript` (Next.js 16+) | `next-cache-components` | Recommended | PPR, `use cache` directive, `cacheLife`, `cacheTag` |
| `stacks/node-typescript` (Vercel deploy) | `lb-vercel-skill` | Recommended | Vercel CLI — projects, deployments, env vars, domains |
| `stacks/node-typescript` (React perf) | `react-perf` | Optional | React and Next.js performance optimization patterns |
| `stacks/node-typescript` + Supabase | `supabase` | Recommended | Supabase database ops, vector search, storage |
| `stacks/python` + Supabase | `supabase` | Recommended | Same — Python Supabase client usage |
| `domains/supabase` | `supabase` | Recommended | Supabase database ops, vector search, storage |
| `data/relational-postgres` | `postgres-perf` | Optional | PostgreSQL performance optimization and best practices |
| `domains/media-pipeline` | `ffmpeg-master` | Recommended | Video and audio processing tasks |
| `domains/media-pipeline` | `mediaproc` | Optional | Process media files in a locked-down SSH container |
| `domains/web3` | See Web3 section below | — | Not in curated list — see full registry |

---

## Web3 Skills

Web3 skills are **not included in the curated awesome-openclaw-skills list** — they were
intentionally filtered out due to the volume of low-quality and spam entries in that category
of the ClawHub registry.

Web3 skills are available directly from the full ClawHub registry at `clawskills.sh`.

**Security requirements before installing any Web3 skill from the full registry:**

1. Install a skill vetter first. The curated list includes `azhua-skill-vetter`
   (`clawhub install azhua-skill-vetter`) — a security-first skill vetting tool for AI agents.
   Run it against any Web3 skill before activation.

2. Test all Web3 skills in an isolated environment before connecting to any live wallet,
   contract, or API key with production access.

3. Skills that touch transaction signing must be reviewed against the trust tier model
   in `platform/core/kernel/base/trust-model.md`. Transaction signing is Tier 5 —
   irreversible, permanent consequences.

4. Install a pre-execution threat blocker before enabling any write capability. GoPlus
   AgentGuard (`goplus-agent-guard` on ClawHub) provides real-time threat blocking.

5. Most Web3 registry entries are in early experimental versions and **may contain unknown
   vulnerabilities**. Treat them as untrusted third-party code until audited.

**Web3 skills referenced in `domains/web3/module.yaml`** (full ClawHub registry, not curated):

| Slug | Purpose |
| ---- | ------- |
| `goplus-agent-guard` | Pre-execution security scanning and threat blocking |
| `mist-track` | AML compliance and address risk classification |
| `dune-mcp` | On-chain data queries via Dune MCP server |
| `nansen` | Wallet and token analytics |
| `clawnch` | ERC-20 deployment on Base (write-capable platforms only) |
| `okx-onchain-os` | Multi-chain wallet/transaction surface (write-capable only) |

> Read-only analytics platforms (risk scoring, address analysis, chain data indexing) need
> only MistTrack and Dune. Wallet and deployment skills are not needed for MVP analytics.

---

## How to Discover Which Skills to Install

After your manifest is valid and module graph is green:

1. Read the `recommendedSkills` field in each active module's `module.yaml`.
2. Cross-reference with the table above.
3. For each slug: `clawhub install <slug>` or find it in the curated directory.
4. For Web3 projects: run `azhua-skill-vetter` before installing anything from the full registry.
5. Confirm the skill is active by checking your OpenClaw skill list.

There is no validator for skill installation. It is a developer discipline step, not a CI gate.

---

## Skills and the Bootstrap Sequence

Skills fit into the bootstrap sequence between agent pack validation and CI wiring:

```
Step 6 — validate-agent-pack.sh      (agent CLAUDE.md / AGENTS.md exist)
Step 6.5 — install recommended skills (this document)
Step 7 — wire up CI
```

The `bootstrap-quickstart.md` guide includes a skills discovery step after agent pack validation.

---

## Skills vs. compiledFragments

These are complementary, not competing:

| | `compiledFragments` | External skills |
| - | ------------------- | --------------- |
| Source | Harness platform docs | ClawHub registry |
| Content | Governance rules, module READMEs, trust model | API patterns, library usage, deployment config |
| Installed by | Read at agent session start via AGENTS.md | Developer installs via `clawhub install` |
| Enforced | Yes — validator can check file existence | No — informational only |
| Example | `platform/profiles/domains/supabase/README.md` | `supabase` |

A well-configured project uses both: compiled fragments for governance context, external skills
for tool/API accuracy.

---

## Reference

| Resource | Path |
| -------- | ---- |
| Curated skill directory | `https://github.com/unclenate/awesome-openclaw-skills` |
| Trust tier model | `platform/core/kernel/base/trust-model.md` |
| Module field reference | `platform/core/registry/module-types.md` |
| Bootstrap quickstart | `platform/workflow/bootstrap-quickstart.md` |
| Agent pack guide | `platform/agents/claude-code/README.md` |
| Web3 domain module | `platform/profiles/domains/web3/module.yaml` |
| Supabase domain module | `platform/profiles/domains/supabase/module.yaml` |
