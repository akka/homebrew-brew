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
    version "3.0.5"
    desc "Akka :: Command Line Interface"
    homepage "https://akka.io"
    license "https://downloads.lightbend.com/website/legal/lightbend-commercial-software-license-agreement.txt"

    if OS.mac?
        if Hardware::CPU.intel?
            url "https://downloads.akka.io/#{version}/akka_darwin_amd64_#{version}.tar.gz"
            sha256 "6085fcf88bfb8a806b32270b139b4d66cb1eb3a24d88252182ba2dff3359110e"
        else
            url "https://downloads.akka.io/#{version}/akka_darwin_arm64_#{version}.tar.gz"
            sha256 "0450884b1da9afe3fe83609ec044cacc63fa85f0c40830f8918b76180600dd80"
        end
    end

    if OS.linux?
        url "https://downloads.akka.io/#{version}/akka_linux_amd64_#{version}.tar.gz"
        sha256 "0a64801182a2c9c5298d9047993b24d359b5bda167132636aec0a3a9ca3fa25c"
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
