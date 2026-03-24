# Start with a clean, stable Debian base
FROM debian:bullseye

# Install all the math libraries, parsers, and packaging tools
RUN apt-get update && apt-get install -y \
    build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev \
    texinfo mtools xorriso nasm git wget \
    && rm -rf /var/lib/apt/lists/*

# Set up our environment variables
ENV PREFIX="/opt/cross"
ENV TARGET="x86_64-elf"
ENV PATH="$PREFIX/bin:$PATH"

# Build Binutils (Assembler and Linker)
WORKDIR /tmp/src
RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz && \
    tar -xf binutils-2.42.tar.gz && \
    mkdir build-binutils && cd build-binutils && \
    ../binutils-2.42/configure --target=$TARGET --prefix=$PREFIX --with-sysroot --disable-nls --disable-werror && \
    make -j2 && make install && \
    rm -rf /tmp/src/*

# Build GCC (The C Compiler)
RUN wget https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz && \
    tar -xf gcc-13.2.0.tar.gz && \
    mkdir build-gcc && cd build-gcc && \
    ../gcc-13.2.0/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers && \
    make all-gcc -j$(nproc) && make all-target-libgcc -j2 && \
    make install-gcc && make install-target-libgcc && \
    rm -rf /tmp/src/*

# Tell the container where our OS source code will live
WORKDIR /workspace
