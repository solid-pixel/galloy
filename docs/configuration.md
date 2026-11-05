# Configuration

In Galloy, **Settings** provides graphical editing across the supported configuration areas.
See the [Settings GUI guide](./guides/settings-gui.md).

Galloy uses a TOML file for configuration called `config.toml`.  The specification for the configuration file format ([TOML](https://toml.io/)) can be found at [https://toml.io/](https://toml.io/).

A default file is created in the [configuration directory](#directory) when you launch Galloy for the first time.

::: tip
Settings applies saved changes directly. After editing the file in another editor,
reload it from the user menu, [keyboard shortcut](./configuration/keyboard.md), or
the command bar. Some startup options still require a restart.
:::

See the following guides for example configurations:
- [Example Server Configurations](./guides/example-server-configurations.md)
- [Multiple Servers](./guides/multiple-servers.md)
- [Connect with soju](./guides/connect-with-soju.md)
- [Connect with ZNC](./guides/connect-with-znc.md)

Galloy keeps Halloy's default folder names for compatibility. Outside Flatpak,
quit one client before using the other with shared data. See
[Packaging and identity](./guides/galloy-packaging.md).

## Directory

The location of the configuration directory depends on your system:

* Windows: `%AppData%\halloy`
* macOS: `~/Library/Application Support/halloy` or `$HOME/.config/halloy`
* Linux: `$XDG_CONFIG_HOME/halloy`, `$HOME/.config/halloy` or `$HOME/.var/app/io.github.solid_pixel.Galloy/config/halloy` (Flatpak)

::: tip
For Flatpak users that want to use the `$HOME` paths for configuration, see
[Flatpak tips](./guides/flatpak-tips#configuration-in-home-paths).
:::
