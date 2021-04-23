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
	export HBLOCK_FOOTER_FILE=''

	printf 'Test - Main - Footer: "-F" short option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -F "${SCRIPT_DIR:?}/footer.txt")"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Footer: "--footer" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --footer="${SCRIPT_DIR:?}/footer.txt")"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Footer: "--footer" long option with "builtin" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --footer='builtin')"
	expected="$(cat -- "${0%.sh}"-builtin.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Footer: "--footer" long option with "none" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --footer='none')"
	expected="$(cat -- "${0%.sh}"-none.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Footer: "--footer" long option with "-" value\n'
	actual="$(cat -- "${SCRIPT_DIR:?}/footer.txt" | runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --footer='-')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Footer: "--footer" long option with a non-existent file\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --footer='/hblock/invalid.txt')"
	expected="$(cat -- "${0%.sh}"-invalid.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Footer: "HBLOCK_FOOTER_FILE" environment variable\n'
	actual="$(set -a; HBLOCK_FOOTER_FILE="${SCRIPT_DIR:?}/footer.txt" runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Footer: "HBLOCK_FOOTER_FILE" environment variable with a non-existent file\n'
	actual="$(set -a; HBLOCK_FOOTER_FILE='/hblock/invalid.txt' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}"-invalid.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Footer: "HBLOCK_FOOTER" environment variable\n'
	actual="$(set -a; HBLOCK_FOOTER="$(cat -- "${SCRIPT_DIR:?}/footer.txt")" runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
