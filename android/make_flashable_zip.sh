#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hBlock
# License:    MIT, https://opensource.org/licenses/MIT

# Exit on errors
set -eu

# Globals
dir=$(dirname "$(readlink -f "$0")")
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
cd "$dir"

$shell ../hblock -O ./hosts -H "$header"
zip -rT ./hblock.zip .

