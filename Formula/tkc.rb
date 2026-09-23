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

  def install
    bin.install "tkc"
    libexec.install Dir["stdlib/*"] if Dir.exist?("stdlib")
  end

  test do
    system "#{bin}/tkc", "--version"
  end
end
