# Command line

## Galloy

Galloy accepts a small set of command-line arguments.

| Argument | Description |
| --- | --- |
| `--version`, `-V` | Print the version and exit. Must be the first argument. |
| URL | Open an IRC connection or a shared Halloy theme link. See [URL schemes](./url-schemes.md). |

There is no `--help`, `-h`, or `-?` flag. Unknown arguments are ignored and Galloy
starts normally. Configuration and data directories are selected through
[portable mode](./portable-mode.md), not command-line flags.

Windows and Linux packages install the command as `galloy.exe` and `galloy`.
For example, on Linux:

```sh
galloy --version
galloy ircs://irc.libera.chat/#halloy
```

The internal Cargo binary is still `halloy`. On macOS it is inside
`Galloy.app/Contents/MacOS/halloy`.

## Windows installer

The Galloy Windows installer is built with
[Inno Setup](https://jrsoftware.org/isinfo.php). Run the installer with `/HELP`
or `/?` to list its options.

| Argument | Description |
| --- | --- |
| `/SILENT` | Hide the wizard and show installation progress. |
| `/VERYSILENT` | Hide the wizard and installation progress. |
| `/DIR="C:\Apps\Galloy"` | Set an absolute installation directory. |
| `/TASKS="desktopicon"` | Create a desktop shortcut. |

See the [Inno Setup command-line reference](https://jrsoftware.org/ishelp/topic_setupcmdline.htm)
for the complete list.
