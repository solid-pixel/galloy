#!/bin/bash
set -euo pipefail

TAG=${1:?Usage: bash scripts/package-macos-preview.sh YYYY.MM-gui-preview.N}
if [[ ! "$TAG" =~ ^([0-9]{4}\.[0-9]{2})-gui-preview\.([1-9][0-9]*)$ ]]; then
  echo "Invalid preview tag: $TAG" >&2
  exit 1
fi
VERSION=${BASH_REMATCH[1]}
PREVIEW=${BASH_REMATCH[2]}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
if [[ "$VERSION" != "$(cat VERSION)" ]]; then
  echo "The preview tag must match VERSION." >&2
  exit 1
fi
REVISION=${GITHUB_SHA:-$(git rev-parse HEAD)}
if [[ ! "$REVISION" =~ ^[0-9a-f]{40}$ ]]; then
  echo "A full source commit is required." >&2
  exit 1
fi
BUILD_DIR="$ROOT/target/packaging"
OUTPUT="$BUILD_DIR/galloy-preview/$TAG"
STAGE=$(mktemp -d "$BUILD_DIR/galloy-preview-stage.XXXXXXXX")
trap 'rm -rf "$STAGE"' EXIT
APP="$STAGE/image/Galloy.app"
mkdir -p "$STAGE/image" "$OUTPUT"
ditto "$BUILD_DIR/galloy-macos/Galloy.app" "$APP"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $VERSION.$PREVIEW" "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :LSMinimumSystemVersion 11.0' "$APP/Contents/Info.plist" 2>/dev/null ||
  /usr/libexec/PlistBuddy -c 'Add :LSMinimumSystemVersion string 11.0' "$APP/Contents/Info.plist"
codesign --force --sign - "$APP"
codesign --verify --deep --strict --all-architectures "$APP"
ARCHS=$(lipo -archs "$APP/Contents/MacOS/halloy")
[[ " $ARCHS " == *' arm64 '* && " $ARCHS " == *' x86_64 '* ]]
APP_VERSION=$("$APP/Contents/MacOS/halloy" --version)
[[ "$APP_VERSION" == "galloy $VERSION (${REVISION:0:8})" ]]
cp LICENSE "$STAGE/image/LICENSE.txt"
ln -s /Applications "$STAGE/image/Applications"
DMG="Galloy-$TAG-macOS-universal.dmg"
hdiutil create "$STAGE/$DMG" -volname Galloy -fs HFS+ -srcfolder "$STAGE/image" -format UDZO
hdiutil verify "$STAGE/$DMG"
mv "$STAGE/$DMG" "$OUTPUT/$DMG"
printf '%s\n' "Created $OUTPUT/$DMG"
