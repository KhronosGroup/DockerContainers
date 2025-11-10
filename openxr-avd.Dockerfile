# Copyright (c) 2025, The Khronos Group Inc.
#
# SPDX-License-Identifier: Apache-2.0

FROM khronosgroup/docker-images:openxr-android

LABEL maintainer="Rylie Pavlik <rylie.pavlik@collabora.com>" \
    org.opencontainers.image.authors="Rylie Pavlik <rylie.pavlik@collabora.com>" \
    org.opencontainers.image.source=https://github.com/KhronosGroup/DockerContainers/blob/main/openxr-avd.Dockerfile

ENV LANG C.UTF-8

# Switch back to privileged user for AVD setup
USER root

# Runtime dependencies for AVD
RUN env DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y -qq \
        libx11-6 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY install-avd.sh /install-avd.sh
RUN /install-avd.sh
