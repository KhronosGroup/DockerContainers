#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
(
    cd $(dirname $0)
    docker build . -t khronosgroup/docker-images
    docker push khronosgroup/docker-images
)
