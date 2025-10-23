# Copyright (c) 2019-2024, The Khronos Group Inc.
#
# SPDX-License-Identifier: Apache-2.0
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

# This is a Docker container for OpenXR specification builds

FROM ruby:3.1-bookworm as builder

# Build environment for ruby and python packages
# You probably want to add packages to the **second** list.
RUN env DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -qq \
    bison \
    build-essential \
    cmake \
    flex \
    fonts-lyx \
    ghostscript \
    git \
    imagemagick \
    libpango1.0-dev \
    libreadline-dev \
    pdftk \
    poppler-utils \
    python3 \
    python3-dev \
    python3-attr \
    python3-chardet \
    python3-lxml \
    python3-networkx \
    python3-pillow \
    python3-pip \
    python3-requests \
    python3-setuptools \
    python3-wheel \
    wget \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Basic gems
RUN gem install rake asciidoctor coderay json-schema rghost rouge hexapdf
# Newer versions break our index customizer, haven't figured out the fix yet.
RUN gem install asciidoctor-pdf --version 1.6.2
# RUN MATHEMATICAL_SKIP_STRDUP=1 gem install asciidoctor-mathematical

# Basic pip packages
RUN python3 -m pip install --break-system-packages --no-cache-dir codespell pypdf2 pdoc3 reuse jinja2-cli

# pdf-diff pip package
RUN python3 -m pip install --break-system-packages --no-cache-dir git+https://github.com/rpavlik/pdf-diff

# Second stage: start a simpler image that doesn't have the dev packages
FROM ruby:3.1-bookworm

LABEL maintainer="Rylie Pavlik <rylie.pavlik@collabora.com>" \
    org.opencontainers.image.authors="Rylie Pavlik <rylie.pavlik@collabora.com>" \
    org.opencontainers.image.source=https://github.com/KhronosGroup/DockerContainers/blob/main/openxr.Dockerfile

# Copy locally-installed gems and python packages
COPY --from=builder /usr/local/ /usr/local/

# Runtime-required packages
RUN env DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -qq \
    clang-format-14 \
    fonts-lyx \
    ghostscript \
    git \
    git-lfs \
    gosu \
    imagemagick \
    jing \
    libpango1.0-0 \
    libxml2-utils \
    optipng \
    pdftk \
    pngquant \
    poppler-utils \
    python3 \
    python3-attr \
    python3-chardet \
    python3-lxml \
    python3-networkx \
    python3-pillow \
    python3-pytest \
    python3-requests \
    python3-utidylib \
    python3-venv \
    trang \
    wget \
    xmlstarlet \
    zopfli \
    && \
    apt-get clean

# Add the optional entrypoint to the image
COPY entrypoint.openxr.sh /root/entrypoint.openxr.sh
RUN chmod +x /root/entrypoint.openxr.sh

# When running, to start an interactive session, pass:
# --entrypoint /root/entrypoint.openxr.sh -e "USER_ID=$(id -u)" -e "GROUP_ID=$(id -g)" -v "$MOUNTPOINT:$MOUNTPOINT" -e "CONTAINER_CWD=$MOUNTPOINT"
