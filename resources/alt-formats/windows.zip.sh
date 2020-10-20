#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

main() {
	hosts="${1:-/etc/hosts}"
	#hblock="${2:-hblock}"
	resourcesDir="${3:-./resources}"

	zip="$(printf -- '%s\n' "${TMPDIR:-/tmp}"/hblock.${$-}.zip)"
	trap 'rm -f ${zip:?}; trap - EXIT; exit 0' EXIT TERM INT HUP

	(cd "${resourcesDir:?}"/alt-formats/windows/ && zip -qrl "${zip:?}" ./)
	(cd "$(dirname "${hosts:?}")" && zip -ql "${zip:?}" "$(basename "${hosts:?}")")
	cat "${zip:?}"
}

main "${@-}"
