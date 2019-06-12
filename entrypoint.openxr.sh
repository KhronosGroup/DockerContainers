#!/bin/bash
set -e

# Script allows running this container
# with a non-root user matching
# the external-to-container user

# Defaults
if [ -z ${USER_ID+x} ]; then USER_ID=1000; fi
if [ -z ${GROUP_ID+x} ]; then GROUP_ID=1000; fi

USER_GROUP=openxr_container

echo "Creating user and group $USER_GROUP:$USER_GROUP with ID ${USER_ID}:${GROUP_ID}"
groupadd -g $GROUP_ID -r $USER_GROUP && \
useradd -u $USER_ID --create-home -r -g $USER_GROUP $USER_GROUP

export HOME=/home/$USER_GROUP
export USER=$USER_GROUP


if [ "${CONTAINER_CWD}" ]; then
    cd ${CONTAINER_CWD}
fi

exec gosu $USER_GROUP bash
