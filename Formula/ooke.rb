# typed: false
# frozen_string_literal: true

class Ooke < Formula
  desc "Toke web framework and CMS"
  homepage "https://tokelang.dev"
  version "3.0.0"
  license "Apache-2.0"

  depends_on "karwalski/toke/tkc"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-#{version}-darwin-arm64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_DARWIN_ARM64"
    else
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-#{version}-darwin-amd64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_DARWIN_AMD64"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/karwalski/ooke/releases/download/v#{version}/ooke-#{version}-linux-amd64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_AMD64"
    end
  end

  def install
    bin.install "ooke"
  end

  test do
    system "#{bin}/ooke", "--version"
  end
end
