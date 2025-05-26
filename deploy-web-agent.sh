#!/usr/bin/env bash
set -euo pipefail

# Build the web agent assets and push changes to GitHub

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Build the orchestrator assets
node build-web-agent.js

# Stage all changes (honors .gitignore)
git add -A

# Commit if there is anything to commit
if ! git diff --cached --quiet; then
  git commit -m "chore: build web agent"
else
  echo "No changes to commit"
fi

# Pull latest and push to current branch
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
git pull --rebase origin "$CURRENT_BRANCH"
git push origin "$CURRENT_BRANCH"

echo "Deployment complete."
