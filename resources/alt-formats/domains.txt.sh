#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

main() {
	hosts="${1:-/etc/hosts}"
	hblock="${2:-hblock}"
	#resourcesDir="${3:-./resources}"

	$hblock -qO- \
		--sources "file://$hosts" \
		--header '' \
		--footer '' \
		--template '\1' \
		--comment ''
}

main "$@"
