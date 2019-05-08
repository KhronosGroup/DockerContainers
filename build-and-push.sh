#!/bin/sh
# SPDX-License-Identifier: Apache-2.0

set -e

buildAndPush() {
    docker build . -t "$1"
    docker push "$1"
}
(
    cd $(dirname $0)
    buildAndPush khronosgroup/docker-images
    (
        cd openxr
        buildAndPush khronosgroup/docker-images:openxr
    )
    (
        cd openxr-sdk
        buildAndPush khronosgroup/docker-images:openxr-sdk
    )
)
