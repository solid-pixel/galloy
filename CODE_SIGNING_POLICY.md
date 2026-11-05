# Code signing policy

Galloy is an unofficial, AI-assisted fork of Halloy. Its packages have a separate
application identity and are maintained independently of upstream releases.

## macOS previews

Current Galloy macOS previews are signed ad hoc. They do not carry an Apple
Developer ID signature and are not notarized by Apple. macOS may block the first
launch; follow the opening instructions linked in the release notes.

An ad hoc signature checks package integrity. It does not establish the
publisher's identity. Compare downloads with the SHA-256 checksums attached to
the same [Galloy release](https://github.com/solid-pixel/galloy/releases).

## Windows and Linux

The current prereleases distribute macOS binaries. Windows installers and Linux
packages can be built from source and are checked in CI. Galloy does not claim
an Authenticode signing certificate or a SignPath signing arrangement for these
builds. Check each release's notes for the artifacts and verification it provides.

Halloy's upstream signing arrangements do not apply to Galloy. The inherited
upstream release and signing workflows are disabled for this fork.
