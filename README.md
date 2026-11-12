# Homebrew tap for toke

This is the official Homebrew tap for the toke programming language tools.

> toke: a compiled language designed for LLM code generation, with a small grammar, one
> canonical form and compiler verification.

The one-liner above is reproduced word for word from the canonical description,
[`docs/about/canonical.md`](https://github.com/karwalski/toke/blob/main/docs/about/canonical.md)
in the toke repository. Every number published about toke comes from
[`docs/metrics-baseline.md`](https://github.com/karwalski/toke/blob/main/docs/metrics-baseline.md)
and nowhere else.

## Status

**Not installable yet.** The formulae carry placeholder checksums until the
release artefacts they download are published (toke story 132.27); until
then `brew install` fails its checksum check. Build from source meanwhile:
see the compiler and framework repositories linked below.

The formulae pin `version "3.0.0"` for both `tkc` and `ooke`. toke's current
version is 3.1.0, and ooke 3.0.0 is still a release candidate (`3.0.0-rc.2`),
so both pins change when the release artefacts are published.

## Installation

```sh
brew tap karwalski/toke
brew install tkc
brew install ooke
```

## What it installs

- `tkc` -- the toke compiler binary, plus the standard library interfaces
  (`stdlib/*.tki`, `stdlib/vendor/`) and runtime sources (`src/stdlib/`) every
  program links, installed under `libexec`. tkc runs the clang found where the
  release was built; if builds fail with E9027, set `TKC_CC` (the formula's caveats
  say how)
- `ooke` -- toke's web framework and static site generator, for building toke-based websites

## Updating

```sh
brew update
brew upgrade tkc
brew upgrade ooke
```

## Supported platforms

- macOS (Apple Silicon / arm64)
- macOS (Intel / x86_64)
- Linux (x86_64)
- Linux (arm64)

## Links

- Language website: https://tokelang.dev
- Compiler source: https://github.com/karwalski/toke
- Canonical description of toke: https://github.com/karwalski/toke/blob/main/docs/about/canonical.md
- Web framework source: https://github.com/karwalski/ooke

## Licence

The formulae in this tap are MIT-licensed; see [LICENSE](LICENSE). The software
they install carries its own licence: `tkc` is Apache-2.0, with its standard library
under MIT (see [LICENSING.md](https://github.com/karwalski/toke/blob/main/LICENSING.md)),
and `ooke` is MIT.
