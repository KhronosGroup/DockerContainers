# Copyright 2019-2024 The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

# Defines a Docker image for building Khronos specifications written using
# asciidoctor markup.
# Contains the asciidoctor toolchain and related plugins and tools.
# Specifications with additional toolchain requirements can build images
# layered on this one.

from ruby:3.3.4
label maintainer="Jon Leech <devrel@oddhack.org>"

# Add the Node.js repository to the apt registry
run curl -fsSL https://deb.nodesource.com/setup_current.x | bash -

# Debian packages.
# First install is for Node / Python / Ruby.
# Second is for native tools, and libraries needed for some Ruby gems.
run apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends \
        locales \
        nodejs \
        python3 \
        python3-venv \
        python3-pip && \
    apt-get install -y -qq --no-install-recommends \
        bash \
        bison  \
        build-essential \
        clang-format \
        cmake \
        dos2unix \
        flex \
        fonts-lyx \
        clang \
        gcc \
        ghostscript \
        git \
        gosu \
        graphicsmagick-libmagick-dev-compat \
        g++ \
        jing \
        libavalon-framework-java \
        libbatik-java \
        libcairo2-dev \
        libffi-dev \
        libgdk-pixbuf2.0-dev \
        libpango1.0-dev \
        libreadline-dev \
        libxml2-dev \
        ninja-build \
        pandoc \
        pdftk \
        poppler-utils \
        unzip \
        zip \
    && apt-get clean

# Ensure the proper locale is installed and used - not present in ruby image
# See https://serverfault.com/questions/54591/how-to-install-change-locale-on-debian#54597
run sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen && \
    apt-get clean
env LANG=en_US.UTF-8

# Python packages are installed in a virtual environment (venv).
# Debian does not allow pip3 to install to the system Python directories.
# It is possible to override this, but instead we use Docker commands to
# manage a venv - see e.g.
#   https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
# A user trying to create their own spec toolchain should instead
#   source /path/to/venv/activate
# which is equivalent to the commands below.

env VIRTUAL_ENV=/opt/venv
run python3 -m venv $VIRTUAL_ENV
env PATH="$VIRTUAL_ENV/bin:$PATH"

run pip3 install \
    wheel setuptools \
    codespell lxml meson networkx pygments pyparsing pytest termcolor \
    reuse

# JavaScript packages
# escape-string-regexp is locked @2.0.0 because the current version is an
# ES6 module requiring unobvious changes from 'require' to 'import'
# There is an issue with more recent lunr versions, as well
run npm install -g escape-string-regexp@2.0.0 he lunr@2.3.6
env NODE_PATH=/usr/lib/node_modules

# Ruby packages providing asciidoctor and related plugins
run gem install -N \
        asciidoctor \
        asciidoctor-diagram \
        asciidoctor-mathematical \
        asciidoctor-pdf \
        coderay \
        hexapdf \
        json-schema \
        i18n \
        prawn-gmagick \
        pygments.rb \
        rouge \
        text-hyphen

# Set HOME so that when running under a different UID, temp files can be
# written there.
env HOME=/tmp
