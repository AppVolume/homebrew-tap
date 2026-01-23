cask "appvolume" do
  version "0.1.28"

  on_arm do
    sha256 "26e45b49e2e869cb489b7bc2d37c699338bb9691d486cb68b0ba09026f7c1ad4"
    url "https://releases.appvolume.app/AppVolume-#{version}-arm64.pkg"
  end

  on_intel do
    sha256 "e83610b9c62224baeff0c8fd9e6e751a96654cfd44d718bb6da68af2b64e3e71"
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
