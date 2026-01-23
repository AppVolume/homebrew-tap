cask "appvolume" do
  version "0.1.30"

  on_arm do
    sha256 "a0232c9ca9300c714c41693fa0e51b6ca4e20dda7951db2d66c77ec2c985f280"
    url "https://releases.appvolume.app/AppVolume-#{version}-arm64.pkg"
  end

  on_intel do
    sha256 "89f785c33020442a6bb3b8a1d171135e5ee97be35a8a1978b38322c0cc52784d"
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
