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
  version "0.1.9"
  license "MIT"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nex-crm/nex-as-a-skill/releases/download/v0.1.9/nex-cli-darwin-arm64"
    sha256 "d87c750a2a449d56c6b7147b7f35ad3fa98622800fdaa5558b9f8a53f9156958"
  end

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/nex-crm/nex-as-a-skill/releases/download/v0.1.9/nex-cli-darwin-x64"
    sha256 "99d03726a6df411a5172b6c0e680e2516bc11c1bca1c713c68d43d27f845181c"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/nex-crm/nex-as-a-skill/releases/download/v0.1.9/nex-cli-linux-arm64"
    sha256 "f45d06d08b26959d0c184f0f080e53b3a7144db66f85421b19b1a4e0a60b0c5d"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/nex-crm/nex-as-a-skill/releases/download/v0.1.9/nex-cli-linux-x64"
    sha256 "4adf1d3b48dfaedff152fb62e8601d91558174e06b5c004042302cecdf09db17"
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
