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

# Run this container with a non-root user, optionally specified by the
# external environment variables USERID, GROUPID, USER, and GROUP.
USERID=${USERID-1000}
GROUPID=${GROUPID-100}
USER=${USER-vulkan}
GROUP=${GROUP-users}

if egrep -q ":$GROUPID:|^$GROUP:" /etc/group ; then
    true
    # echo "** Not creating group $GROUP id $GROUPID; group line is"
    # egrep ":$GROUPID:|^$GROUP:" /etc/group
else
    echo "** Creating group $GROUP id $GROUPID"
    groupadd -g $GROUPID -r $GROUP > /dev/null || true
fi

if egrep -q ":$USERID:|^$USER:" /etc/passwd ; then
    true
    # echo "** Not creating user $USER id $USERID; passwd line is"
    # egrep ":$USERID:|^$USER:" /etc/passwd
else
    echo "** Creating user $USER id $USERID"
    useradd -u $USERID --create-home -r -g $GROUP $USER || true
fi

export HOME=/home/$USER
export USER

# This is a temporary workaround until the JavaScript version of the chunker
# is supported. If running as non-root, link to the neccessary user install
# directories for the chunker.
if test $USER != root ; then
    ln -s /root/common-lisp $HOME/common-lisp
    ln -s /root/.roswell $HOME/.roswell
fi

echo "HOME=$HOME USER=$USER CONTAINER_CWD=$CONTAINER_CWD"

if [ "${CONTAINER_CWD}" ]; then
    cd ${CONTAINER_CWD}
fi

# Default to 'bash' if no arguments are provided
args="$@"
if [ -z "$args" ]; then
    args=/bin/bash
else
    # Actually, always use it, because CI appears to be passing in some horrid bash script as the arguments
    echo -n "** ignoring entrypoint.vulkan.sh args - length was "
    echo $args | wc -c
    args=/bin/bash
fi

echo "** About to gosu $USER $args"
exec gosu $USER $args
echo "** After gosu - should not reach this point"
