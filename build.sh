#!/bin/bash

path=$(dirname "$0")

BUILD_NUMBER=$1
BUILD_DIR=$2
LIBRARY_NAME="PLUGIN_NAME"

LUA_COMPILER_URL="https://raw.githubusercontent.com/CoronaLabs/plugins-template-bin/master/luac"

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


if [ ! "$BUILD_NUMBER" ]; then
	usage
fi

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
if [ ! "$BUILD_DIR" ]; then
	BUILD_DIR=$path/build
fi

OUTPUT_DIR=$BUILD_DIR

# Clean build
if [ -e "$OUTPUT_DIR" ]; then
	rm -rf "$OUTPUT_DIR"
fi

# Plugins
OUTPUT_DIR_LUA="$OUTPUT_DIR/plugins/$BUILD_NUMBER/lua"

# Create directories
mkdir -p "$OUTPUT_DIR"
checkError

mkdir -p "$OUTPUT_DIR_LUA"
checkError

# Copy
echo "[copy]"
cp -vrf "$path/lua"/* "$OUTPUT_DIR_LUA"
checkError

# Copy over metadata.json
cp -vrf "$path"/metadata.json "$OUTPUT_DIR"
checkError

# Compile lua files.
if [ "$compile" ]; then
	echo ""
	echo "[compile]"

	# Ensure we have the lua compiler.
	if [ ! -x "./luac" ]; then
		echo "Downloading luac compiler..."
		curl --progress-bar "$LUA_COMPILER_URL" > "luac"
		chmod +x luac
	fi

	# Verify lua integrity.
	if ! ./luac -v | grep -q "^Lua"; then
		echo "ERROR: The lua compiler could not be downloaded."
		echo "Please verify your internet connection."
		exit 100
	fi

	# Compile all lua files into bytecode.
	./luac -v
	find "$OUTPUT_DIR_LUA" -type f -name "*.lua" | while read luaFile; do
		echo "compiling: $luaFile"
		./luac -s -o "$luaFile" -- "$luaFile"
		checkErro
	done
fi

echo ""
echo "[zip]"
ZIP_FILE="$path/build-$LIBRARY_NAME.zip"
cd "$OUTPUT_DIR" > /dev/null
	rm -f "$ZIP_FILE"
	zip -c -x '*.DS_Store' @ "$ZIP_FILE" ./*
cd - > /dev/null

echo ""
echo "[complete]"
echo "Plugin build succeeded."
echo "Zip file located at: '$ZIP_FILE'"
