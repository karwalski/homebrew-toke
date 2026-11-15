# typed: false
# frozen_string_literal: true

class Ooke < Formula
  desc "Toke web framework and CMS"
  homepage "https://tokelang.dev"
  version "3.0.0"
  license "MIT"

  depends_on "karwalski/toke/tkc"
  # Built on macos-15 images (minos 15.0); the macOS binaries load OpenSSL
  # from Homebrew's openssl@4 (otool -L, ooke v3.0.0). SQLite comes from macOS.
  depends_on macos: :sequoia

  # ooke's release workflow uses the same naming as toke's:
  # `ooke-${GITHUB_REF_NAME}-${os}-${arch}.tar.gz` -- REF_NAME carries the
  # leading v, the os is `macos` not `darwin`, and 64-bit Intel is `x86_64`
  # not `amd64`. See the note in tkc.rb; all three differed here too.
  on_macos do
    depends_on "openssl@4"
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-v#{version}-macos-arm64.tar.gz"
      sha256 "1d53e225ad170e4fe24a127dfdede8f1f65752117a618077e32b3857134c3e84"
    else
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-v#{version}-macos-x86_64.tar.gz"
      sha256 "1a4c5435a83be48791abbccae9b8a45b22756a2f18efaa9ed4a571702021071d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-v#{version}-linux-arm64.tar.gz"
      sha256 "d98d009b1f6644454a4835054fb8286fb966a83a8f942b9551bc829e10d2e967"
    else
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-v#{version}-linux-x86_64.tar.gz"
      sha256 "f2217ab81760544c23abafbdad655235337ecd8c7f9a1b7be9668b85daba9fe9"
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
