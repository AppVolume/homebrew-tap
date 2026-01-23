cask "appvolume" do
  version "0.1.29"

  on_arm do
    sha256 "fdb3d10458ba16d6e458a1a918f85150b0900bc232b0908833beecfde4d82288"
    url "https://releases.appvolume.app/AppVolume-#{version}-arm64.pkg"
  end

  on_intel do
    sha256 "5790c57e61e4cc989f7c6a41b011db1aeb5bf1e3bbcd77e584b8ed07d9eb5cd8"
    url "https://releases.appvolume.app/AppVolume-#{version}-x86_64.pkg"
  end

  name "AppVolume"
  desc "Per-application volume control for macOS"
  homepage "https://appvolume.app"

  livecheck do
    url "https://releases.appvolume.app/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  on_arm do
    pkg "AppVolume-#{version}-arm64.pkg"
  end

  on_intel do
    pkg "AppVolume-#{version}-x86_64.pkg"
  end

  uninstall launchctl: "io.appvolume.daemon",
            quit:      "io.appvolume",
            pkgutil:   [
              "io.appvolume.daemon",
              "io.appvolume.driver",
              "io.appvolume.ui",
            ],
            delete:    "/Library/Audio/Plug-Ins/HAL/AppVolumeAudioDevice.driver"

  zap trash: [
    "~/Library/Application Support/AppVolume",
    "~/Library/Caches/io.appvolume",
    "~/Library/Preferences/io.appvolume.plist",
  ]

  caveats <<~EOS
    AppVolume is currently in Early Access.
    Learn more at https://appvolume.app
  EOS
end
