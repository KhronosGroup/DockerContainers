FROM ubuntu:22.04 AS apt-installs

# Install minimal tools required to fetch the rest
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    # wget to download repository keys and CMake tarballs
    # software-properties-common for the apt-add-repository command
    apt install -y -qq wget software-properties-common ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Register new repositories
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    # Latest Git can be fethed from official PPA
    apt-add-repository -y ppa:git-core/ppa ; \
    # Canonical hosts recent GCC compilers in ubuntu-toolchain-r/test
    apt-add-repository -y ppa:ubuntu-toolchain-r/test ; \
    # LLVM hosts most toolchain in separate repos. We only register those absent from ubuntu-toolchain-r/test
    wget -q -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - ; \
    apt-add-repository -y 'deb [arch=amd64] https://apt.llvm.org/jammy/ llvm-toolchain-jammy-16 main' ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install various build tools
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    # ninja, git to download dependencies and build-essential to get linkers, etc.
    # ca-certificates to `git clone` via HTTPS
    # libidn11 which only CMake 3.1.3 depends on, need to symlink version 12 from system repo
    # ruby to run CMock
    apt install -y -qq build-essential ninja-build git ca-certificates libidn12 ruby ; \
    ln -s /usr/lib/x86_64-linux-gnu/libidn.so.12.6.3 /usr/lib/x86_64-linux-gnu/libidn.so.11 ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install GCC
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    apt install -y -qq g++-11 g++-13 g++-11-multilib g++-13-multilib ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install LLVM
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    apt install -y -qq clang-14 clang-16 ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install SFML dependencies
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    # alsa: autoconf libtool pkg-config
    # glew: libxmu-dev libxi-dev libgl-dev @ vcpkg install-time
    #       libglu1-mesa-dev               @ cmake configure-time
    # sfml: libudev-dev libx11-dev libxrandr-dev libxcursor-dev
    apt install -y -qq autoconf libtool pkg-config libxmu-dev libxi-dev libgl-dev libglu1-mesa-dev libudev-dev libx11-dev libxrandr-dev libxcursor-dev ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install Vcpkg dependencies
RUN set -ex ; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt update -qq ; \
    # alsa: autoconf libtool
    apt install -y -qq curl zip unzip tar ; \
    # clean up apt temporary files
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

# Install CMake minimum (3.0.2 (Headers, ICD Loader), 3.1.3 (CLHPP), 3.10.3 (SDK)) and latest (3.26.4)
RUN mkdir -p /opt/Kitware/CMake ; \
    wget -c https://github.com/Kitware/CMake/releases/download/v3.0.2/cmake-3.0.2-Linux-i386.tar.gz -O - | tar -xz --directory /opt/Kitware/CMake ; \
    mv /opt/Kitware/CMake/cmake-3.0.2-Linux-i386 /opt/Kitware/CMake/3.0.2 ; \
    wget -c https://github.com/Kitware/CMake/releases/download/v3.1.3/cmake-3.1.3-Linux-x86_64.tar.gz -O - | tar -xz --directory /opt/Kitware/CMake ; \
    mv /opt/Kitware/CMake/cmake-3.1.3-Linux-x86_64 /opt/Kitware/CMake/3.1.3 ; \
    wget -c https://github.com/Kitware/CMake/releases/download/v3.10.3/cmake-3.10.3-Linux-x86_64.tar.gz -O - | tar -xz --directory /opt/Kitware/CMake ; \
    mv /opt/Kitware/CMake/cmake-3.10.3-Linux-x86_64 /opt/Kitware/CMake/3.10.3 ; \
    wget -c https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4-linux-x86_64.tar.gz -O - | tar -xz --directory /opt/Kitware/CMake ; \
    mv /opt/Kitware/CMake/cmake-3.26.4-linux-x86_64 /opt/Kitware/CMake/3.26.4

# Install Vcpkg
RUN git clone --depth 1 https://github.com/Microsoft/vcpkg.git /opt/Microsoft/vcpkg ; \
    /opt/Microsoft/vcpkg/bootstrap-vcpkg.sh ; \
    # install SFML, TCLAP, GLM, GLEW
    /opt/Microsoft/vcpkg/vcpkg install sfml tclap glm glew ; \
    rm -rf /opt/Microsoft/vcpkg/buildtrees ; \
    rm -rf /opt/Microsoft/vcpkg/downloads
