#!/usr/bin/env bash
# log-command.sh
# PostToolUse hook — logs all bash commands Claude executes.
# Wired in .claude/settings.json under hooks.PostToolUse.
#
# This produces an audit trail of agent commands for session review.
# It is a derivative record, not a canonical one.
# Do not rely on this log as the authoritative account of what changed —
# that belongs in commits, PRs, and migration records.

LOG_FILE=".claude/command-log.txt"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# The command that was run is passed via CLAUDE_TOOL_INPUT env var (if available)
# or captured from the hook context. Adjust based on your Claude Code version.
COMMAND="${CLAUDE_TOOL_INPUT:-[command not captured]}"

echo "[$TIMESTAMP] $COMMAND" >> "$LOG_FILE"
