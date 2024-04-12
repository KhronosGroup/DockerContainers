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

# This is a Docker container for OpenXR SDK CI builds.
# Intended for CI use.

FROM ubuntu:20.04

LABEL maintainer="Rylie Pavlik <rylie.pavlik@collabora.com>" \
    org.opencontainers.image.authors="Rylie Pavlik <rylie.pavlik@collabora.com>" \
    org.opencontainers.image.source=https://github.com/KhronosGroup/DockerContainers/blob/main/openxr-pregenerated-sdk.Dockerfile

ENV LANG C.UTF-8

# Enable i386 multiarch
RUN dpkg --add-architecture i386

# Runtime-required packages
# No Python on purpose: this is to make sure we can do the build without python if we have a pregenerated tree (a la OpenXR-SDK)
RUN env DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -qq \
    build-essential \
    cmake \
    git \
    libegl1-mesa-dev \
    libgl1-mesa-dev \
    libvulkan-dev \
    libwayland-dev \
    libx11-xcb-dev \
    libxcb-dri2-0-dev \
    libxcb-glx0-dev \
    libxcb-icccm4-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxml2-utils \
    libxrandr-dev \
    libxxf86vm-dev \
    mesa-common-dev \
    ninja-build \
    pkg-config \
    wayland-protocols \
    wget \
    gcc-multilib \
    g++-multilib \
    linux-libc-dev:i386 \
    libgl1-mesa-dev:i386 \
    libvulkan-dev:i386 \
    libx11-xcb-dev:i386 \
    libxcb-dri2-0-dev:i386 \
    libxcb-glx0-dev:i386 \
    libxcb-icccm4-dev:i386 \
    libxcb-keysyms1-dev:i386 \
    libxcb-randr0-dev:i386 \
    libxrandr-dev:i386 \
    libxxf86vm-dev:i386 \
    mesa-common-dev:i386 \
    && env DEBIAN_FRONTEND=noninteractive apt-get clean \
    && rm -rf /var/lib/apt/lists/*
