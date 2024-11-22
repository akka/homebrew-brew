# Copyright 2024 Lightbend Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Akka < Formula
    version "2.0.55"
    desc "Akka :: Command Line Interface"
    homepage "https://akka.io"
    license "https://downloads.lightbend.com/website/legal/lightbend-commercial-software-license-agreement.txt"

    if OS.mac?
        if Hardware::CPU.intel?
            url "https://downloads.akka.io/#{version}/akka_darwin_amd64_#{version}.tar.gz"
            sha256 "5cc8aa630d4d72ae9fad70dc428bee45da2c06faa0e99b5fc6911d42be5f19be"
        else
            url "https://downloads.akka.io/#{version}/akka_darwin_arm64_#{version}.tar.gz"
            sha256 "94a11a201fab7d64c5793f7e29b48630467ba07dce1219d3dc0cf46fc9ca8d92"
        end
    end

    if OS.linux?
        url "https://downloads.akka.io/#{version}/akka_linux_amd64_#{version}.tar.gz"
        sha256 "9362b7253e5823a9e175d70c6a6d344c2d55f5fae34625cac0f85b8821c510d7"
    end

    def install
        bin.install "akka"
        prefix.install "lightbend-commercial-software-license-agreement.txt"
        (bash_completion/"akka").write `#{bin}/akka completion --shell bash`
        (fish_completion/"akka.fish").write `#{bin}/akka completion --shell fish`
        (zsh_completion/"_akka").write `#{bin}/akka completion --shell zsh`
    end

    def caveats
        <<~EOS
        #{name} is the command line interface for Akka.

            Accounts:
                To use #{name} you'll need to have an active account on Akka.
                You can register for an account on https://console.akka.io/register
                or sign up using
                #{name} auth signup

            Log in:
                To log in to your Akka account, run
                #{name} auth login

        EOS
    end

    test do
        assert_equal version, shell_output("#{bin}/akka version").strip
    end
end
