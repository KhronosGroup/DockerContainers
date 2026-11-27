FROM khronosgroup/docker-images:opencl-sdk-base-ubuntu-24.04
ARG INTEL_OCL_URL=https://github.com/intel/llvm/releases/download/2025-WW13/oclcpuexp-2025.19.3.0.17_230222_rel.tar.gz
ARG INTEL_TBB_URL=https://github.com/uxlfoundation/oneTBB/releases/download/v2023.0.0/oneapi-tbb-2023.0.0-lin.tgz
RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive ; \
    mkdir -p /opt/Intel/oclcpuexp ; \
    wget -q -c -O - $INTEL_OCL_URL | tar -xz --directory /opt/Intel/oclcpuexp ; \
    wget -q -c -O - $INTEL_TBB_URL | tar -xz --directory /opt/Intel ; \
    mv /opt/Intel/oneapi-tbb* /opt/Intel/oneapi-tbb ; \
    ln -s /opt/Intel/oneapi-tbb/lib/intel64/gcc4.8/libtbb.so         /opt/Intel/oclcpuexp/x64/libtbb.so ; \
    ln -s /opt/Intel/oneapi-tbb/lib/intel64/gcc4.8/libtbbmalloc.so   /opt/Intel/oclcpuexp/x64/libtbbmalloc.so ; \
    ln -s /opt/Intel/oneapi-tbb/lib/intel64/gcc4.8/libtbb.so.12      /opt/Intel/oclcpuexp/x64/libtbb.so.12 ; \
    ln -s /opt/Intel/oneapi-tbb/lib/intel64/gcc4.8/libtbbmalloc.so.2 /opt/Intel/oclcpuexp/x64/libtbbmalloc.so.2 ; \
    mkdir -p /etc/OpenCL/vendors ; \
    echo /opt/Intel/oclcpuexp/x64/libintelocl.so | tee /etc/OpenCL/vendors/intel_expcpu.icd ; \
    echo /opt/Intel/oclcpuexp/x64 | tee /etc/ld.so.conf.d/libintelopenclexp.conf ; \
    ldconfig
# PoCL from Ubuntu, for samples of extensions the Intel CPU runtime lacks (cl_khr_command_buffer)
RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive ; \
    apt-get update -qq ; \
    apt-get install -y --no-install-recommends pocl-opencl-icd ; \
    rm -rf /var/lib/apt/lists/*
