#!/bin/bash

export PATH="/root/realme/toolchains/clang-11.0.1/bin:$PATH"
export ARCH=arm64
export SUBARCH=arm64
export COMPILE_PLATFORM=oppo6769
export OPPO_COMPILE_PLATFORM=oppo6769
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

export KCFLAGS="-w"
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

make -C $(pwd) O=$(pwd)/out ARCH=arm64 CC=clang LD=ld.lld NM=llvm-nm OBJCOPY=llvm-objcopy oppo6769_defconfig
make -C $(pwd) O=$(pwd)/out ARCH=arm64 CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip HOSTCC=clang HOSTLD=ld.lld -j4
