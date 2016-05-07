#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hosts-update
# License:    MIT, https://opensource.org/licenses/MIT

# Exit on errors
set -eu

# Globals
dir=$(dirname "$(readlink -f "$0")")
header='
127.0.0.1       localhost
::1             ip6-localhost
'

# Process:
cd "$dir"

../hosts-update -O ./hosts -H "$header"
zip -r ./hosts-update.zip .

