#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

main() {
	hosts="${1:-/etc/hosts}"
	hblock="${2:-hblock}"
	#resourcesDir="${3:-./resources}"

	# shellcheck disable=SC2155
	export HBLOCK_HEADER="$(cat <<-'EOF'
		$TTL 2h
		@ IN SOA localhost. root.localhost. (1 6h 1h 1w 2h)
		  IN NS  localhost.
	EOF
	)"
	export HBLOCK_SOURCES="file://${hosts:?}"
	export HBLOCK_TEMPLATE='\1 CNAME .'
	export HBLOCK_COMMENT=';'

	${hblock:?} -H 'builtin' -F 'builtin' -S 'builtin' -W 'builtin' -B 'builtin' -qO-
}

main "${@}"
