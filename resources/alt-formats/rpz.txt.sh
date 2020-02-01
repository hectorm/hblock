#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

main() {
	hosts="${1:-/etc/hosts}"
	hblock="${2:-hblock}"
	#resourcesDir="${3:-./resources}"

	HBLOCK_HEADER=$(cat <<-'EOF'
		$TTL 2h
		@ IN SOA localhost. root.localhost. (1 6h 1h 1w 2h)
		  IN NS  localhost.
	EOF
	) \
	HBLOCK_FOOTER='' \
	HBLOCK_SOURCES="file://${hosts:?}" \
	HBLOCK_WHITELIST='' \
	HBLOCK_BLACKLIST='' \
	${hblock:?} -qO- \
		--template '\1 CNAME .' \
		--comment ';'
}

main "$@"
