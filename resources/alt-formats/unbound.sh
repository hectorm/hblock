#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

ENL="$(printf '\\\nx')"; ENL="${ENL%x}"

main() {
	hblock="./hblock"
	hosts="${1:?}"

	$hblock -qO- \
		--sources "file://$hosts" \
		--header '' \
		--footer '' \
		--template 'local-zone: "\1" redirect'"$ENL"'local-data: "\1 A \2"' \
		--comment '#'
}

main "$@"
