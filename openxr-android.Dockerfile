# Copyright (c) 2019-2025, The Khronos Group Inc.
#
# SPDX-License-Identifier: Apache-2.0

FROM debian:bookworm

LABEL maintainer="Rylie Pavlik <rylie.pavlik@collabora.com>" \
    org.opencontainers.image.authors="Rylie Pavlik <rylie.pavlik@collabora.com>" \
    org.opencontainers.image.source=https://github.com/KhronosGroup/DockerContainers/blob/main/openxr-android.Dockerfile

ENV LANG C.UTF-8


RUN env DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -qq \
        ca-certificates \
        cmake \
        default-jdk-headless \
        git \
        git-lfs \
        glslang-tools \
        gnupg \
        gradle \
        ninja-build \
        p7zip-full \
        pkg-config \
        python3 \
        python3-attr \
        python3-jinja2 \
        python3-lxml \
        python3-networkx \
        unzip \
        wget \
        zip \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up user and group 1000:1000 for most common usage case
RUN addgroup --gid 1000 --quiet openxr
RUN useradd --shell /bin/bash --create-home --no-log-init --uid 1000 --gid 1000 openxr

### Android SDK components

# # This must match android.compileSdk in all Android build.gradle files
# ENV ANDROID_COMPILE_SDK=33

# # This must match android.buildToolsVersion in all Android build.gradle files
# ENV ANDROID_BUILD_TOOLS=34.0.0

# # look up on https://developer.android.com/studio/index.html#downloads when updating other versions
# ENV ANDROID_CLI_TOOLS=10406996

ENV ANDROID_NDK_VERSION=23.2.8568313

ENV ANDROID_SDK_ROOT=/opt/android-sdk

COPY install-android-sdk.sh /install-android-sdk.sh
RUN /install-android-sdk.sh

ENV ANDROID_NDK_HOME=${ANDROID_SDK_ROOT}/ndk/${ANDROID_NDK_VERSION}

# Switch to non-privileged user
USER openxr
WORKDIR /home/openxr

# Cache the gradle wrapper in the image
ENV CACHED_GRADLE_WRAPPER_VERSION=8.5
RUN mkdir -p temp_proj && \
    cd temp_proj && \
    gradle -Porg.gradle.daemon=false init && \
    gradle -Porg.gradle.daemon=false wrapper --gradle-version=${CACHED_GRADLE_WRAPPER_VERSION} && \
    cd .. && \
    rm -rf temp_proj
