class LoxiaPlayer < Formula
  desc "Keyboard-driven terminal music client for Emby"
  homepage "https://github.com/tuturu742/loxia-player"
  url "https://github.com/tuturu742/loxia-player/archive/refs/tags/v0.1.0-rc.2.tar.gz"
  sha256 "6c2d10d340982711054d32d929d3ccdca923e834124cbf636608f5798027f791"
  license "GPL-3.0-or-later"
  head "https://github.com/tuturu742/loxia-player.git", branch: "master"

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
