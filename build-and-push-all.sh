#!/bin/bash
# SPDX-License-Identifier: Apache-2.0

set -e

(
    cd $(dirname $0)
    ./build-and-push-one.sh Dockerfile "$@"
    ./build-and-push-one.sh Dockerfile.openxr-base "$@"
    ./build-and-push-one.sh Dockerfile.openxr "$@"
    ./build-and-push-one.sh Dockerfile.openxr-sdk "$@"
    ./build-and-push-one.sh Dockerfile.openxr-pregenerated-sdk-base "$@"
    ./build-and-push-one.sh Dockerfile.openxr-pregenerated-sdk "$@"
)
