#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/.claude

cat > ~/.claude/CLAUDE.md << EOF
## Personal preferences

Follow the CLAUDE.md and design guidelines from the local claude-config clone.

@${SCRIPT_DIR}/docs/code-design-guidelines.md

$(cat "${SCRIPT_DIR}/CLAUDE.md")
EOF

echo "~/.claude/CLAUDE.md written, pointing at ${SCRIPT_DIR}"
