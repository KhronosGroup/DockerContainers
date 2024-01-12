#!/bin/bash
# Copyright 2019-2024, The Khronos Group Inc.
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
        -t "$REPO:$DOCKERFILE.$VERSION" \
        $EXTRA_DOCKER_ARGS
    if [ "$OP" == "push" ]; then
        docker push "$REPO:$DOCKERFILE"
        docker push "$REPO:$DOCKERFILE.$VERSION"
    fi

    # Show how to refer to it.
    HASH=$(docker inspect --format='{{index .RepoDigests 0}}' "$REPO:$DOCKERFILE.$VERSION" | sed -E -n "s/.*(sha256:.*)/\1/p")
    echo
    echo "** To refer to this image precisely, use:"
    echo "   $REPO:$DOCKERFILE.$VERSION@$HASH"

    [ -n "$CI" ] && echo "::endgroup::"
)
