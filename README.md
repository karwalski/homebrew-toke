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

The formulae install the published releases: **tkc 3.2.0** (toke v3.2.0, 2026-11-15) and
**ooke 3.0.0** (2026-11-15), each pinned to the sha256 values in its release's
`checksums.txt`.

**Requirements.** macOS 15 (Sequoia) or later: the release binaries are built on GitHub's
macos-15 images. On Linux the binaries need glibc 2.38 or later (Ubuntu 24.04+, Debian 13+,
Fedora 39+); older systems can build from source (see the repositories linked below). tkc
compiles programs with clang; on macOS that is the Command Line Tools clang
(`xcode-select --install`), and `brew install` pulls in openssl@4 for programs that use
std.http, std.llm or std.encrypt.

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
