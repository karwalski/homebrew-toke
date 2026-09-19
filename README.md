# Homebrew tap for toke

This is the official Homebrew tap for the toke programming language tools.

> toke: a compiled language designed for LLM code generation, with a small grammar, one
> canonical form and compiler verification.

The one-liner above is reproduced word for word from the canonical description,
[`docs/about/canonical.md`](https://github.com/karwalski/toke/blob/main/docs/about/canonical.md)
in the toke repository. Every number published about toke comes from
[`docs/metrics-baseline.md`](https://github.com/karwalski/toke/blob/main/docs/metrics-baseline.md)
and nowhere else.

## Installation

```sh
brew tap karwalski/toke
brew install tkc
brew install ooke
```

## What it installs

- `tkc` -- the toke compiler binary, plus standard library files
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

## Links

- Language website: https://tokelang.dev
- Compiler source: https://github.com/karwalski/toke
- Canonical description of toke: https://github.com/karwalski/toke/blob/main/docs/about/canonical.md
- Web framework source: https://github.com/karwalski/ooke
