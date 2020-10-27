#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${0:?}")" && pwd -P)"

export HOSTNAME='hblock'
export HBLOCK_OUTPUT_FILE='/dev/null'
export HBLOCK_HEADER_FILE='builtin'
export HBLOCK_FOOTER_FILE='builtin'
export HBLOCK_SOURCES_FILE='builtin'
export HBLOCK_SOURCES="file://${SCRIPT_DIR:?}/sources.txt"
export HBLOCK_ALLOWLIST_FILE='builtin'
export HBLOCK_DENYLIST_FILE='builtin'

runInTestShell() {
	${TEST_SHELL:-/bin/sh} -- "${@-}" 2>&1 ||:
}

assertEquals() {
	actual="${1?}"; expected="${2?}"
	if [ "${actual?}" != "${expected?}" ]; then
		printf -- '\nError, values are not equal\n\n' >&2
		printf -- '[Actual]:\n\n%s\n\n' "${actual?}" >&2
		printf -- '[Expected]:\n\n%s\n\n' "${expected?}" >&2
		return 1
	fi
	return 0
}
