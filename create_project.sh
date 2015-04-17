#!/bin/bash

path="$(dirname "$0")"

DST_DIR=$1
LIBRARY_NAME=$2

if [ ! "$DST_DIR" ] || [ ! "$LIBRARY_NAME" ]; then
	echo "Usage: $0 newProjectDir pluginName"
	exit -1
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
dir="$(pwd)"
path="$dir"
popd > /dev/null

if [ ! -d "$DST_DIR" ]; then
	mkdir -pv "$DST_DIR"
fi

# Copy files
echo "Copying files to ($DST_DIR) ... "
cp -R "$path"/* "$DST_DIR"
checkError

# Remove unneeded scripts from destination.
rm -f "$DST_DIR"/create_project.sh
rm -f "$DST_DIR"/create_project.bat

# PLUGIN_NAME substitution
echo "Updating with name ($LIBRARY_NAME) ..."
pushd "$DST_DIR" > /dev/null
	find . | while read file; do
		# Rename any file called PLUGIN_NAME to the proper name
		if [ -e "$file" ] && [[ "$file" == *PLUGIN_NAME* ]]; then
			newFile="$(echo "$file" | sed "s/PLUGIN_NAME/$LIBRARY_NAME/g")"
			mv "$file" "$newFile"
			file="$newFile"
			checkError
		fi

		# Replace string PLUGIN_NAME inside the files with proper name 
		if [ ! -d "$file" ]; then
			export LANG=C
			sed -i '' "s/PLUGIN_NAME/$LIBRARY_NAME/g" "$file"
			checkError
		fi
	done

popd > /dev/null
echo "Done."

echo "SUCCESS: New project for ($LIBRARY_NAME) located at ($DST_DIR)."