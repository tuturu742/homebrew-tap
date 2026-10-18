class LoxiaPlayer < Formula
  desc "Keyboard-driven terminal music client for Emby"
  homepage "https://github.com/tuturu742/loxia-player"
  url "https://github.com/tuturu742/loxia-player/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4ce0c377a9616b58a5e5bd372447a3c37fd4fbcee61de90f217b10ef4c4a2849"
  license "GPL-3.0-or-later"
  head "https://github.com/tuturu742/loxia-player.git", branch: "master"

  bottle do
    root_url "https://github.com/tuturu742/loxia-player/releases/download/v0.1.0"
    sha256 cellar: :any, arm64_sequoia: "9a0d5701fa827c325859b948ccaf2213256d1e0022d86188689661700fc0f7bd"
    sha256 cellar: :any, x86_64_linux:  "dfa10aed39503aa4ebc8ce22fc85e2f4ed03eeb957f35c4fe9f8897ea66d3bd3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  # Both a build and a runtime dependency: loxia links dynamically against libmpv,
  # which Homebrew's mpv provides (it builds with -Dlibmpv=true).
  depends_on "mpv"

  # souvlaki uses the Cocoa MediaPlayer framework on macOS, but the dbus C bindings
  # on Linux, where libdbus-1 is a hard DT_NEEDED of the binary.
  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/loxia-player")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/loxia-player --version")

    # --doctor runs every diagnostic and exits non-zero if any check fails. With no
    # server configured it reports a warning rather than a failure, so a clean exit
    # here proves the binary starts, finds libmpv, and can resolve its own paths.
    output = shell_output("#{bin}/loxia-player --doctor")
    assert_match "libmpv", output
  end
end
