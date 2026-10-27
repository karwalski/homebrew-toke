# typed: false
# frozen_string_literal: true

class Tkc < Formula
  desc "Toke programming language compiler"
  homepage "https://tokelang.dev"
  version "3.0.0"
  license "Apache-2.0"

  # The filenames below are what .github/workflows/release.yml actually
  # produces: `tkc-${GITHUB_REF_NAME}-${os}-${arch}.tar.gz`, where REF_NAME is
  # the tag and so CARRIES THE LEADING v, the os is `macos` not `darwin`, and
  # the 64-bit Intel arch is `x86_64` not `amd64`. Every one of those three
  # differed from what this formula asked for until 2026-09-23, so the formula
  # would have 404'd on all four platforms the day the release went out.
  # If you change one side, change the other in the same commit.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-v#{version}-macos-arm64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_MACOS_ARM64"
    else
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-v#{version}-macos-x86_64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_MACOS_X86_64"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-v#{version}-linux-arm64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_ARM64"
    else
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-v#{version}-linux-x86_64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_X86_64"
    end
  end

  # The tarball is laid out as .github/workflows/release.yml's "Package
  # release tarball" step builds it, and tkc needs that layout intact:
  #   tkc              the compiler, built with TKC_STDLIB_DIR="src/stdlib"
  #   src/stdlib/      the runtime C sources every program links (tk_runtime.c
  #                    and the rest); tkc finds them beside its executable
  #   stdlib/*.tki     interfaces, read from <src/stdlib>/../../stdlib
  #   stdlib/vendor/   cmark, tomlc99, miniz, the same two levels up
  # tkc resolves its stdlib (toke 127.179) from $TKC_STDLIB_DIR, else an
  # absolute built-in path, else beside the real path of the executable. So
  # the whole tree goes under libexec unchanged and bin/tkc is a symlink:
  # the symlink resolves to libexec/tkc, whose src/stdlib is right beside it.
  # Until 132.97 the formula installed only bin/tkc and libexec/*.tki, and a
  # brewed tkc built nothing (E9022: stdlib directory not found).
  def install
    libexec.install "tkc"
    (libexec/"src").install "src/stdlib"
    libexec.install "stdlib"
    bin.install_symlink libexec/"tkc"
  end

  # toke 132.122: tkc runs the clang whose absolute path was baked in when the
  # release binary was built (TKC_CLANG_PATH, the build runner's
  # `command -v clang`); it never searches $PATH. On a machine whose clang is
  # elsewhere every build fails with E9027 (exit 3) until TKC_CC is set.
  # Whether the formula should set TKC_CC itself, build from source, or tkc
  # should gain a relocatable lookup is an open owner decision (132.122).
  def caveats
    <<~EOS
      tkc runs the clang found where this release was built, not the one on
      your PATH. If builds fail with E9027, point it at your clang:
        export TKC_CC="$(command -v clang)"
      (see https://tokelang.dev/docs/learn/install/ "Packaged installs").
    EOS
  end

  test do
    # Build and run a program, not just --version: that is what needs the
    # runtime sources and the interfaces to be where tkc looks for them.
    (testpath/"hello.tk").write <<~EOS
      m=hello;
      i=io:std.io;
      f=main():i64{io.println("hello from tkc");<0};
    EOS
    system bin/"tkc", "hello.tk", "--out", "hello"
    assert_equal "hello from tkc\n", shell_output("./hello")
  end
end
