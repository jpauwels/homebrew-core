class Chromedriver < Formula
  desc "Tool for automated testing of webapps across many browsers"
  homepage "https://sites.google.com/a/chromium.org/chromedriver/"
  if OS.mac?
    url "https://chromedriver.storage.googleapis.com/2.26/chromedriver_mac64.zip"
    sha256 "70aae3812941ed94ad8065bb4a9432861d7d4ebacdd93ee47bb2c7c57c7e841e"
  elsif OS.linux?
    url "https://chromedriver.storage.googleapis.com/2.26/chromedriver_linux64.zip"
    sha256 "59e6b1b1656a20334d5731b3c5a7400f92a9c6f5043bb4ab67f1ccf1979ee486"
  end
  version "2.26"

  bottle :unneeded

  def install
    bin.install "chromedriver"
  end

  plist_options :manual => "chromedriver"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>homebrew.mxcl.chromedriver</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/chromedriver</string>
      </array>
      <key>ServiceDescription</key>
      <string>Chrome Driver</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/chromedriver-error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/chromedriver-output.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    driver = fork do
      exec bin/"chromedriver", "--port=9999", "--log-path=#{testpath}/cd.log"
    end
    sleep 5
    Process.kill("TERM", driver)
    File.exist? testpath/"cd.log"
  end
end
