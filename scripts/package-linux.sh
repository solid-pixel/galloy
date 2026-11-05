#!/bin/bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"
APP_ID="io.github.solid_pixel.Galloy"
PROFILE=${PROFILE:-packaging}
VERSION=$(cat VERSION)
ARCH=${ARCH:-$(uname -m)}
RELEASE_DIR="$ROOT/target/$PROFILE"
BINARY="$RELEASE_DIR/halloy"
ARCHIVE_NAME="galloy-$VERSION-$ARCH-linux.tar.gz"
if [[ "$VERSION" == "$(cat NIGHTLY)" ]]; then
  ARCHIVE_NAME="galloy-nightly-$ARCH-linux.tar.gz"
fi
ARCHIVE_PATH="$RELEASE_DIR/$ARCHIVE_NAME"

install_files() {
  local prefix=$1
  cargo build --locked --profile "$PROFILE"
  install -Dm755 "$BINARY" "$prefix/bin/galloy"
  install -Dm644 "assets/linux/$APP_ID.appdata.xml" "$prefix/share/metainfo/$APP_ID.appdata.xml"
  install -Dm644 "assets/linux/$APP_ID.desktop" "$prefix/share/applications/$APP_ID.desktop"
  mkdir -p "$prefix/share/icons"
  cp -R assets/linux/icons/. "$prefix/share/icons/"
}

case "${1:-}" in
  package)
    mkdir -p "$RELEASE_DIR"
    STAGE=$(mktemp -d "$RELEASE_DIR/galloy-linux-stage.XXXXXXXX")
    trap 'rm -rf "$STAGE"' EXIT
    install_files "$STAGE"
    install -Dm644 LICENSE "$STAGE/share/licenses/galloy/LICENSE"
    tar -czf "$ARCHIVE_PATH" -C "$STAGE" .
    echo "Packaged archive: $ARCHIVE_PATH"
    ;;
  install) install_files "${2:?An installation prefix is required.}" ;;
  archive_name) echo "$ARCHIVE_NAME" ;;
  archive_path) echo "$ARCHIVE_PATH" ;;
  *) echo "Usage: $0 {package|install PREFIX|archive_name|archive_path}" >&2; exit 1 ;;
esac
