#!/bin/bash

path=`dirname $0`

BUILD_NUMBER=$1
BUILD_DIR=$2
LIBRARY_NAME="PLUGIN_NAME"


#
# Verify arguments
# 

usage() {
	echo "$0 daily_build_number [dst_dir]"
	echo ""
	echo "  daily_build_number: The daily build number, e.g. 2015.2560"
	echo "  dst_dir: If not provided, will be '$path/build'"
	exit -1
}


if [ ! "$BUILD_NUMBER" ]
then
	usage
fi


#
# Checks exit value for error
# 
checkError() {
    if [ $? -ne 0 ]
    then
        echo "Exiting due to errors (above)"
        exit -1
    fi
}

# 
# Canonicalize relative paths to absolute paths
# 
pushd $path > /dev/null
dir=`pwd`
path=$dir
popd > /dev/null

#
# Defaults
#

if [ ! "$BUILD_DIR" ]
then
	BUILD_DIR=$path/build
fi


#
# OUTPUT_DIR
# 
OUTPUT_DIR=$BUILD_DIR

# Clean build
if [ -e "$OUTPUT_DIR" ]
then
	rm -rf "$OUTPUT_DIR"
fi

# Plugins
OUTPUT_PLUGINS_DIR=$OUTPUT_DIR/plugins
OUTPUT_DIR_LUA=$OUTPUT_PLUGINS_DIR/$BUILD_NUMBER/lua
OUTPUT_DIR_LUA_PLUGIN=$OUTPUT_DIR_LUA/plugin

# Create directories
mkdir -p "$OUTPUT_DIR"
checkError

mkdir -p "$OUTPUT_DIR_LUA"
checkError


#
# Build
#

echo "------------------------------------------------------------------------"
echo "[lua]"
cp -vrf $path/lua/plugin "$OUTPUT_DIR_LUA_PLUGIN"
checkError


echo "------------------------------------------------------------------------"
echo "[metadata.json]"
cp -vrf $path/metadata.json "$OUTPUT_DIR"
checkError


echo "------------------------------------------------------------------------"
echo "Generating plugin zip"
ZIP_FILE=$path/build-${LIBRARY_NAME}.zip
cd "$OUTPUT_DIR"
	zip -rv -x *.DS_Store @ "$ZIP_FILE" *
cd -

echo "------------------------------------------------------------------------"
echo "Plugin build succeeded."
echo "Zip file located at: '$ZIP_FILE'"
