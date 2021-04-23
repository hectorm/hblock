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
	export HBLOCK_DENYLIST_FILE=''

	printf 'Test - Main - Denylist: "-D" short option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -D "${SCRIPT_DIR:?}/denylist.txt")"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Denylist: "--denylist" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --denylist="${SCRIPT_DIR:?}/denylist.txt")"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Denylist: "--denylist" long option with "builtin" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --denylist='builtin')"
	expected="$(cat -- "${0%.sh}"-builtin.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Denylist: "--denylist" long option with "none" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --denylist='none')"
	expected="$(cat -- "${0%.sh}"-none.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Denylist: "--denylist" long option with "-" value\n'
	actual="$(cat -- "${SCRIPT_DIR:?}/denylist.txt" | runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --denylist='-')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Denylist: "--denylist" long option with a non-existent file\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --denylist='/hblock/invalid.txt')"
	expected="$(cat -- "${0%.sh}"-invalid.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Denylist: "HBLOCK_DENYLIST_FILE" environment variable\n'
	actual="$(set -a; HBLOCK_DENYLIST_FILE="${SCRIPT_DIR:?}/denylist.txt" runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Denylist: "HBLOCK_DENYLIST_FILE" environment variable with a non-existent file\n'
	actual="$(set -a; HBLOCK_DENYLIST_FILE='/hblock/invalid.txt' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}"-invalid.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Denylist: "HBLOCK_DENYLIST" environment variable\n'
	actual="$(set -a; HBLOCK_DENYLIST="$(cat -- "${SCRIPT_DIR:?}/denylist.txt")" runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
