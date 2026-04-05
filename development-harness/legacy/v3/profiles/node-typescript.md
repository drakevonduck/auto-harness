# Stack Profile: Node.js / TypeScript
## Development Harness v3 — Default Overlay

This is the default stack profile. It is Node/TypeScript-first and does not pretend
otherwise. If your stack is different, use `profiles/python.md` as a starting point
for a new profile, or create one from scratch.

**Activate this profile:** Set `TECH_STACK_PROFILE=node-typescript` in `CLAUDE.md`.

---

## Stack

| Component | Expectation |
|-----------|-------------|
| Runtime | Node.js — pin version in `.nvmrc` |
| Language | TypeScript — strict mode on |
| Framework | Next.js App Router (or equivalent) |
| Package manager | npm / pnpm / yarn — pick one and commit to it |
| Lockfile | `package-lock.json` or `pnpm-lock.yaml` — committed, never gitignored |

The lockfile is a security artifact, not just a convenience. Committing it ensures
reproducible installs and makes supply chain changes visible in PRs.

---

## Commands

### Build and verify
```bash
npm run build         # or: pnpm build
npm run typecheck     # tsc --noEmit (add this script if not present)
npm run lint          # eslint
```

### Tests
```bash
npm run test          # unit / integration tests
npm run test:watch    # watch mode during development
```

### Database (if using Supabase or Prisma)
```bash
# Supabase
npx supabase db diff   # generate a migration (review before committing)
npx supabase db push   # apply locally (Tier 4 — requires explicit direction)

# Prisma
npx prisma migrate dev  # generate + apply migration locally (Tier 4)
npx prisma db push      # schema push without migration (Tier 4)
```

Database commands are Tier 4. Claude must not run them without explicit direction.

### Dev server
```bash
npm run dev            # local development server
npm run dev:staging    # if staging env is wired separately
```

---

## Dependency Expectations

- **Adding a new dependency:** Tier 4 — must ask before running `npm install`
- **Removing a dependency:** Tier 4 — verify nothing breaks first
- **Major version bumps:** Require ADR if the dependency is architectural
- **Lockfile conflicts:** Resolve by re-running the install command, not by manually
  editing the lockfile

Run `npm audit` (or `pnpm audit`) before merging dependency changes. High-severity
findings must have a mitigation plan before merge.

---

## Config Files to Watch

Changes to these files trigger companion or review requirements:

| File | Why sensitive |
|------|--------------|
| `package.json` | Dependency changes may affect security posture |
| `next.config.*` | Can affect headers, rewrites, and security policies |
| `tsconfig.json` | Strict mode changes can mask type errors |
| `eslint.config.*` | Rule changes can mask code quality issues |
| `.nvmrc` | Node version changes affect all environments |
| `vercel.json` | Infra path — see CODEOWNERS |

---

## CI Configuration (GitHub Actions)

Use these steps in `.github/workflows/stack.yml`:

```yaml
- name: Setup Node
  uses: actions/setup-node@v4
  with:
    node-version-file: .nvmrc
    cache: 'npm'   # or 'pnpm'

- name: Install dependencies
  run: npm ci    # always use ci, not install, in CI

- name: Type check
  run: npm run typecheck

- name: Lint
  run: npm run lint

- name: Test
  run: npm run test

- name: Build
  run: npm run build
```

For pnpm, replace `npm ci` with `pnpm install --frozen-lockfile`.

---

## Claude Permissions Addendum

Add these to `.claude/settings.json` `allow` list when this profile is active:

```json
"Bash(npm run build)",
"Bash(npm run typecheck)",
"Bash(npm run lint)",
"Bash(npm run test*)",
"Bash(npm run dev)"
```

Add these to the `deny` list:

```json
"Bash(npm install*)",
"Bash(npm ci)",
"Bash(pnpm install*)",
"Bash(npx supabase db push*)",
"Bash(npx prisma migrate*)"
```

The last two are Tier 4 and must require explicit direction each time.

---

## Migration Command Differences

This profile uses SQL migration files or Prisma migrations. Key differences from
the stack-agnostic migration policy:

- Migration files live in `migrations/` or `supabase/migrations/`
- Apply locally with `npx supabase db push` or `npx prisma migrate dev` (Tier 4)
- Apply to staging/production via CI gate or explicit CLI command with human present
- Never use `prisma db push` in production — use migrations for auditability

---

## Common Gotchas

- `next/headers` is async in Next.js 15+. Calls to `cookies()` and `headers()` must be awaited.
- Server Components cannot use client hooks (`useState`, `useEffect`, etc.)
- Environment variables accessed in the browser must be prefixed `NEXT_PUBLIC_`
- `npm ci` requires a lockfile to exist — if the lockfile is missing from the repo, this is a governance failure
