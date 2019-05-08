#!/bin/sh
# SPDX-License-Identifier: Apache-2.0

buildAndPush() {
    docker build . -t "$1"
    docker push "$1"
}
(
    cd $(dirname $0)
    buildAndPush khronosgroup/docker-images
    (
        cd openxr
        # buildAndPush khronosgroup/openxr-spec-build
        buildAndPush rpavlik/khr-specbuilder
    )
)
