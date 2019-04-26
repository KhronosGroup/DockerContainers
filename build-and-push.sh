#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
(
    cd $(dirname $0)
    docker build . -t khronosgroup/docker-images
    docker push khronosgroup/docker-images
    (
        cd openxr
        docker build . -t khronosgroup/openxr-spec-build
        docker push khronosgroup/openxr-spec-build
    )
)
