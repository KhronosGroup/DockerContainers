# Copyright 2019-2022 The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

# This defines a Docker image for building a set of Khronos specifications
# written using asciidoctor markup.
# It contains the asciidoctor toolchain, and related plugins and tools.
# Some projects may have additional toolchain requirements, and will use
# Docker images layered on this one.

from ruby:3.1.2
label maintainer="Jon Leech <devrel@oddhack.org>"

# This adds the Node.js repository to the apt registry
# nodejs is actually installed in the next step
run curl -fsSL https://deb.nodesource.com/setup_current.x | bash -

# Debian packages
# pandoc is for potential use with Markdown
# reuse is for repository license verification
run apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends \
        bash \
        bison  \
        build-essential \
        cmake \
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
        nodejs \
        pandoc \
        pdftk \
        poppler-utils \
        python3 \
        python3-pip \
        python3-pytest \
        python3-termcolor \
        tcsh && \
    apt-get clean

# Ruby gems providing asciidoctor and related plugins
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

# Python packages
# Something odd in the Docker build causes errors if setuptools isn't
# installed first, although it should be a dependency of the other packages.
run pip3 install wheel setuptools
run pip3 install codespell networkx pygments reuse
run pip3 install pyparsing

# JavaScript packages
# escape-string-regexp is locked @2.0.0 because the current version is an
# ES6 module requiring unobvious changes from 'require' to 'import'
# There is an issue with more recent lunr versions, as well
run npm install -g escape-string-regexp@2.0.0 he lunr@2.3.6
env NODE_PATH /usr/lib/node_modules

# Ensure the proper locale is installed and used - not present in ruby image
# See https://serverfault.com/questions/54591/how-to-install-change-locale-on-debian#54597
run apt-get install -y -qq locales && \
    sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen && \
    apt-get clean
env LANG en_US.UTF-8
