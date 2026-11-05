# Contributing to Galloy

Galloy is an unofficial, AI-assisted fork of Halloy. Contributions to this fork
belong in the [Galloy repository](https://github.com/solid-pixel/galloy).

## Bugs and feature requests

Search the [issue tracker](https://github.com/solid-pixel/galloy/issues) before
opening an issue. For bugs, include the Galloy version, commit, operating system,
reproduction steps, expected behavior, and what happened. Remove private details.
Report suspected security vulnerabilities through
[private reporting](https://github.com/solid-pixel/galloy/security/advisories/new).

Discuss substantial features in a Galloy issue before implementing them.

## Pull requests

Open pull requests on [this fork](https://github.com/solid-pixel/galloy/pulls).
Keep changes focused, explain the behavior they affect, and describe how they
were tested. Preserve the shared configuration format, existing settings,
comments, and credential references.

For Settings changes, follow the compact grouped design and update the
[settings guide](./guides/settings-gui.md) and
[coverage checklist](./guides/settings-gui-coverage.md) when behavior or fields change.
Verify visible changes in the running app.

With the required toolchains and dependencies installed, run:

```sh
cargo +nightly fmt --all -- --check
cargo clippy --locked --profile ci --workspace --all-targets -- -D warnings
cargo test --locked --profile ci --workspace
```

CI also checks platform builds and Windows/Linux packaging. See
[Packaging and identity](./guides/galloy-packaging.md).

## AI assistance

Galloy is developed with AI assistance. Contributors are responsible for
understanding, reviewing, and testing what they submit. Describe substantial
AI assistance so reviewers can assess the work with the right context.

Halloy upstream has its own
[contribution policy](https://halloy.chat/contributing). Follow that policy
when contributing to Halloy itself.

## Documentation

Edit the Markdown files in this fork's `docs` directory. Build them with:

```sh
cd docs
bun install --frozen-lockfile
bun run docs:build
```

Keep Galloy's behavior and distribution status distinct from upstream Halloy.
Retain upstream attribution and accurate links to shared services and formats.
