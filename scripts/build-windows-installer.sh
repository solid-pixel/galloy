#!/bin/bash
set -euo pipefail

ISS_FILE="inno/galloy.iss"
GALLOY_VERSION=$(grep -q '\..*\.' VERSION && cat VERSION || echo "$(cat VERSION).0")
PROFILE=${PROFILE:-packaging}
NIGHTLY=0

find_iscc() {
    if [ -n "${ISCC:-}" ]; then
        echo "$ISCC"
    elif command -v iscc &> /dev/null; then
        command -v iscc
    fi
}

for arg in "$@"; do
    case "$arg" in
        --nightly)
            NIGHTLY=1
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            exit 1
            ;;
    esac
done

ISCC_BIN="$(find_iscc)"

if [ -z "$ISCC_BIN" ]; then
    echo "Could not find ISCC.exe. Install Inno Setup 6 or set ISCC to the compiler path." >&2
    exit 1
fi

export GALLOY_VERSION
if command -v cygpath &> /dev/null; then
    GALLOY_SOURCE_DIR=$(cygpath -w "$PWD")
    GALLOY_OUTPUT_DIR=$(cygpath -w "$PWD/target/$PROFILE")
else
    GALLOY_SOURCE_DIR="$PWD"
    GALLOY_OUTPUT_DIR="$PWD/target/$PROFILE"
fi
export GALLOY_SOURCE_DIR GALLOY_OUTPUT_DIR

if [ "$NIGHTLY" = "1" ]; then
    DEFAULT_OUTPUT_BASE_FILENAME="galloy-nightly-installer"
else
    DEFAULT_OUTPUT_BASE_FILENAME="galloy-installer"
fi
export GALLOY_OUTPUT_BASE_FILENAME="${GALLOY_OUTPUT_BASE_FILENAME:-$DEFAULT_OUTPUT_BASE_FILENAME}"

# build the installer
"$ISCC_BIN" "$ISS_FILE"
