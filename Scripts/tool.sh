#!/bin/bash

GCC_VERSION=6.2.0
BINUTILS_VERSION=2.27

TARGET=x86_64-elf
#-----------------------------------------------------------------------------#
# Don't change anything below this line.                                      #
#-----------------------------------------------------------------------------#
CORES=`nproc`

GCC_DIR=gcc-$GCC_VERSION
BINUTILS_DIR=binutils-$BINUTILS_VERSION
GCC_TAR=$GCC_DIR.tar.bz2
BINUTILS_TAR=$BINUTILS_DIR.tar.bz2

GCC_URL=ftp://ftp.gnu.org/gnu/gcc/$GCC_DIR/$GCC_TAR
BINUTILS_URL=ftp://ftp.gnu.org/gnu/binutils/$BINUTILS_TAR
BOCHS_URL=http://svn.code.sf.net/p/bochs/code/trunk/bochs

mkdir .TMPTOOL
cd .TMPTOOL

wget $GCC_URL
wget $BINUTILS_URL
svn co $BOCHS_URL bochs

tar -xvf $GCC_TAR
tar -xvf $BINUTILS_TAR

cd $GCC_DIR
./contrib/download_prerequisites
cd ..

mkdir binutils-sys
cd binutils-sys
../$BINUTILS_DIR/configure --disable-nls --disable-werror --with-sysroot
make -j$CORES
sudo make install
cd ..

mkdir gcc-sys
cd gcc-sys
../$GCC_DIR/configure --disable-nls --enable-languages=c,c++
make -j$CORES
sudo make install
cd ..

mkdir binutils-os
cd binutils-os
../$BINUTILS_DIR/configure --target=$TARGET --program-prefix=os- --with-sysroot --disable-nls --disable-werror
make -j$CORES
sudo make install
cd ..

mkdir gcc-os
cd gcc-os
../$GCC_DIR/configure --target=$TARGET --program-prefix=os- --disable-nls --enable-languages=c,c++ --without-headers
make -j$CORES all-gcc
make -j$CORES all-target-libgcc
sudo make install-gcc
sudo make install-target-libgcc
cd ..

cd bochs
./configure --with-sdl2 --enable-smp --enable-x86-64 --enable-vmx --enable-svm --enable-avx --enable-x86-debugger --enable-long-phy-address --enable-sb16 --enable-es1370 --enable-gameport --enable-ne2000 --enable-pnic --enable-e1000 --enable-clgd54xx --enable-voodoo --enable-plugins --enable-all-optimizations --enable-debugger
sed -i '/#define BX_NETMOD_FBSD 1/c\#define BX_NETMOD_FBSD 0' config.h
make -j$CORES
sudo make install
cd ..

cd ..
rm -rf .TMPTOOL
