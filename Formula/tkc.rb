# typed: false
# frozen_string_literal: true

class Tkc < Formula
  desc "Toke programming language compiler"
  homepage "https://tokelang.dev"
  version "3.0.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-#{version}-darwin-arm64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_DARWIN_ARM64"
    else
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-#{version}-darwin-amd64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_DARWIN_AMD64"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/karwalski/toke/releases/download/v#{version}/tkc-#{version}-linux-amd64.tar.gz"
      sha256 "PLACEHOLDER_SHA256_LINUX_AMD64"
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
