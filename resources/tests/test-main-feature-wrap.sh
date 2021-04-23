#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${0:?}")" && pwd -P)"

# shellcheck disable=SC1091
. "${SCRIPT_DIR:?}"/env.sh

main() {
	export HBLOCK_SOURCES="file://${SCRIPT_DIR:?}/test-domains-source.txt"
	export HBLOCK_WRAP='1'

	printf 'Test - Main - Wrap: "-W" short option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -W '5')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Wrap: "--wrap" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --wrap='5')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Wrap: "HBLOCK_WRAP" environment variable\n'
	actual="$(set -a; HBLOCK_WRAP='5' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
