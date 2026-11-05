# Portable mode

Use `HALLOY_PORTABLE_DIR` to choose a separate Galloy configuration and data folder.
The variable keeps its upstream name for compatibility. Create the directory
before launching the app.

For a packaged macOS application:

```sh
mkdir -p "$HOME/Galloy-Portable"
HALLOY_PORTABLE_DIR="$HOME/Galloy-Portable" /Applications/Galloy.app/Contents/MacOS/halloy
```

For a Linux installation:

```sh
mkdir -p "$HOME/Galloy-Portable"
HALLOY_PORTABLE_DIR="$HOME/Galloy-Portable" galloy
```

Galloy uses the selected directory for both configuration and state, including
history. Its preview cache still uses the normal platform cache location.

Alternatively, place `config.toml` beside the actual executable. On macOS that
is inside `Galloy.app/Contents/MacOS`, rather than beside the application bundle.
Use an external directory through the environment variable to keep portable data
separate from an app bundle that will be replaced during upgrades.

Do not run two clients against the same data directory. See
[Packaging and identity](./galloy-packaging.md) for compatibility details.
