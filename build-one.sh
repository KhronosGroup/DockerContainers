#!/bin/bash
# Copyright 2019-2021, The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

# Pass a Dockerfile name and version (typically the year and month).
# Optionally pass the literal text "push" as third argument to publish
# the result to dockerhub.
# Any extra arguments (including the third argument if it's not "push")
# are passed to `docker build` literally.
#
# The name of the dockerfile is used in the repository of the image,
# and the version argument - as well as the literal "latest" - end up
# in the tag portion.

set -e

REPO_OWNER="khronosgroup"

(
    cd $(dirname $0)
    DOCKERFILE=$1
    VERSION=$2
    shift 2
    if [ "$1" == "push" ]; then
        OP=$1
        shift
    fi
    REPO=$REPO_OWNER/$DOCKERFILE
    docker build "$@" . -f "$DOCKERFILE.Dockerfile" \
        --build-arg "VERSION=$VERSION" \
        -t "$REPO:latest" \
        -t "$REPO:$VERSION"
    if [ "$OP" == "push" ]; then
        docker push "$REPO:latest"
        docker push "$REPO:$VERSION"
    fi
)
