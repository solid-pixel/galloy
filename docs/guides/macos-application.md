# Building for macOS

Build Galloy's universal macOS application from this fork. For packaged previews,
see [Installation](../installation.md).

## Prerequisites

- macOS 11.0 or later
- Rust, including the toolchain documented in the preview's source archive
- Xcode Command Line Tools

## Build the application

```sh
git clone https://github.com/solid-pixel/galloy.git
cd galloy
bash -e scripts/build-macos.sh
```

The script builds both `x86_64-apple-darwin` and `aarch64-apple-darwin`, combines
them with `lipo`, and copies the binary and resources into:

```text
target/packaging/galloy-macos/Galloy.app
```

The source bundle template remains named `assets/macos/Halloy.app`, and its
internal executable remains `halloy`. The installed application is **Galloy**,
with its own macOS bundle identifier.

## Package a preview

Run `scripts/package-macos-preview.sh` with a new preview tag matching `VERSION`,
following the instructions in the source archive for the release you are building.
The script signs the app ad hoc and verifies the universal disk image.
It does not provide Apple notarization or a Developer ID signature.

See [Packaging and identity](./galloy-packaging.md) for the release workflow and
platform verification boundaries.
