#!/bin/bash
# Copyright 2019-2021, The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

# Pass a dockerfile name.
# The tag portion of the name is used as the tag within the repo.
# Name format can be either tag.dockerfile or Dockerfile.tag

set -e

./build-and-push-one.sh Dockerfile.openxr-base.*
./build-and-push-one.sh Dockerfile.openxr.*
./build-and-push-one.sh Dockerfile.openxr-sdk.*
./build-and-push-one.sh Dockerfile.openxr-pregenerated-sdk-base.*
./build-and-push-one.sh Dockerfile.openxr-pregenerated-sdk.*
