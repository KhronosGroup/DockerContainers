# Copyright 2019-2021 The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

# This is a Docker container for Vulkan specification builds.
# It just layers the Roswell implementation of the asciidoctor chunker onto
# the asciidoctor-spec base image.

from khronosgroup/docker-images:asciidoctor-spec
label maintainer="Jon Leech <devrel@oddhack.org>"

# Install Roswell and asciidoctor-chunker.
# We need at least this specific version of Roswell.
# A specific commit of the chunker is pulled because the old Common Lisp
# version of the chunker was moved after this commit.
run curl -fsSL -o roswell.deb https://github.com/roswell/roswell/releases/download/v20.01.14.104/roswell_20.01.14.104-1_amd64.deb && \
    dpkg -i roswell.deb && \
    ros install alexandria lquery cl-fad
run mkdir -p $HOME/common-lisp && \
    cd $HOME/common-lisp && \
    git clone https://github.com/wshito/asciidoctor-chunker.git && \
    cd asciidoctor-chunker && \
    git checkout -q e01f15ede36346924cd11adfa6a966183dbab412
