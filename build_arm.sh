#!/bin/sh 
#编译gdb for am335x

#建立常用目录
PWD=`pwd`
BUILD_PATH=${PWD}
mkdir -p ${PWD}/build_arm

#编译ncurse库
tar -xzf ncurses-5.9.tar.gz
cd ncurses-5.9
./configure --host=arm-linux-gnueabihf --prefix=${BUILD_PATH}/build_arm --without-ada --enable-temcap --with-shared 
make
make install

#编译gdb
cd ${BUILD_PATH}
tar -xjf gdb-7.6.tar.bz2
cd gdb-7.6
./configure --host=arm-linux-gnueabihf --enable-shared --prefix=${BUILD_PATH}/build_arm --without-x  --disable-gdbtk --disable-tui --without-include-regex --without-include-gettext LDFLAGS="-L${PWD}/build_arm/lib" CPPFLAGS="-I{PWD}/build_arm/include"
make
make install

cd ${BUILD_PATH}/build_arm
mkdir target
cp -fr bin target
cp -fr lib target
cp -fr ${BUILD_PATH}/libexpat.so.1 target/lib
arm-linux-gnueabihf-strip target/bin/*
arm-linux-gnueabihf-strip target/lib/*
tar -cjf gdb_arm.tar.bz2 target
