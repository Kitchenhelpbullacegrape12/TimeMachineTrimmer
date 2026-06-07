cask "time-machine-trimmer" do
  version "1.0"
  sha256 ""

  url "https://github.com/ricardoleal/TimeMachineTrimmer/releases/download/#{version}/TimeMachineTrimmer.dmg"
  name "TimeMachineTrimmer"
  desc "Trim old Time Machine backups, reclaim disk space"
  homepage "https://github.com/ricardoleal/TimeMachineTrimmer"

  app "TimeMachineTrimmer.app"

  zap trash: [
    "~/Library/Application Scripts/com.ricardoleal.TimeMachineTrimmer",
    "~/Library/Containers/com.ricardoleal.TimeMachineTrimmer",
  ]
end
