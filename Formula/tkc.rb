# typed: false
# frozen_string_literal: true

class Tkc < Formula
  desc "Toke programming language compiler"
  homepage "https://tokelang.dev"
  version "3.2.0"
  license all_of: ["Apache-2.0", "MIT"]

  # The filenames below are what .github/workflows/release.yml actually
  # produces: `tkc-${GITHUB_REF_NAME}-${os}-${arch}.tar.gz`, where REF_NAME is
  # the tag and so CARRIES THE LEADING v, the os is `macos` not `darwin`, and
  # the 64-bit Intel arch is `x86_64` not `amd64`. Every one of those three
  # differed from what this formula asked for until 2026-09-23, so the formula
  # would have 404'd on all four platforms the day the release went out.
  # If you change one side, change the other in the same commit.
  # The release binaries are built on GitHub's macos-15 images with no lower
  # deployment target (LC_BUILD_VERSION minos 15.0), and on Linux against
  # glibc 2.38+ (toke 127.454).
  depends_on macos: :sequoia

  on_macos do
    # Programs that import std.http, std.llm or std.encrypt link -lssl and
    # -lcrypto through the Homebrew prefix tkc was built with
    # (TKC_HOMEBREW_PREFIX, toke 127.446). openssl@4 is the OpenSSL Homebrew
    # links into that prefix (openssl@3 is keg-only and is not found there).
    depends_on "openssl@4"
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-v#{version}-macos-arm64.tar.gz"
      sha256 "6091b17ca2674495ccc9472529cc55f362c4e1ec3bd995978550447f6a0df530"
    else
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-v#{version}-macos-x86_64.tar.gz"
      sha256 "fa3f830aef880e3c0044700d6c45f9354a23b853f2c7823e414af02f8494a8ed"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-v#{version}-linux-arm64.tar.gz"
      sha256 "dc9a61e552d3a4e9cf793ed42a88a6220f9a9e4a08ca218e7991c93d4bf7062e"
    else
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-v#{version}-linux-x86_64.tar.gz"
      sha256 "6eeb27ad7661024b85c40de66b4a234e87f606ec306693752fe7b9324baac186"
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

      On Linux the release binary needs glibc 2.38 or later (Ubuntu 24.04+,
      Debian 13+, Fedora 39+), and programs that use std.http, TLS, std.db or
      compression link the system libraries: install clang, libssl-dev,
      zlib1g-dev and libsqlite3-dev (or your distribution's equivalents).
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

    # Compile and link a std.http program: that is what needs the OpenSSL
    # dependency above to be where tkc looks for it.
    (testpath/"web.tk").write <<~EOS
      m=web;
      i=http:std.http;
      f=main():i64{
        <0
      };
    EOS
    system bin/"tkc", "--allow-all", "web.tk", "--out", "web"
    assert_path_exists testpath/"web"
  end
end
