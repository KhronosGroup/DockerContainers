#!/bin/bash
# Copyright (c) 2019 The Khronos Group, Inc.
# Copyright (c) 2019 Collabora, Ltd
# Copyright (c) 2017-2018 Sensics, Inc.
# Copyright (c) 2014 Kyle Manna
# SPDX-License-Identifier: MIT

# Based in part on:
# https://github.com/kylemanna/docker-aosp/blob/master/utils/docker_entrypoint.sh
# https://github.com/sensics/tegra-android-builder/blob/master/content/docker_entrypoint.sh

set -e

# Script allows running this container
# with a non-root user matching
# the external-to-container user

# Defaults
if [ -z ${USER_ID+x} ]; then USER_ID=1000; fi
if [ -z ${GROUP_ID+x} ]; then GROUP_ID=1000; fi

USER_GROUP=openxr_container

echo "Creating user and group $USER_GROUP:$USER_GROUP with ID ${USER_ID}:${GROUP_ID}"
groupadd -g $GROUP_ID -r $USER_GROUP > /dev/null && \
useradd -u $USER_ID --create-home -r -g $USER_GROUP $USER_GROUP

export HOME=/home/$USER_GROUP
export USER=$USER_GROUP


if [ "${CONTAINER_CWD}" ]; then
    cd ${CONTAINER_CWD}
fi

# Default to 'bash' if no arguments are provided
args="$@"
if [ -z "$args" ]; then
  args="bash"
fi

exec gosu $USER_GROUP $args
