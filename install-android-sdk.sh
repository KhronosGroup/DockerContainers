#!/usr/bin/env bash
# Copyright 2022-2023, Collabora, Ltd. and the Monado contributors
#
# SPDX-License-Identifier: BSL-1.0

# Partially inspired by https://about.gitlab.com/blog/2018/10/24/setting-up-gitlab-ci-for-android-projects/
# and based on https://gitlab.freedesktop.org/monado/monado/-/blob/9ad98815bbc291f96c092b7aad2943ad567d65b4/.gitlab-ci/install-android-sdk.sh

set -eo pipefail
# These normally come from the environment but we have defaults
ANDROID_CLI_TOOLS=${ANDROID_CLI_TOOLS:-9477386}
ANDROID_COMPILE_SDK=${ANDROID_COMPILE_SDK:-32}
ANDROID_BUILD_TOOLS=${ANDROID_BUILD_TOOLS:-32.0.0}
ANDROID_NDK_VERSION=${ANDROID_NDK_VERSION:-25.2.9519653}
ANDROID_CMAKE_VERSION=${ANDROID_CMAKE_VERSION:-3.22.1}
ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-/opt/android-sdk}

mkdir -p "$ANDROID_SDK_ROOT"
FN=commandlinetools-linux-${ANDROID_CLI_TOOLS}_latest.zip
wget https://dl.google.com/android/repository/$FN
unzip "$FN" -d "$ANDROID_SDK_ROOT/extract"
mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"
mv "$ANDROID_SDK_ROOT/extract/cmdline-tools/" "$ANDROID_SDK_ROOT/cmdline-tools/latest/"
mv "$ANDROID_SDK_ROOT/extract/" "$ANDROID_SDK_ROOT/cmdline-tools/"

SDKMANAGER=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager

set +o pipefail
yes | $SDKMANAGER --licenses
set -o pipefail

echo "Installing the Android compile SDK platform android-${ANDROID_COMPILE_SDK}"
echo y | $SDKMANAGER "platforms;android-${ANDROID_COMPILE_SDK}" >> /dev/null

echo "Installing the latest Android platform tools"
echo y | $SDKMANAGER "platform-tools" >> /dev/null

echo "Installing the Android NDK ${ANDROID_NDK_VERSION}"
echo y | $SDKMANAGER "ndk;${ANDROID_NDK_VERSION}" >> /dev/null

echo "Installing CMake ${ANDROID_CMAKE_VERSION}"
echo y | $SDKMANAGER "cmake;${ANDROID_CMAKE_VERSION}" >> /dev/null

echo "Installing the Android 'patcher'"
echo y | $SDKMANAGER "patcher;v4" >> /dev/null

echo "Installing the Android build tools ${ANDROID_BUILD_TOOLS}"
echo y | $SDKMANAGER "build-tools;${ANDROID_BUILD_TOOLS}" >> /dev/null

rm -rf "${ANDROID_SDK_ROOT}/.temp" "${ANDROID_SDK_ROOT}/.knownPackages"
