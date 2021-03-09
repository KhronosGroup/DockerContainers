#!/bin/bash
# Copyright 2019-2021, The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

# Pass a dockerfile name.
# The tag portion of the name is used as the tag within the repo.
# Name format can be either tag.dockerfile or Dockerfile.tag

set -e

REPO="khronosgroup/docker-images"

(
    cd $(dirname $0)
    DOCKERFILE=$1
    shift
    TAG=${DOCKERFILE#Dockerfile.}
    TAG=${TAG%.dockerfile}
    if [ "$TAG" == "Dockerfile" ]; then
        TAG=latest
    fi
    docker build "$@" . -f "$DOCKERFILE" -t "$REPO:$TAG"
    docker push "$REPO:$TAG"
)
