#!/bin/bash
# Copyright 2019-2023 The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

set -e

(
    cd $(dirname $0)
    ./build-one.sh asciidoctor-spec 202206 "$@"
    ./build-one.sh vulkan-docs-base 202206 "$@"
    ./build-one.sh vulkan-docs 202206 "$@"
    ./build-one.sh rust 202206 "$@"
    ./build-one.sh openxr 20230614 "$@"
    ./build-one.sh openxr-sdk 20230614 "$@"
    ./build-one.sh openxr-pregenerated-sdk 20230822 "$@"
    ./build-one.sh openxr-android 20230713 "$@"
)
