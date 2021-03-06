#!/usr/bin/env bash

set -x
set -e

# mkdir tmp
# BUILD_PREFIX=$PWD/tmp

CONFIG_OPTS=()
#CONFIG_OPTS+=("CFLAGS=-I${BUILD_PREFIX}/include")
#CONFIG_OPTS+=("CPPFLAGS=-I${BUILD_PREFIX}/include")
#CONFIG_OPTS+=("CXXFLAGS=-I${BUILD_PREFIX}/include")
#CONFIG_OPTS+=("LDFLAGS=-L${BUILD_PREFIX}/lib")
#CONFIG_OPTS+=("PKG_CONFIG_PATH=${BUILD_PREFIX}/lib/pkgconfig")
#CONFIG_OPTS+=("--prefix=${BUILD_PREFIX}")
CONFIG_OPTS+=("--with-docs=no")
CONFIG_OPTS+=("--quiet")
CONFIG_OPTS+=("--with-libsodium=no")

# Clone and build dependencies
# jansson
git clone https://github.com/akheron/jansson.git
cd jansson
autoreconf -i
./configure
make
sudo make install
cd ..
# zmq 4.1.2
wget http://download.zeromq.org/zeromq-4.1.2.tar.gz
tar zxvf zeromq-4.1.2.tar.gz
cd zeromq-4.1.2/
if [ -e autogen.sh ]; then
./autogen.sh 2> /dev/null
fi
if [ -e buildconf ]; then
./buildconf 2> /dev/null
fi
./configure "${CONFIG_OPTS[@]}"
make -j4
sudo make install
cd ..
# czmq 3.0.2
wget https://github.com/zeromq/czmq/archive/v3.0.2.tar.gz
tar zxvf v3.0.2.tar.gz
cd czmq-3.0.2/
if [ -e autogen.sh ]; then
./autogen.sh 2> /dev/null
fi
if [ -e buildconf ]; then
./buildconf 2> /dev/null
fi
./configure "${CONFIG_OPTS[@]}"
make -j4
sudo make install
cd ..
## zyre 1.1.0
wget https://github.com/zeromq/zyre/archive/v1.1.0.tar.gz
tar zxvf v1.1.0.tar.gz
cd zyre-1.1.0/
if [ -e autogen.sh ]; then
./autogen.sh 2> /dev/null
fi
if [ -e buildconf ]; then
./buildconf 2> /dev/null
fi
./configure "${CONFIG_OPTS[@]}"
make -j4
sudo make install
cd ..
mkdir build
cd build
cmake ..
make
make check
