#!/bin/bash
# Copyright 2019-2021 The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

set -e

(
    cd $(dirname $0)
    ./build-and-push-one.sh asciidoctor-spec.dockerfile "$@"
    ./build-and-push-one.sh vulkan-docs-base.dockerfile "$@"
    ./build-and-push-one.sh vulkan-docs.dockerfile "$@"
    ./build-and-push-one.sh Dockerfile.openxr-base.202102 "$@"
    ./build-and-push-one.sh Dockerfile.openxr.202102 "$@"
    ./build-and-push-one.sh Dockerfile.openxr-sdk.202102 "$@"
    ./build-and-push-one.sh Dockerfile.openxr-pregenerated-sdk-base.202102 "$@"
    ./build-and-push-one.sh Dockerfile.openxr-pregenerated-sdk.202102 "$@"
)
