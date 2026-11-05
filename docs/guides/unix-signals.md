# Unix signals

Galloy supports Unix signals to reload configuration without restarting.

## SIGUSR1

Sending `SIGUSR1` reloads the configuration file. Find Galloy's process ID in
Activity Monitor or `ps`, set `GALLOY_PID` to that ID, then run:

```sh
kill -USR1 "$GALLOY_PID"
```

Linux packages name the executable `galloy`. The macOS bundle retains the
internal executable name `halloy`, so use the process ID to select Galloy
without signaling a separate Halloy installation.

The user menu, command bar, and keyboard shortcut can also reload configuration.
Settings applies saved changes directly.
