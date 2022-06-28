# Copyright 2019-2021 The Khronos Group Inc.
# SPDX-License-Identifier: Apache-2.0

# This is a Docker container for Vulkan specification builds

from khronosgroup/docker-images:vulkan-docs-base
label maintainer="Jon Leech <devrel@oddhack.org>"

# Add the entrypoint to the image, and ensure files installed in root (under
# .roswell/ and common-lisp/) are accessible by the entrypoint when run as
# other users.
COPY entrypoint.vulkan.sh /root/entrypoint.vulkan.sh
RUN chmod +x /root/entrypoint.vulkan.sh ; chmod go+rx /root

ENTRYPOINT ["/root/entrypoint.vulkan.sh"]
