# Uninstalling Galloy

Quit Galloy before uninstalling it. Removing the application does not remove its
configuration or chat history.

## macOS

Move **Galloy.app** from Applications to the Trash.

## Windows

If you built and installed Galloy's Windows installer, uninstall **Galloy** from
Windows Settings. It removes Galloy's own files and URL registrations and keeps
an existing Halloy installation.

For a portable build, remove the Galloy executable from its install directory.
Keep a backup of any configuration or history stored beside it.

## Linux

For a source installation, remove Galloy's installed files from the prefix you
selected. The default prefix is `~/.local`:

- `bin/galloy`
- `share/applications/io.github.solid_pixel.Galloy.desktop`
- `share/metainfo/io.github.solid_pixel.Galloy.appdata.xml`
- `share/icons/hicolor/*/apps/io.github.solid_pixel.Galloy.png`
- `share/licenses/galloy/LICENSE` if installed from an archive

Remove only these Galloy files. Shared icon directories may contain other apps.
For a local Flatpak build, use:

```sh
flatpak uninstall io.github.solid_pixel.Galloy
```

## Configuration and history

Galloy shares Halloy's default data locations outside Flatpak. Removing those
folders also affects Halloy. Back them up and keep them if you use either client.

Configuration is stored in:

- Windows: `%AppData%\halloy`
- macOS: `~/Library/Application Support/halloy` or `$HOME/.config/halloy`
- Linux: `$XDG_CONFIG_HOME/halloy` or `$HOME/.config/halloy`

See [configuration](./configuration.md#directory) for path selection,
[portable mode](./guides/portable-mode.md) for an explicitly chosen data folder,
and [Flatpak tips](./guides/flatpak-tips.md) for sandbox locations.
