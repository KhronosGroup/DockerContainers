#!/bin/bash
# Copyright 2019-2023, The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

# Pass a Dockerfile name and version (typically the year and month).
# Optionally pass the literal text "push" as third argument to publish
# the result to dockerhub.
# Any extra arguments (including the third argument if it's not "push")
# are passed to `docker build` literally.
#
# The tag portion of the name is used as the tag within the repo.

set -e

REPO="khronosgroup/docker-images"

(
    cd "$(dirname "$0")"
    DOCKERFILE=${1%%.Dockerfile}
    VERSION=$2
    shift 2
    if [ "$1" == "push" ]; then
        OP=$1
        shift
    fi
    [ -n "$CI" ] && echo "::group::$DOCKERFILE @ $VERSION"
    docker build "$@" . -f "$DOCKERFILE.Dockerfile" \
        --build-arg "VERSION=$VERSION" \
        -t "$REPO:$DOCKERFILE" \
        -t "$REPO:$DOCKERFILE.$VERSION"
    if [ "$OP" == "push" ]; then
        docker push "$REPO:$DOCKERFILE"
        docker push "$REPO:$DOCKERFILE.$VERSION"
    fi
    [ -n "$CI" ] && echo "::endgroup::"
)
