#!/bin/bash

SCRIPT_REPO="https://github.com/acoustid/chromaprint.git"
SCRIPT_COMMIT="aa67c95b9e486884a6d3ee8b0c91207d8c2b0551"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" chromaprint
    cd chromaprint

    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_SHARED_LIBS=OFF -DBUILD_TOOLS=OFF -DBUILD_TESTS=OFF -DFFT_LIB=fftw3f ..
    make -j$(nproc)
    make install

    echo "Libs.private: -lfftw3f -lstdc++" >> "$FFBUILD_PREFIX"/lib/pkgconfig/libchromaprint.pc
    echo "Cflags.private: -DCHROMAPRINT_NODLL" >> "$FFBUILD_PREFIX"/lib/pkgconfig/libchromaprint.pc
}

ffbuild_configure() {
    echo --enable-chromaprint
}

ffbuild_unconfigure() {
    echo --disable-chromaprint
}
