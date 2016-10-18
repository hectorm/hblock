#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hBlock
# License:    MIT, https://opensource.org/licenses/MIT

# Exit on errors
set -eu

# Globals
tmpDir=$(mktemp -d "$HOME"/.hblock.XXXXXXXX)
baseUrl='https://github.com/zant95/hBlock/raw/master'

if type bash >/dev/null 2>&1; then
	shell='bash'
else
	shell='sh'
fi

# Process
cd "$tmpDir"

mkdir -p ./META-INF/com/google/android
curl -sL "$baseUrl"/android/META-INF/com/google/android/update-binary > ./META-INF/com/google/android/update-binary
curl -sL "$baseUrl"/android/META-INF/com/google/android/updater-script > ./META-INF/com/google/android/updater-script
curl -sL "$baseUrl"/hblock | $shell -s - -O ./hosts
zip -r "$HOME"/hblock-android.zip .

cd && rm -rf "$tmpDir"

