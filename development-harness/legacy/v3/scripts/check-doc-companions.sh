#!/usr/bin/env bash
# check-doc-companions.sh
# Enforces that PRs touching sensitive paths include required companion document changes.
# Exits 0 if all companions are present, exits 1 with a description of what is missing.
#
# Usage:
#   bash scripts/check-doc-companions.sh [base-branch]
#
# Default base branch: main
# Called by CI in .github/workflows/harness.yml
#
# This script checks that the PR diff touches companion paths when sensitive paths
# are changed. It cannot verify that the companion content is substantive —
# that is the reviewer's responsibility.

set -euo pipefail

BASE_BRANCH="${1:-main}"
FAILED=0
WARNINGS=()

# Get the list of files changed relative to the base branch
CHANGED_FILES=$(git diff --name-only "origin/${BASE_BRANCH}...HEAD" 2>/dev/null \
  || git diff --name-only "${BASE_BRANCH}...HEAD" 2>/dev/null \
  || echo "")

if [[ -z "$CHANGED_FILES" ]]; then
  echo "No changed files detected relative to ${BASE_BRANCH}. Skipping companion check."
  exit 0
fi

echo "Checking doc companions for changed files..."
echo "Base: ${BASE_BRANCH}"
echo ""

# Helper: check if any changed file matches a pattern
files_match() {
  local pattern="$1"
  echo "$CHANGED_FILES" | grep -qE "$pattern"
}

# Helper: require that at least one companion path is also changed
require_companion() {
  local trigger_desc="$1"
  local companion_desc="$2"
  local companion_pattern="$3"

  if ! files_match "$companion_pattern"; then
    WARNINGS+=("MISSING COMPANION: ${trigger_desc} changed but ${companion_desc} was not updated.")
    WARNINGS+=("  Required: at least one file matching '${companion_pattern}'")
    WARNINGS+=("")
    FAILED=1
  fi
}

# ── Rule 1: Auth / security logic → risk-register or ADR ──────────────────────
if files_match "^src/auth/|^src/middleware/|session|jwt|token" ; then
  if ! files_match "docs/security/risk-register\.md|docs/adr/ADR-"; then
    WARNINGS+=("MISSING COMPANION: Auth or security code changed.")
    WARNINGS+=("  Required: update docs/security/risk-register.md OR create a docs/adr/ADR-NNNN-*.md")
    WARNINGS+=("")
    FAILED=1
  fi
fi

# ── Rule 2: Database migrations → migration readiness checklist ────────────────
if files_match "^migrations/|^supabase/migrations/|^alembic/"; then
  require_companion \
    "Database migration file" \
    "migration readiness record" \
    "docs/database/migration-records/"
fi

# ── Rule 3: CI / infra changes → environment inventory ────────────────────────
if files_match "^\.github/workflows/|^vercel\.json$|^Dockerfile|^terraform/"; then
  require_companion \
    "Infrastructure or CI/CD file" \
    "environment-inventory.md (if topology changed)" \
    "docs/ops/environment-inventory\.md"
fi

# ── Rule 4: New environment variable keys → .env.example ──────────────────────
# This checks that .env.example was touched when any env-related file changed.
# It cannot verify that new keys were added — that is a reviewer concern.
if files_match "\.env\." && ! files_match "^\.env\.example$"; then
  WARNINGS+=("NOTE: An env-related file changed but .env.example was not updated.")
  WARNINGS+=("  If new environment keys were added, .env.example must be updated.")
  WARNINGS+=("  (This is a warning, not a hard failure — reviewers must verify.)")
  WARNINGS+=("")
  # Not setting FAILED=1 here — this is a reviewer prompt, not a hard gate
fi

# ── Rule 5: CODEOWNERS changes → require a listed owner in the diff ───────────
if files_match "^\.github/CODEOWNERS$"; then
  WARNINGS+=("NOTE: CODEOWNERS was modified.")
  WARNINGS+=("  Ensure at least one existing listed owner approved this PR.")
  WARNINGS+=("")
fi

# ── Rule 6: New service boundary → architecture overview ──────────────────────
if files_match "^src/services/"; then
  require_companion \
    "New or modified service" \
    "docs/architecture/overview.md" \
    "docs/architecture/overview\.md"
fi

# ── Output results ─────────────────────────────────────────────────────────────
if [[ ${#WARNINGS[@]} -gt 0 ]]; then
  echo "Doc companion check results:"
  echo ""
  for warning in "${WARNINGS[@]}"; do
    echo "  $warning"
  done
fi

if [[ "$FAILED" -eq 1 ]]; then
  echo "✗ Doc companion check failed. See above for required companion files."
  echo ""
  echo "A companion file must contain substantive changes — not just whitespace or"
  echo "a date bump. Reviewers are expected to verify this."
  exit 1
else
  echo "✓ Doc companion check passed."
  exit 0
fi
