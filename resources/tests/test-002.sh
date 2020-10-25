#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${0:?}")" && pwd -P)"

main() {
	hblock="${1:-hblock}"

	# shellcheck disable=SC1090
	. "${SCRIPT_DIR:?}"/env.sh

	export HBLOCK_SOURCES=''

	expected="$(cat -- "${SCRIPT_DIR:?}"/test-002.out)"
	obtained="$("${TEST_SHELL:?}" "${hblock:?}" -qO- 2>&1 ||:)"

	if [ "${obtained?}" = "${expected?}" ]; then
		printf -- 'Test 002 - OK\n'
		exit 0
	else
		printf -- 'Test 002 - FAIL\n' >&2
		printf -- 'Expected:\n\n%s\n\n' "${expected?}" >&2
		printf -- 'Obtained:\n\n%s\n\n' "${obtained?}" >&2
		exit 1
	fi
}

main "${@-}"
