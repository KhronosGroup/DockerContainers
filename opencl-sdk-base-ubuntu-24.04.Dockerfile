FROM ubuntu:24.04

# Everything comes from Ubuntu's own repositories (no PPAs), and the sample
# dependencies are installed here, so CI jobs using this image need no apt-get.

# Install various build tools
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    # wget to download CMake tarballs
    # ninja, git to download dependencies and build-essential to get linkers, etc.
    # ca-certificates to `git clone` via HTTPS
    # ruby to run CMock
    # cmake for jobs that use the system CMake
    apt install -y -qq wget build-essential ninja-build git ca-certificates ruby cmake ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install GCC and LLVM
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    apt install -y -qq g++-13 g++-14 g++-13-multilib g++-14-multilib clang-18 ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install the dependencies of the SDK samples, and of SFML when it is built from source
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    # samples: libvulkan-dev libsfml-dev libglm-dev libglew-dev libtclap-dev libstb-dev libfreetype-dev
    # sfml from source: autoconf libtool pkg-config libudev-dev libx11-dev libxrandr-dev libxcursor-dev
    # glew from source: libxmu-dev libxi-dev libgl-dev libglu1-mesa-dev
    apt install -y -qq libvulkan-dev libsfml-dev libglm-dev libglew-dev libtclap-dev libstb-dev libfreetype-dev \
        autoconf libtool pkg-config libudev-dev libx11-dev libxrandr-dev libxcursor-dev \
        libxmu-dev libxi-dev libgl-dev libglu1-mesa-dev ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install CMake 3.26.4
RUN mkdir -p /opt/Kitware/CMake ; \
    wget -q -c https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4-linux-x86_64.tar.gz -O - | tar -xz --directory /opt/Kitware/CMake ; \
    mv /opt/Kitware/CMake/cmake-3.26.4-linux-x86_64 /opt/Kitware/CMake/3.26.4
