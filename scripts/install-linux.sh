#!/bin/bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
PREFIX="$HOME/.local"
for arg in "$@"; do
  case "$arg" in
    --prefix=*) PREFIX=${arg#--prefix=} ;;
    *) echo "Unknown argument: $arg" >&2; exit 1 ;;
  esac
done

# Build dependencies are listed in .github/linux-deps.txt.
bash "$ROOT/scripts/package-linux.sh" install "$PREFIX"
update-desktop-database "$PREFIX/share/applications"
gtk-update-icon-cache -t "$PREFIX/share/icons/hicolor/"
