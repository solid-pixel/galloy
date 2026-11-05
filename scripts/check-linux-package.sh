#!/bin/bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
export PROFILE=${PROFILE:-ci}
APP_ID="io.github.solid_pixel.Galloy"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
PREFIX="$WORK/install prefix"
mkdir -p "$PREFIX/bin" "$PREFIX/share/applications" "$PREFIX/share/icons/hicolor/32x32/apps"
printf 'upstream binary\n' > "$PREFIX/bin/halloy"
printf 'upstream launcher\n' > "$PREFIX/share/applications/org.squidowl.halloy.desktop"
printf 'upstream icon\n' > "$PREFIX/share/icons/hicolor/32x32/apps/org.squidowl.halloy.png"

bash scripts/package-linux.sh install "$PREFIX"
[[ "$(cat "$PREFIX/bin/halloy")" == 'upstream binary' ]]
[[ "$(cat "$PREFIX/share/applications/org.squidowl.halloy.desktop")" == 'upstream launcher' ]]
[[ "$(cat "$PREFIX/share/icons/hicolor/32x32/apps/org.squidowl.halloy.png")" == 'upstream icon' ]]
[[ "$("$PREFIX/bin/galloy" --version)" == galloy\ * ]]
desktop-file-validate "$PREFIX/share/applications/$APP_ID.desktop"
appstreamcli validate --no-net "$PREFIX/share/metainfo/$APP_ID.appdata.xml"

bash scripts/package-linux.sh package
mkdir "$WORK/archive"
tar -xzf "$(bash scripts/package-linux.sh archive_path)" -C "$WORK/archive"
test -x "$WORK/archive/bin/galloy"
test -f "$WORK/archive/share/licenses/galloy/LICENSE"
test -f "$WORK/archive/share/applications/$APP_ID.desktop"
test ! -e "$WORK/archive/bin/halloy"
test ! -e "$WORK/archive/share/applications/org.squidowl.halloy.desktop"
python3 - <<'PYTHON'
import json
from pathlib import Path
manifest = json.loads(Path('assets/flatpak/io.github.solid_pixel.Galloy.json').read_text())
assert manifest['app-id'] == 'io.github.solid_pixel.Galloy'
assert manifest['command'] == 'galloy'
for command in manifest['modules'][0]['build-commands']:
    if command.startswith('install -Dm644'):
        assert Path(command.split()[2]).is_file(), command
print('Flatpak metadata references verified (no Flatpak runtime build).')
PYTHON
printf 'Linux archive and install coexistence checks passed.\n'
