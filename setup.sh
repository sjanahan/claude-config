#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GIT_DIR="$(dirname "${SCRIPT_DIR}")"

mkdir -p ~/.claude

cat > ~/.claude/CLAUDE.md << EOF
## Personal preferences

Follow the CLAUDE.md and design guidelines from the local claude-config clone.

@${SCRIPT_DIR}/docs/code-design-guidelines.md

$(cat "${SCRIPT_DIR}/CLAUDE.md")
EOF

echo "~/.claude/CLAUDE.md written, pointing at ${SCRIPT_DIR}"

if [ "$1" = "--work" ]; then
  JAY_DOCS="${GIT_DIR}/jay-docs"
  if [ ! -d "${JAY_DOCS}" ]; then
    echo "Error: ${JAY_DOCS} not found. Clone jay-docs first."
    exit 1
  fi
  ln -sf "${JAY_DOCS}/CLAUDE.md" "${GIT_DIR}/CLAUDE.md"
  echo "Symlinked ${GIT_DIR}/CLAUDE.md -> jay-docs/CLAUDE.md"
fi
