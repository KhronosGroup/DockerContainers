# Copyright (c) 2019 The Khronos Group Inc.
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

# This is a Docker container for Vulkan specification builds

from ruby:2.6
label maintainer="Jon Leech <devrel@oddhack.org>"

# Install standard Debian packages
run apt update -qq
run apt install -y -qq \
        bison  \
        build-essential \
        cmake \
        flex \
        fonts-lyx \
        clang \
        gcc \
        ghostscript \
        git \
        g++ \
        jing \
        libcairo2-dev \
        libffi-dev \
        libgdk-pixbuf2.0-dev \
        libpango1.0-dev \
        libreadline-dev \
        libxml2-dev \
        pdftk \
        poppler-utils \
        python3 \
        python3-pytest \
        python3-termcolor \
        ruby \
        ttf-lyx

# Force-install an older version of i18n so the 1.5.2 version, which
# won't work with ruby 2.1, doesn't abort the CI job when installing
# other gems which need it.
run gem install i18n -v 1.5.1
run gem install asciidoctor asciidoctor-mathematical coderay json-schema

# Install chunked index generation scripts and add lunr to node searchpath
run curl -sL https://deb.nodesource.com/setup_8.x | bash -
run apt install -y nodejs
run npm install -g lunr@2.3.6
env NODE_PATH /usr/lib/node_modules

# Install Roswell and asciidoctor-chunker. Need at least this specific
# version (later may be OK, too)
run curl -fsSL -o roswell.deb https://github.com/roswell/roswell/releases/download/v19.4.10.98/roswell_19.4.10.98-1_amd64.deb
run dpkg -i roswell.deb
run ros install alexandria lquery cl-fad
run mkdir -p $HOME/common-lisp
run (cd $HOME/common-lisp && git clone https://github.com/wshito/asciidoctor-chunker.git)

# Ensure the proper locale is installed and used - not present in ruby image
# See https://serverfault.com/questions/54591/how-to-install-change-locale-on-debian#54597
run apt install -y -qq locales
run sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
run locale-gen
env LANG en_US.UTF-8

