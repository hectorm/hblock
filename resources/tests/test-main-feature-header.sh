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
	export HBLOCK_HEADER_FILE=''

	printf 'Test - Main - Header: "-H" short option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -H "${SCRIPT_DIR:?}/header.txt")"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Header: "--header" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --header="${SCRIPT_DIR:?}/header.txt")"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Header: "--header" long option with "builtin" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --header='builtin')"
	expected="$(cat -- "${0%.sh}"-builtin.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Header: "--header" long option with "none" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --header='none')"
	expected="$(cat -- "${0%.sh}"-none.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Header: "--header" long option with "-" value\n'
	actual="$(cat -- "${SCRIPT_DIR:?}/header.txt" | runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --header='-')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Header: "--header" long option with a non-existent file\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --header='/hblock/invalid.txt')"
	expected="$(cat -- "${0%.sh}"-invalid.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Header: "HBLOCK_HEADER_FILE" environment variable\n'
	actual="$(set -a; HBLOCK_HEADER_FILE="${SCRIPT_DIR:?}/header.txt" runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Header: "HBLOCK_HEADER_FILE" environment variable with a non-existent file\n'
	actual="$(set -a; HBLOCK_HEADER_FILE='/hblock/invalid.txt' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}"-invalid.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Header: "HBLOCK_HEADER" environment variable\n'
	actual="$(set -a; HBLOCK_HEADER="$(cat -- "${SCRIPT_DIR:?}/header.txt")" runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
