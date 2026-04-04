# Environment Inventory

Tracks all deployment environments, their configuration state, and responsible parties.
Keep this current — "I think staging has that config" is not good enough.

**Owner:** `[[OWNER_GITHUB_HANDLE]]`
**Last updated:** `[[DATE]]`

---

## Environments

### Production

| Property | Value |
|----------|-------|
| URL | `[[PRODUCTION_URL]]` |
| Hosting | *(e.g., Vercel, AWS, GCP)* |
| Branch deployed | `main` |
| Deploy method | *(manual / CI trigger / automated)* |
| Database | *(e.g., Supabase production project ref)* |
| Owner | `[[OWNER_GITHUB_HANDLE]]` |
| Access control | *(who can deploy — role or handle list)* |

**Required environment variables:**

| Key | Purpose | Set in |
|-----|---------|--------|
| *(add entries matching `.env.example`)* | | |

**Known deviations from `.env.example`:** *(list any keys present in prod but not in example, and why)*

---

### Staging

| Property | Value |
|----------|-------|
| URL | `[[STAGING_URL]]` |
| Hosting | *(e.g., Vercel preview / separate project)* |
| Branch deployed | `staging` |
| Deploy method | *(manual / CI trigger / automated)* |
| Database | *(separate staging DB or shared — be explicit)* |
| Owner | `[[OWNER_GITHUB_HANDLE]]` |

**Required environment variables:**

| Key | Purpose | Set in |
|-----|---------|--------|
| *(add entries — should mirror production with staging-specific values)* | | |

**Data state:** *(Describe what data is in staging. Is it anonymized prod data? Seed data? Empty?)

---

### Local Development

| Property | Value |
|----------|-------|
| Setup guide | `docs/contributing/getting-started.md` |
| Required tooling | *(Node version, Docker, etc. — see active profile)* |
| Database | *(local Docker / remote dev project)* |
| Env file | `.env.local` (gitignored) |
| Template | `.env.example` |

---

## Environment Promotion Flow

```
local → staging → production
```

- Code: feature branches → staging → main
- Migrations: validated local → applied staging → applied production (never skip staging)
- Secrets: managed separately per environment — never promoted as files

---

## Change Log

| Date | Environment | Change | Who |
|------|-------------|--------|-----|
| | | | |
