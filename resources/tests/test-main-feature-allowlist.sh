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
	export HBLOCK_ALLOWLIST_FILE=''

	printf 'Test - Main - Allowlist: "-A" short option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -A "${SCRIPT_DIR:?}/allowlist.txt")"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Allowlist: "--allowlist" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --allowlist="${SCRIPT_DIR:?}/allowlist.txt")"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Allowlist: "--allowlist" long option with "builtin" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --allowlist='builtin')"
	expected="$(cat -- "${0%.sh}"-builtin.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Allowlist: "--allowlist" long option with "none" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --allowlist='none')"
	expected="$(cat -- "${0%.sh}"-none.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Allowlist: "--allowlist" long option with "-" value\n'
	actual="$(cat -- "${SCRIPT_DIR:?}/allowlist.txt" | runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --allowlist='-')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Allowlist: "--allowlist" long option with a non-existent file\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --allowlist='/hblock/invalid.txt')"
	expected="$(cat -- "${0%.sh}"-invalid.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Allowlist: "HBLOCK_ALLOWLIST_FILE" environment variable\n'
	actual="$(set -a; HBLOCK_ALLOWLIST_FILE="${SCRIPT_DIR:?}/allowlist.txt" runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Allowlist: "HBLOCK_ALLOWLIST_FILE" environment variable with a non-existent file\n'
	actual="$(set -a; HBLOCK_ALLOWLIST_FILE='/hblock/invalid.txt' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}"-invalid.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Allowlist: "HBLOCK_ALLOWLIST" environment variable\n'
	actual="$(set -a; HBLOCK_ALLOWLIST="$(cat -- "${SCRIPT_DIR:?}/allowlist.txt")" runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
