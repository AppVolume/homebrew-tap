cask "appvolume" do
  version "0.1.27"

  on_arm do
    sha256 "a5da019dde2dc2761ffb2c91707de043a96004bc95be16e0562d07f760c5d5d6"
    url "https://releases.appvolume.app/AppVolume-#{version}-arm64.pkg"
  end

  on_intel do
    sha256 "c399393f922753de03a44f9c18a8dc429424d8ef66af7f457dbb638afcae40da"
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

  pkg "AppVolume-#{version}-#{arch == :arm64 ? "arm64" : "x86_64"}.pkg"

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
