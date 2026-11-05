# Building for Flatpak

Galloy's local Flatpak manifest is
`assets/flatpak/io.github.solid_pixel.Galloy.json`.
It uses its own sandbox identity and installs the executable as `galloy`.
Galloy is not published on Flathub.

## Requirements

Install [Flatpak Builder](https://docs.flatpak.org/en/latest/flatpak-builder.html)
and the dependencies it requires, plus Python 3.

Clone [Galloy](https://github.com/solid-pixel/galloy) and run from the repository root:

```sh
bash scripts/flatpak.sh
```

The script installs the required user runtimes, generates Cargo dependency
sources from `Cargo.lock`, and builds and installs the local Galloy Flatpak.
It uses the upstream
[Flatpak Cargo generator](https://github.com/flatpak/flatpak-builder-tools/tree/master/cargo).

Run the resulting application with:

```sh
flatpak run io.github.solid_pixel.Galloy
```

## Configuration and verification

The new sandbox does not automatically use an existing Halloy Flatpak's data.
See [Flatpak tips](./flatpak-tips.md) for paths and optional access to shared data.

The packaging checks in this repository validate manifest references and Linux
package contents. They do not establish a complete Flatpak runtime build or a
Flathub publication. See [Packaging and identity](./galloy-packaging.md).
