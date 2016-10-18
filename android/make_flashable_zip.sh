#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hBlock
# License:    MIT, https://opensource.org/licenses/MIT

# Exit on errors
set -eu

# Globals
scriptDir=$(dirname "$(readlink -f "$0")")
tmpDir=$(mktemp -d "$scriptDir"/../.hblock.XXXXXXXX)

if type bash >/dev/null 2>&1; then
	shell='bash'
else
	shell='sh'
fi

# Process
cd "$tmpDir"

mkdir -p ./META-INF/com/google/android
cp ../android/META-INF/com/google/android/update-binary ./META-INF/com/google/android/update-binary
cp ../android/META-INF/com/google/android/updater-script ./META-INF/com/google/android/updater-script
$shell ../hblock -O ./hosts
zip -r ../hblock-android.zip .

cd && rm -rf "$tmpDir"
