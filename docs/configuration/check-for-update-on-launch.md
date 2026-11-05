# Check for Update on Launch

Controls whether Galloy will check the Galloy repository on launch for a new version of Galloy.  When a new version is found a dot indicator will appear on the user menu button and a menu item to open the release webpage will be added to the user menu.

This can be useful if you would rather rely on a package manager.

## `check_for_update_on_launch`

::: warning
`check_for_update_on_launch` is a root key, so it must be placed before any section.
:::

::: info
If configured, the [default proxy](./proxy) will be used to check for update.
:::

```toml
# Type: boolean
# Values: true, false
# Default: true

check_for_update_on_launch = true
```

Galloy checks its own GitHub repository. GitHub's latest-release endpoint
excludes prereleases, so current previews are available from the
[Galloy releases page](https://github.com/solid-pixel/galloy/releases).
