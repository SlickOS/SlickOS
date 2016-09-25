#!/bin/bash

GCC=6.2.0
BUTIL=2.27
TARGET=x86_64-elf
DEST=`pwd -P`/Tools
DESTSYS=$DEST/Sys
CORES=`nproc`

mkdir -p .TMPTOOL
cd .TMPTOOL

wget http://ftp.gnu.org/gnu/gcc/gcc-$GCC/gcc-$GCC.tar.bz2
wget http://ftp.gnu.org/gnu/binutils/binutils-$BUTIL.tar.bz2

tar -xvf gcc-$GCC.tar.bz2
tar -xvf binutils-$BUTIL.tar.bz2

cd gcc-$GCC
contrib/download_prerequisites

cd ..

mkdir -p gcc-sys
mkdir -p binutils-sys
mkdir -p gcc
mkdir -p binutils

cd binutils-sys
../binutils-$BUTIL/configure --prefix=$DESTSYS --with-sysroot --disable-nls --disable-werror
make -j$CORES
make install

cd ../gcc-sys
../gcc-$GCC/configure --prefix=$DESTSYS --disable-nls --enable-languages=c,c++
make -j$CORES
make install

cd ..

CC=$DESTSYS/bin/gcc-6.2.0
CXX=$DESTSYS/bin/g++-6.2.0
CPP=$DESTSYS/bin/cpp-6.2.0
LD=$DESTSYS/bin/gcc-6.2.0

cd binutils
../binutils-$BUTIL/configure --target=$TARGET --prefix=$DEST --with-sysroot --disable-nls --disable-werror --program-prefix=$TARGET- --program-suffix=-$BUTIL
make -j$CORES
make install

cd ../gcc
../gcc-$GCC/configure --target=$TARGET --prefix=$DEST --disable-nls --enable-languages=c,c++ --without-headers --program-prefix=$TARGET- --program-suffix=-$GCC
make all-gcc -j$CORES
make all-target-libgcc -j$CORES
make install-gcc
make install-target-libgcc

cd ../../
rm -rf .TMPTOOL