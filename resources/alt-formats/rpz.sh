#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

main() {
	hosts="${1:?}"

	cat <<-'EOF'
		$TTL 2h
		@ IN SOA localhost. root.localhost. (1 6h 1h 1w 2h)
		  IN NS  localhost.
	EOF
	sed -n \
		-e '/^#.*<blocklist>/,/^#.*<\/blocklist>/!d;/^\s*#.*$/d' \
		-e 's/^\(.\{1,\}\)\s\{1,\}\(.\{1,\}\)\s*/\2 CNAME ./p' \
		"$hosts"
}

main "$@"
