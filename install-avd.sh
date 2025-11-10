#!/usr/bin/env bash
# Copyright 2022-2025, Collabora, Ltd. and the Monado contributors
#
# SPDX-License-Identifier: BSL-1.0

set -eo pipefail

# Default fallback values, should match install-android-sdk.sh
ANDROID_COMPILE_SDK=${ANDROID_COMPILE_SDK:-34}
ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-/opt/android-sdk}
ANDROID_ARCH=${ANDROID_ARCH:-x86_64}

SDKMANAGER=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager
AVDMANAGER=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/avdmanager
AVD_PACKAGE="system-images;android-${ANDROID_COMPILE_SDK};aosp_atd;${ANDROID_ARCH}"
AVD_NAME=openxr-pixel5

echo "Installing AVD simulator"
echo y | $SDKMANAGER "$AVD_PACKAGE" >> /dev/null

echo "Configuring device"
$AVDMANAGER --verbose create avd --name $AVD_NAME --device pixel_5 --package $AVD_PACKAGE
$AVDMANAGER list avd
