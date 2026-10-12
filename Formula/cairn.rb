class Cairn < Formula
  desc "Find the right Claude Code session and hop back into it"
  homepage "https://github.com/habibulloxon/cairn-cli"
  url "https://github.com/habibulloxon/cairn-cli/releases/download/v0.1.0/cairn-0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "bin", "cairn", "ui"
    # CAIRN_BIN is the stable path `cairn install` writes into Claude Code's settings,
    # so the hooks keep working across `brew upgrade`.
    (bin/"cairn").write <<~SH
      #!/bin/bash
      export CAIRN_BIN="#{HOMEBREW_PREFIX}/bin/cairn"
      exec "#{Formula["python@3.13"].opt_bin}/python3.13" "#{opt_libexec}/bin/cairn" "$@"
    SH
  end

  def caveats
    <<~EOS
      To track your Claude Code sessions, add cairn's hooks and status line:
        cairn install
      It backs up ~/.claude/settings.json first; `cairn uninstall` removes them.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cairn --version")
    ENV["CAIRN_HOME"] = (testpath/"data").to_s
    ENV["CAIRN_CLAUDE_DIR"] = (testpath/"claude").to_s
    (testpath/"claude/projects").mkpath
    assert_match "0 sessions updated", shell_output("#{bin}/cairn sync")
  end
end
