#!/bin/bash

path=$(dirname "$0")

LIBRARY_NAME="PLUGIN_NAME"

# Set to false if you do not want to compile your lua files into bytecode.
compile=true

# Verify arguments
usage() {
	echo "$0 daily_build_number [dst_dir]"
	echo ""
	echo "  daily_build_number: The daily build number, e.g. 2015.2560"
	echo "  dst_dir: If not provided, will be '$path/build'"
	exit -1
}

# Checks exit value for error
checkError() {
	if [ $? -ne 0 ]; then
		echo "Exiting due to errors (above)"
		exit -1
	fi
}

# Canonicalize relative paths to absolute paths
pushd "$path" > /dev/null
dir=$(pwd)
path=$dir
popd > /dev/null

# Defaults
BUILD_DIR="$path/build"

# Clean build
if [ -e "$BUILD_DIR" ]; then
	rm -rf "$BUILD_DIR"
fi

# Create directories
mkdir -p "$BUILD_DIR"
checkError

# Copy
echo "[copy]"
cp -vrf "$path/plugins" "$BUILD_DIR"
checkError

cp -vrf "$path"/metadata.json "$BUILD_DIR"
checkError

# Compile lua files.
LUAC="$path/bin/luac"
if [ "$compile" ]; then
	echo ""
	echo "[compile]"
	
	"$LUAC" -v
	checkError
	
	find "$BUILD_DIR" -type f -name "*.lua" | while read luaFile; do
		echo "compiling: $luaFile"
		"$LUAC" -s -o "$luaFile" -- "$luaFile"
		checkError
	done
	checkError
fi

echo ""
echo "[zip]"
ZIP_FILE="$path/build-$LIBRARY_NAME.zip"
cd "$BUILD_DIR" > /dev/null
	rm -f "$ZIP_FILE"
	zip -r -x '*.DS_Store' @ "$ZIP_FILE" ./*
cd - > /dev/null

echo ""
echo "[complete]"
echo "Plugin build succeeded."
echo "Zip file located at: '$ZIP_FILE'"
