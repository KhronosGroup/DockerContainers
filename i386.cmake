# SPDX-License-Identifier: CC0-1.0
# SPDX-FileCopyrightText: 2019-2020 Collabora, Ltd.

# Required these packages to build OpenXR SDK:
# gcc-multilib g++-multilib linux-libc-dev:i386 libgl1-mesa-dev:i386 libvulkan-dev:i386 libx11-xcb-dev:i386 libxcb-dri2-0-dev:i386 libxcb-glx0-dev:i386 libxcb-icccm4-dev:i386 libxcb-keysyms1-dev:i386 libxcb-randr0-dev:i386 libxrandr-dev:i386 libxxf86vm-dev:i386 mesa-common-dev:i386
# the name of the target operating system
set(CMAKE_SYSTEM_NAME Linux)

# which compilers to use for C and C++
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
set(CMAKE_SYSTEM_LIBRARY_PATH /usr/lib/i386-linux-gnu)

# here is the target environment located
# set(CMAKE_FIND_ROOT_PATH   /usr/i486-linux-gnu )

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
