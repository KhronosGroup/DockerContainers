#!/bin/bash
# Copyright 2019-2025, The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

set -e

(
    cd $(dirname $0)
    ./build-one.sh asciidoctor-spec 202206 "$@"
    ./build-one.sh opencl-sdk-base-ubuntu-20.04 20230717 "$@"
    ./build-one.sh opencl-sdk-base-ubuntu-22.04 20230717 "$@"
    ./build-one.sh opencl-sdk-intelcpu-ubuntu-20.04 20230717 "$@"
    ./build-one.sh opencl-sdk-intelcpu-ubuntu-22.04 20230717 "$@"
    ./build-one.sh vulkan-docs-base 202206 "$@"
    ./build-one.sh vulkan-docs 202206 "$@"
    ./build-one.sh rust 202312 "$@"
    ./build-one.sh openxr 20240924 "$@"
    ./build-one.sh openxr-sdk 20240924 "$@"
    ./build-one.sh openxr-pregenerated-sdk 20240924 "$@"
    ./build-one.sh openxr-android 20250121 "$@"
)
