# Flatpak tips

These tips apply to Galloy's [local Flatpak build](./flatpaks.md), whose application
ID is `io.github.solid_pixel.Galloy`. Galloy is not published on Flathub.

## Wayland and X11

To try X11 for one launch:

```sh
flatpak run --nosocket=wayland io.github.solid_pixel.Galloy
```

To persist that choice:

```sh
flatpak override --user --nosocket=wayland io.github.solid_pixel.Galloy
```

## Keyring access

To allow the sandbox to talk to the system Secret Service:

```sh
flatpak override --user --talk-name=org.freedesktop.secrets io.github.solid_pixel.Galloy
```

Galloy retains the `chat.halloy` keyring service name for configuration compatibility.
See [Storing passwords in the system keyring](./keyring.md).

## Downloads access {#filesystem-access-for-file-transfers}

To allow transfers into your Downloads folder:

```sh
flatpak override --user --filesystem=~/Downloads io.github.solid_pixel.Galloy
```

## Configuration in home paths

The default sandbox locations are:

- Configuration: `~/.var/app/io.github.solid_pixel.Galloy/config/halloy`
- History and data: `~/.var/app/io.github.solid_pixel.Galloy/data/halloy`
- Cache: `~/.var/app/io.github.solid_pixel.Galloy/cache/halloy`

The `halloy` subdirectory names are retained for compatibility. Galloy's sandbox
is separate from an existing Halloy Flatpak's sandbox.

Back up configuration and history before copying them between installations.
For explicit access to the normal home locations, grant only the paths needed:

```sh
flatpak override --user \
  --filesystem=~/.config/halloy:create \
  --filesystem=~/.local/share/halloy:create \
  --filesystem=~/.cache/halloy:create \
  io.github.solid_pixel.Galloy
```

These permissions do not themselves migrate or redirect sandbox data. Copy a
backed-up configuration deliberately, or use
[portable mode](./portable-mode.md) with a directory the sandbox can access.
Quit one client before using another with shared configuration and history.
