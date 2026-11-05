# Installing Galloy

Galloy is an unofficial, AI-assisted Halloy fork. Download packages from
[Galloy releases](https://github.com/solid-pixel/galloy/releases).

## macOS preview

The current preview is a universal build for Apple silicon and Intel.

1. Back up your existing `config.toml` and quit Galloy or Halloy if either is running.
2. Download the Galloy disk image and compare its SHA-256 hash with the release's checksums.
3. Open the disk image and drag **Galloy** into **Applications**.
4. Launch Galloy and open **Settings** with **⌘,**.

The preview is signed ad hoc and is not notarized by Apple. macOS may block its
first launch. Follow [Apple's opening instructions](https://support.apple.com/en-us/102445)
and the notes for the release you downloaded.

Galloy uses Halloy's existing configuration and history paths. See
[configuration](./configuration.md) and [portable mode](./guides/portable-mode.md)
for shared or isolated data.

## Windows and Linux

Windows installers and Linux packages can be built from this fork. See
[Packaging and identity](./guides/galloy-packaging.md). These packages have their
own Galloy application identities and can be installed alongside Halloy.
Quit one client before using the other with their shared default data.

Current Galloy prereleases distribute macOS binaries. Halloy packages in
Homebrew, MacPorts, Winget, Snap, or Flathub are upstream Halloy packages and
do not include Galloy's Settings GUI.

## Build from source

Install Rust and Git, plus the platform dependencies described in the
[packaging guide](./guides/galloy-packaging.md), then run:

```sh
git clone https://github.com/solid-pixel/galloy.git
cd galloy
cargo run --profile ci
```

The Cargo binary is still named `halloy` internally. Windows and Linux packaging
installs it as `galloy.exe` and `galloy`, respectively.
