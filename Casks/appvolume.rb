cask "appvolume" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.34-beta.11"
  sha256 arm:   "2fcbc86cf3821d62e976d7741e787e4c53f51dda851418b7e03e856bf3bab564",
         intel: "f922f04922544944a837c20a8353222d0b42d8e99075dd52d9745d0a0116f21d"

  url "https://releases.appvolume.app/AppVolume-#{version}-#{arch}.pkg"
  name "AppVolume"
  desc "Per-application volume control"
  homepage "https://appvolume.app/"

  livecheck do
    url "https://releases.appvolume.app/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  pkg "AppVolume-#{version}-#{arch}.pkg"

  uninstall launchctl: "io.appvolume.daemon",
            quit:      "io.appvolume",
            pkgutil:   [
              "io.appvolume.app",
              "io.appvolume.daemon",
              "io.appvolume.driver",
              "io.appvolume.ui",
            ],
            delete:    [
              "/Library/Audio/Plug-Ins/HAL/AppVolumeAudioDevice.driver",
              "~/Library/LaunchAgents/io.appvolume.daemon.plist",
            ]

  uninstall_postflight do
    system_command "/usr/bin/killall",
                   args: ["coreaudiod"],
                   sudo: true
  end

  zap trash: [
    "~/Library/Application Support/AppVolume",
    "~/Library/Caches/io.appvolume",
    "~/Library/Preferences/io.appvolume.plist",
  ]

  caveats <<~EOS
    AppVolume is now available in the official Homebrew Cask.
    You can switch by running:
      brew untap appvolume/tap
      brew install appvolume
  EOS
end
