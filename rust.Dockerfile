# Copyright 2019-2022 The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

# This defines a docker image for generating and buld-testing
# Rust bindings to the Vulkan API.

FROM rust:latest
LABEL maintainer="Marijn Suijten <marijn@traverseresearch.nl>"

# Git for cloning repos, libclang-dev for running bindgen
RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends \
    git \
    libclang-dev

# Preinstall additional Rust tools needed to clean and lint
# generated bindings
RUN rustup component add rustfmt clippy
