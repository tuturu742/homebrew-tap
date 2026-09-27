class LoxiaPlayer < Formula
  desc "Keyboard-driven terminal music client for Emby"
  homepage "https://github.com/tuturu742/loxia-player"
  url "https://github.com/tuturu742/loxia-player/archive/refs/tags/v0.1.0-rc.3.tar.gz"
  sha256 "48ca8a10de7242a7ddc8a9aa2334a2f7d1047dc8ebea018cb3f6284c96f9cafe"
  license "GPL-3.0-or-later"
  head "https://github.com/tuturu742/loxia-player.git", branch: "master"

  bottle do
    root_url "https://github.com/tuturu742/loxia-player/releases/download/v0.1.0-rc.3"
    sha256 cellar: :any, arm64_sequoia: "c35a3af8119fbad766871bae197c89f1f09b7341149d5bdf4b17846f423a8dc4"
    sha256 cellar: :any, x86_64_linux:  "4a16c79e618b63c6ca82a85f60d6b231d9d3f8f06ba558fec5665b6522a9adc3"
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
