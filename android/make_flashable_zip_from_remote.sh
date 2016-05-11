#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hBlock
# License:    MIT, https://opensource.org/licenses/MIT

# Exit on errors
set -eu

# Globals
remote='https://raw.githubusercontent.com/zant95/hblock/master'
dir="$HOME/.hblock.tmp"
header='
127.0.0.1       localhost
::1             ip6-localhost
'

if type bash > /dev/null; then
	shell='bash'
else
	shell='sh'
fi

# Process:
rm -rf "$dir"
mkdir -p "$dir/META-INF/com/google/android"
cd "$dir"

curl -sL "$remote/android/META-INF/com/google/android/update-binary" > ./META-INF/com/google/android/update-binary
curl -sL "$remote/android/META-INF/com/google/android/updater-script" > ./META-INF/com/google/android/updater-script
curl -sL "$remote/hblock" | $shell -s - -O ./hosts -H "$header"
zip -rT "$HOME/hblock.zip" .

cd && rm -rf "$dir"

