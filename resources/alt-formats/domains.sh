#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

main() {
	hosts="${1:?}"

	sed -n \
		-e '/^#.*<blocklist>/,/^#.*<\/blocklist>/!d;/^\s*#.*$/d' \
		-e 's/^\(.\{1,\}\)\s\{1,\}\(.\{1,\}\)\s*/\2/p' \
		"$hosts"
}

main "$@"
