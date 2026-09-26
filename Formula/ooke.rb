# typed: false
# frozen_string_literal: true

class Ooke < Formula
  desc "Toke web framework and CMS"
  homepage "https://tokelang.dev"
  version "3.0.0"
  license "Apache-2.0"

  depends_on "karwalski/toke/tkc"

  # ooke's release workflow uses the same naming as toke's:
  # `ooke-${GITHUB_REF_NAME}-${os}-${arch}.tar.gz` -- REF_NAME carries the
  # leading v, the os is `macos` not `darwin`, and 64-bit Intel is `x86_64`
  # not `amd64`. See the note in tkc.rb; all three differed here too.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-v#{version}-macos-arm64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_MACOS_ARM64"
    else
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-v#{version}-macos-x86_64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_MACOS_X86_64"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-v#{version}-linux-arm64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_ARM64"
    else
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-v#{version}-linux-x86_64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_X86_64"
    end
  end

  # Story 134.46: `ooke compile` runs scripts/gen_app_makefile.sh, which
  # needs ooke's Makefile, src/ (module sources, interfaces and the compiled
  # modules under src/ooke/) and a toke tree. The release tarball carries the
  # installation tree ooke's scripts/stage_install.sh lays out; it is installed
  # whole under libexec, and bin/ooke is a wrapper that points ooke at it
  # (OOKE_ROOT) and at the tkc formula's tree (TOKE_ROOT, TKC) -- ooke does not
  # follow a symlinked binary, so a plain symlink would find no scripts.
  def install
    libexec.install Dir["*"]
    tkc = Formula["karwalski/toke/tkc"]
    (bin/"ooke").write_env_script libexec/"ooke",
      OOKE_ROOT: libexec,
      TOKE_ROOT: tkc.opt_libexec,
      TKC:       tkc.opt_bin/"tkc"
  end

  test do
    system "#{bin}/ooke", "--version"
  end
end
