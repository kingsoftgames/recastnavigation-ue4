#!/bin/bash

# 
# Please make sure the following environment variables are set before calling this script:
# RECASTNAVIGATION_UE4_VERSION - Release version string.
# RECASTNAVIGATION_UE4_PREFIX  - Install path prefix string.
#

#set -ex
#RECASTNAVIGATION_UE4_VERSION=4.16
#RECASTNAVIGATION_UE4_PREFIX=./Test

if [ -z "$RECASTNAVIGATION_UE4_VERSION" ]; then
    echo "RECASTNAVIGATION_UE4_VERSION is not set, exit."
    exit 1
else
    echo "RECASTNAVIGATION_UE4_VERSION: $RECASTNAVIGATION_UE4_VERSION"
fi

if [ -z "$RECASTNAVIGATION_UE4_PREFIX" ]; then
    echo "RECASTNAVIGATION_UE4_PREFIX is not set, exit."
    exit 1
else
    echo "RECASTNAVIGATION_UE4_PREFIX: $RECASTNAVIGATION_UE4_PREFIX"
fi

if [ ! -d "$RECASTNAVIGATION_UE4_VERSION" ]; then
    echo "Can not find version $RECASTNAVIGATION_UE4_VERSION, exit."
    exit 2
fi

#Don't display pushd/popd stacks
pushd () {
    command pushd "$@" > /dev/null
}
popd () {
    command popd "$@" > /dev/null
}

pushd $RECASTNAVIGATION_UE4_VERSION

BUILD_TYPE=Debug
if [ "$#" -ge 1 ]; then
    BUILD_TYPE=$1
fi

echo "Generating CMake files for build type: $BUILD_TYPE"
echo "Valid build types are: Debug | Release | RelWithDebInfo | MinSizeRel"

GENERATE_DIR=_intermediate

if [ ! -d "$GENERATE_DIR" ]; then
    mkdir $GENERATE_DIR
fi

pushd $GENERATE_DIR

cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$RECASTNAVIGATION_UE4_PREFIX ../

make
make install

popd # pushd $GENERATE_DIR
popd # pushd $RECASTNAVIGATION_UE4_VERSION
