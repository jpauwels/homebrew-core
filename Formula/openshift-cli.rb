class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.3.1",
    :revision => "274842360258d4f6ea1d3ec19559ecd395fd4d4f"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72eacfbfb995624437e0fc6f40bf6986c3916fa1efc5b044094f11a86573b7b6" => :sierra
    sha256 "f4f8b22232cfbd01c146074420d4c8174e0468bce0f6ef9d233c85b6d92c0b5d" => :el_capitan
    sha256 "c39245ceec2bbb6f17e0853698186e9e025d09d5431480bfaf73497ae458f3c3" => :yosemite
    sha256 "b658ec53181c03fa7cc8a648667a68a168fcfec55f8071fc14f0a27c0370be4a" => :x86_64_linux
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.4.0-rc1",
      :revision => "b4e0954faa4a0d11d9c1a536b76ad4a8c0206b7c"
    version "1.4.0-rc1"

    depends_on "socat"
  end

  depends_on "go" => :build

  def install
    # this is necessary to avoid having the version marked as dirty
    (buildpath/".git/info/exclude").atomic_write "/.brew_home"

    system "make", "all", "WHAT=cmd/oc", "GOFLAGS=-v", "OS_OUTPUT_GOPATH=1"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/#{OS::NAME}/#{arch}/oc"
    bin.install_symlink "oc" => "oadm"

    bash_completion.install Dir["contrib/completions/bash/*"]
  end

  test do
    assert_match /^oc v#{version}/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}/, shell_output("#{bin}/oadm version")
  end
end
