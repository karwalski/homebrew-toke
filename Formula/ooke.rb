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

  def install
    bin.install "ooke"
  end

  test do
    system "#{bin}/ooke", "--version"
  end
end
