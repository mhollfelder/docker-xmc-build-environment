# Ubuntu 20.04 32 bit container:
FROM i386/ubuntu:19.04

# Author of file:
LABEL maintainer="Manuel Hollfelder <guessbean@gmail.com>"

# Update (and upgrade) the package manager as well as install make, wget, libncurses5:
RUN apt-get update && \
    # apt-get upgrade && \
    apt-get install -y make wget libncurses5 && \
    rm -rf /var/lib/apt/lists/*

# Set up a tools dev directory
WORKDIR /home/dev

# Pull the gcc-arm-none-eabi tarball, check the MD5 sum and extract it
RUN wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q3-update/+download/gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2 \
    && wget https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q3-update/+download/gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2/+md5 \
    && md5sum -c +md5 \
    && tar xvf gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2 \
    && rm gcc-arm-none-eabi-4_9-2015q3-20150921-linux.tar.bz2 +md5 \
    && mkdir -p tools/binaries && mv gcc-arm-none-eabi-4_9-2015q3/ ./tools/binaries/ARM-GCC-49
