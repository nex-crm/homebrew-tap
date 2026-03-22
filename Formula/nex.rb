class Nex < Formula
  desc "Organizational context & memory for AI agents via MCP"
  homepage "https://nex.ai"
  url "https://github.com/nex-crm/nex-as-a-skill/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256_UPDATE_AFTER_RELEASE"
  license "MIT"

  depends_on "node@20"

  def install
    cd "cli" do
      system "npm", "install", *std_npm_args
      system "npm", "run", "build"
    end

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "nex", shell_output("#{bin}/nex --version")
  end
  end
