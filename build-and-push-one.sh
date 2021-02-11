#!/bin/bash
# SPDX-License-Identifier: Apache-2.0

# Pass a dockerfile name.
# The dockerfile's extension is used as the tag within the repo.

set -e

REPO="khronosgroup/docker-images"

(
    cd $(dirname $0)
    DOCKERFILE=$1
    shift
    TAG=${DOCKERFILE#Dockerfile.}
    if [ "$TAG" == "Dockerfile" ]; then
        TAG=latest
    fi
    docker build "$@" . -f "$DOCKERFILE" -t "$REPO:$TAG"
    docker push "$REPO:$TAG"
)
