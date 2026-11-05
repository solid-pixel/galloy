# Galloy packaging and application identity

Galloy is an unofficial, AI-assisted fork of Halloy. The packaged preview is
available from [Galloy releases](https://github.com/solid-pixel/galloy/releases).
Upstream Halloy packages do not include Galloy's Settings GUI.

## Platform identity

| Platform | Installed application | Application identifier |
| --- | --- | --- |
| macOS | `Galloy.app` | `com.solid-pixel.galloy` |
| Windows | `Galloy/galloy.exe` | `io.github.solid_pixel.Galloy` |
| Linux | `bin/galloy` | `io.github.solid_pixel.Galloy` |

The Windows installer has a separate uninstall identifier and registers its own
`Galloy.IRC`, `Galloy.IRCS`, and `Galloy.HALLOY` handlers. It offers Galloy in
Windows default-app settings without replacing existing protocol defaults.
Installing or uninstalling Galloy does not remove Halloy.

Linux launchers, AppStream metadata, and icon names use Galloy's identifier.
The installation script installs `galloy` without replacing an existing `halloy`
binary. The Flatpak manifest uses `io.github.solid_pixel.Galloy`, which gives it
its own sandbox. It is a local development manifest, not a Flathub publication.

## Configuration compatibility

Outside Flatpak, the apps share Halloy's default configuration, theme, and history
locations. Quit one before using the other with that shared data. Back up your
configuration before trying a preview.

The `HALLOY_PORTABLE_DIR` variable, `chat.halloy` system keyring service, and
`halloy://` theme links keep their existing names for compatibility. The Cargo
binary name remains `halloy` internally. Packaging installs it under Galloy's
name on Windows and Linux. Galloy uses separate runtime IPC files, so its URL
handling does not attach to Halloy's process.

A new Galloy Flatpak cannot automatically read an existing Halloy Flatpak's
sandbox. Copy a backed-up configuration into the new sandbox deliberately if
you want to reuse it. Filesystem and keyring portal permissions still apply.

## Building

For macOS, follow the source archive instructions attached to the preview.
The preview workflow builds both architectures and creates a draft release for
native verification before publication. Current previews are signed ad hoc and
are not notarized by Apple.

On Linux, install the build dependencies listed in `.github/linux-deps.txt`,
then run:

```sh
bash scripts/package-linux.sh package
# Or install in your user directory:
bash scripts/install-linux.sh --prefix="$HOME/.local"
```

On Windows, install Rust, the MSVC build tools, and Inno Setup 6, then run from
Git Bash:

```sh
bash scripts/build-windows.sh
ISCC='/c/Program Files (x86)/Inno Setup 6/ISCC.exe' bash scripts/build-windows-installer.sh
```

The Windows and Linux packaging checks run in CI. Windows checks compile the
installer, install and uninstall it on a disposable runner, and verify that
Halloy fixtures and existing URL registrations survive. Linux checks validate
metadata, archive contents, and installation beside Halloy fixtures. These
checks do not establish interactive Windows/Linux UI behavior or a complete
Flatpak build.
