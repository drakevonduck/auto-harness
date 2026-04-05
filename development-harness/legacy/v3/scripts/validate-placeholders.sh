#!/usr/bin/env bash
# validate-placeholders.sh
# Scans tracked files for unresolved [[PLACEHOLDER]] markers.
# Exits 0 if clean, exits 1 with a list of findings if any remain.
#
# Usage:
#   bash scripts/validate-placeholders.sh
#
# Called by CI in .github/workflows/harness.yml
# Bootstrap is not complete until this exits 0.

set -euo pipefail

PLACEHOLDER_PATTERN='\[\[[A-Z0-9_]+\]\]'

# Files and directories to exclude from scanning.
# Add paths that intentionally contain placeholder syntax (e.g., documentation
# that defines the convention itself).
EXCLUDE_PATHS=(
  "HARNESS.md"
  "profiles/"
  "scripts/validate-placeholders.sh"
  "docs/adr/ADR-TEMPLATE.md"
)

# Build the exclude args for grep
EXCLUDE_ARGS=()
for path in "${EXCLUDE_PATHS[@]}"; do
  EXCLUDE_ARGS+=(--exclude="$path")
  EXCLUDE_ARGS+=(--exclude-dir="${path%/}")
done

# Optionally respect a .placeholder-ignore file
IGNORE_FILE=".placeholder-ignore"
if [[ -f "$IGNORE_FILE" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    EXCLUDE_ARGS+=(--exclude="$line")
    EXCLUDE_ARGS+=(--exclude-dir="${line%/}")
  done < "$IGNORE_FILE"
fi

echo "Scanning for unresolved placeholders..."

# Run grep across git-tracked files
FINDINGS=$(git ls-files | xargs grep -rn --include="*.md" --include="*.json" \
  --include="*.yml" --include="*.yaml" --include="*.sh" --include="*.ts" \
  --include="*.tsx" --include="*.js" --include="*.env*" --include="*.toml" \
  "${EXCLUDE_ARGS[@]}" \
  -E "$PLACEHOLDER_PATTERN" 2>/dev/null || true)

# Filter out excluded paths from findings
for path in "${EXCLUDE_PATHS[@]}"; do
  FINDINGS=$(echo "$FINDINGS" | grep -v "^$path" || true)
done

if [[ -z "$FINDINGS" ]]; then
  echo "✓ No unresolved placeholders found."
  exit 0
else
  echo ""
  echo "✗ Unresolved placeholders found. Bootstrap is not complete."
  echo ""
  echo "$FINDINGS"
  echo ""
  echo "Resolve all [[PLACEHOLDER_NAME]] values and re-run this script."
  echo "To exclude a file from scanning, add it to .placeholder-ignore"
  exit 1
fi
