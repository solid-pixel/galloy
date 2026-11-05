# Storing Passwords in the System Keyring

The system keyring keeps passwords out of your configuration file.

Set a keyring option to `true`:

```toml
[servers.liberachat]
password_keyring = true
```

If the entry is missing, Galloy asks for the password. Galloy then saves it in
the system keyring.

Use only one source for each password. For example, do not set both `password`
and `password_keyring`.

## Entry names

The value `true` uses an automatic entry name. You can use your own name
instead:

```toml
[servers.liberachat]
password_keyring = "my-irc-password"
```

## System support

Galloy uses these system stores:

- macOS Keychain
- Windows Credential Manager
- Secret Service on Linux and FreeBSD

On Windows, entry names are not case-sensitive.

To replace a saved password, remove it from the system store. Galloy asks for
it again when the configuration is loaded.

### Access in Flatpak

:::tip
To access keyrings while running in Flatpak, you will need to manually grant your install of
Galloy access to the system keyring. You can do this by running:


```bash
flatpak override --user --talk-name=org.freedesktop.secrets io.github.solid_pixel.Galloy
```
:::

For more Flatpak tips, see this [guide](./flatpak-tips#keyring-access).
