class Nex < Formula
  desc "Organizational context & memory for AI agents via MCP"
  homepage "https://nex.ai"
  url "https://registry.npmjs.org/@nex-ai/nex/-/nex-0.2.12.tgz"
  sha256 "9fc946b0ace3112e31715ffc204ab9c0fc82de3767051cb9c94b71d37f323c23"
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
    # `--version` is the only non-interactive entry point as of
    # @nex-ai/nex 0.2.x — `--help` launches a TUI that hangs `brew
    # test`'s no-TTY sandbox until Homebrew kills it.
    #
    # The exit code is unreliable (0 on developer machines, 1 on
    # GitHub-hosted macos-14/15 runners, with the same binary). Use
    # IO.popen to capture output without asserting an exit code, and
    # match a semver shape — the embedded version string is currently
    # independent of the npm package version (a separate nex-cli
    # bug, out of scope).
    output = IO.popen([bin/"nex", "--version", err: [:child, :out]], &:read)
    assert_match(/\d+\.\d+\.\d+/, output)
  end
end
