#!/bin/bash
# Copyright 2019-2021, The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0
set -e

./build-and-push-one.sh Dockerfile.openxr-base.*
./build-and-push-one.sh Dockerfile.openxr.*
./build-and-push-one.sh Dockerfile.openxr-sdk.*
./build-and-push-one.sh Dockerfile.openxr-pregenerated-sdk.*
