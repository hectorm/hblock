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

	export HBLOCK_HEADER=''
	export HBLOCK_SOURCES="file://${hosts:?}"
	export HBLOCK_TEMPLATE='address=\/\1\/\2'
	export HBLOCK_COMMENT='#'

	${hblock:?} -H 'builtin' -F 'builtin' -S 'builtin' -A 'builtin' -D 'builtin' -qO-
}

main "${@}"
