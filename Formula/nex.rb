# PINNED at 0.1.52 — DO NOT auto-bump until the bootstrap-shim
# decision lands.
#
# As of @nex-ai/nex 0.2.x, the npm package no longer ships the CLI;
# it ships a bootstrap shim that prints "nex-cli binary not found.
# Install it with: curl -fsSL .../install.sh | sh" and exits non-zero.
# `brew install nex-crm/tap/nex` → 0.2.x would deliver a broken
# executable to every user. 0.1.52 is the last functional CLI on npm.
#
# The companion `livecheck-drift.yml` workflow will fire daily as a
# canary while this pin holds. Either retarget the formula at
# nex-as-a-skill's binary releases or deprecate the formula; do not
# silently bump the npm tarball.
class Nex < Formula
  desc "Organizational context & memory for AI agents via MCP"
  homepage "https://nex.ai"
  url "https://registry.npmjs.org/@nex-ai/nex/-/nex-0.1.52.tgz"
  sha256 "9dc458b845f9db3fff8c4b58a6325fa9742808e4c65d6cc50e00094748ff40aa"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@nex-ai/nex/latest"
    regex(/"version":\s*"([^"]+)"/i)
  end

  depends_on "node@20"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    output = shell_output("#{bin}/nex --help 2>&1")
    assert_match "nex", output
  end
end
