#!/usr/bin/env bash
# system-design-coach installer (macOS / Linux)
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/sayanmndl/system-design-coach/main/install.sh | bash
#
# Environment overrides:
#   SDC_REPO   GitHub owner/repo to fetch from (default: sayanmndl/system-design-coach)
#   SDC_REF    Branch or tag                   (default: main)
#   SDC_DEST   Install path                    (default: ~/.claude/skills/system-design-coach)

set -euo pipefail

REPO="${SDC_REPO:-sayanmndl/system-design-coach}"
REF="${SDC_REF:-main}"
DEST="${SDC_DEST:-$HOME/.claude/skills/system-design-coach}"

command -v curl >/dev/null 2>&1 || { echo "error: curl is required" >&2; exit 1; }
command -v tar  >/dev/null 2>&1 || { echo "error: tar is required"  >&2; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "==> Fetching $REPO@$REF"
curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$REF" \
  | tar -xz -C "$TMP" --strip-components=1

SRC="$TMP/skills/system-design-coach"
if [[ ! -d "$SRC" ]]; then
  echo "error: skills/system-design-coach not found in $REPO@$REF" >&2
  exit 1
fi

mkdir -p "$(dirname "$DEST")"

if [[ -e "$DEST" ]]; then
  BACKUP="$DEST.bak.$(date +%s)"
  echo "==> Existing install found, backing up to $BACKUP"
  mv "$DEST" "$BACKUP"
fi

mv "$SRC" "$DEST"

echo "==> Installed to $DEST"
echo
echo "Open a new Claude Code session and try:"
echo "  \"design Twitter timeline\""
echo "  \"design a feature store\""
echo "  \"LLD a parking lot\""
