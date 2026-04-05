# Stack Profile: Python
## Development Harness v3 — Overlay Example

This profile demonstrates how a non-Node stack integrates with the v3 harness.
It is intentionally more minimal than the Node/TypeScript profile — adapt it to your
actual framework (FastAPI, Django, Flask, etc.).

**Activate this profile:** Set `TECH_STACK_PROFILE=python` in `CLAUDE.md`.

---

## Stack

| Component | Expectation |
|-----------|-------------|
| Runtime | Python — pin version in `.python-version` or `pyproject.toml` |
| Language | Python 3.10+ |
| Framework | FastAPI / Django / Flask — specify in `CLAUDE.md` |
| Package manager | pip + `requirements.txt` OR Poetry OR uv — pick one |
| Lockfile | `requirements.txt` (pinned), `poetry.lock`, or `uv.lock` — committed |

As with the Node profile: the lockfile is a security artifact. Pin versions.
`requirements.txt` with unpinned ranges is not a lockfile.

---

## Commands

### Build and verify
```bash
python -m build           # if building a package
mypy .                    # type checking (if configured)
ruff check .              # linting (or: flake8, pylint)
ruff format --check .     # formatting check
```

### Tests
```bash
pytest                    # run all tests
pytest -x                 # fail fast
pytest --cov=src          # with coverage
```

### Database (if using Alembic / Django migrations)
```bash
# Alembic
alembic revision --autogenerate -m "description"   # generate migration
alembic upgrade head                               # apply (Tier 4)

# Django
python manage.py makemigrations    # generate
python manage.py migrate           # apply (Tier 4)
```

Database commands are Tier 4. Claude must not run them without explicit direction.

### Dev server
```bash
uvicorn app.main:app --reload    # FastAPI example
python manage.py runserver       # Django example
```

---

## Dependency Expectations

- **Adding a dependency:** Tier 4 — must ask before running `pip install`
- **Lockfile:** Regenerate with `pip freeze > requirements.txt` or `poetry lock` after
  any dependency change — never hand-edit the lockfile
- **Security audit:** `pip-audit` or `safety check` before merging dependency changes
- **High-severity findings** must have a mitigation plan before merge

---

## Config Files to Watch

| File | Why sensitive |
|------|--------------|
| `requirements.txt` / `pyproject.toml` | Dependency changes |
| `alembic.ini` | Migration config |
| `settings.py` / `config.py` | App configuration, often touches secrets |
| `Dockerfile` | Infra path — see CODEOWNERS |
| `.python-version` | Runtime version — affects all environments |

---

## CI Configuration (GitHub Actions)

Use these steps in `.github/workflows/stack.yml`:

```yaml
- name: Setup Python
  uses: actions/setup-python@v5
  with:
    python-version-file: .python-version   # or hardcode: '3.12'
    cache: 'pip'

- name: Install dependencies
  run: pip install -r requirements.txt     # or: poetry install --no-root

- name: Lint
  run: ruff check .

- name: Format check
  run: ruff format --check .

- name: Type check
  run: mypy .

- name: Test
  run: pytest --cov=src --cov-report=term-missing
```

For Poetry: replace the install step with `poetry install --no-root` and prefix
commands with `poetry run`.

---

## Claude Permissions Addendum

Add these to `.claude/settings.json` `allow` list when this profile is active:

```json
"Bash(python -m pytest*)",
"Bash(mypy*)",
"Bash(ruff check*)",
"Bash(ruff format --check*)"
```

Add these to the `deny` list:

```json
"Bash(pip install*)",
"Bash(alembic upgrade*)",
"Bash(python manage.py migrate*)"
```

---

## Migration Command Differences

- Migration files live in `alembic/versions/` or `<app>/migrations/`
- Alembic autogenerate is Tier 2 (creates a file); `upgrade head` is Tier 4 (applies)
- Django `makemigrations` is Tier 2; `migrate` is Tier 4
- The same migration readiness checklist applies regardless of framework
- Migration records in `docs/database/migration-records/` are required after any
  staging or production apply

---

## Core Harness Compatibility Notes

The following harness elements are stack-agnostic and apply unchanged to Python projects:

- Trust tier model — identical
- Placeholder convention — identical
- Sensitive-change companion rules — identical (paths may differ, update CODEOWNERS)
- Migration discipline — identical (commands differ, discipline does not)
- ADR and PRD process — identical
- Incident and risk register — identical

The only things that change per profile are: commands, lockfile expectations,
CI configuration, and CODEOWNERS paths.
