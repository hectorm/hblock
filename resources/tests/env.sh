#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${0:?}")" && pwd -P)"

# Set base environment.
export HOSTNAME='hblock'
export ETCDIR="${SCRIPT_DIR:?}/etc"
export XDG_CONFIG_HOME="${ETCDIR:?}"
export SOURCE_DATE_EPOCH='0'
export HBLOCK_VERSION='0.0.0'
export HBLOCK_REPOSITORY='https://example.com'

runInTestShell() {
	${TEST_SHELL:-/bin/sh} -- "${@-}" 2>&1 ||:
}

assertEquals() {
	actual="${1?}"; expected="${2?}"
	if [ "${actual?}" != "${expected?}" ]; then
		printf '\nError, values are not equal\n\n' >&2
		printf '[Actual]:\n\n%s\n\n' "${actual?}" >&2
		printf '[Expected]:\n\n%s\n\n' "${expected?}" >&2
		return 1
	fi
	return 0
}
