# Distributes the `nex` CLI from nex-as-a-skill GitHub Releases as a
# pre-built binary. The npm package (@nex-ai/nex) became a bootstrap
# shim at 0.2.x — it prints "nex-cli binary not found. Install it with:
# curl -fsSL .../install.sh | sh" and exits non-zero. So we no longer
# install via npm; we install the same binary the install.sh script
# would download, and let `bin.install` give users a `nex` invocation.
#
# Release artifacts (per nex-as-a-skill `sync-release.yml`):
#   - nex-cli-darwin-arm64
#   - nex-cli-darwin-x64
#   - nex-cli-linux-arm64
#   - nex-cli-linux-x64
#   - checksums.txt (sha256sum format)
#
# The cross-repo `dawidd6/action-homebrew-bump-formula@v7` step in
# nex-as-a-skill auto-bumps this formula on each release. The
# `livecheck-drift` workflow in this tap is the daily safety net.
class Nex < Formula
  desc "Organizational context & memory for AI agents via MCP"
  homepage "https://nex.ai"
  version "0.1.10"
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nex-crm/nex-as-a-skill/releases/download/v0.1.10/nex-cli-darwin-arm64"
    sha256 "4d1563ce16aea8a639eee20dcc149287b1617e207458d2c11b54b815ce3d1ae6"
  end

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/nex-crm/nex-as-a-skill/releases/download/v0.1.10/nex-cli-darwin-x64"
    sha256 "5eabacd50227aa419956b7635c8e8fd54a2323d422f96b4b935f2b94af443720"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/nex-crm/nex-as-a-skill/releases/download/v0.1.10/nex-cli-linux-arm64"
    sha256 "f67fa71776d63c6d6e004d7b5b832462c8cec33624abaa97ccce70392abf1d36"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nex-crm/nex-as-a-skill/releases/download/v0.1.10/nex-cli-linux-x64"
    sha256 "96a9be345b9ef78c1bb79bd7d1d9e69b15fef2d7aaa43b544bd96098891a2adf"
  end

  livecheck do
    url "https://github.com/nex-crm/nex-as-a-skill/releases/latest"
    strategy :github_latest
  end

  def install
    # Homebrew downloads the asset to its original name in the staging
    # dir. Pick whichever platform binary is present and install it as
    # `bin/nex` so `brew install nex-crm/tap/nex` gives the user a
    # `nex` command on $PATH.
    binary = Dir["nex-cli-*"].first
    odie "no nex-cli binary downloaded" if binary.nil?
    chmod 0755, binary
    bin.install binary => "nex"
  end

  test do
    # `nex --version` is the only non-interactive, exit-0 path on the
    # current binary; `--help` errors with "requires an interactive
    # terminal" when stdin isn't a TTY (which it never is under
    # `brew test`). The version string is bare semver (e.g. "0.1.9").
    assert_match(/\A\d+\.\d+\.\d+\b/, shell_output("#{bin}/nex --version"))
  end
end
