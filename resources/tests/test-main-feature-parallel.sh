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
	# shellcheck disable=SC2155
	export HBLOCK_SOURCES="$(printf '%s\n' \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
		"file://${SCRIPT_DIR:?}/test-domains-source.txt" "file://${SCRIPT_DIR:?}/test-domains-source.txt" \
	)"
	export HBLOCK_PARALLEL='1'

	printf 'Test - Main - Parallel: "-p" short option with "0" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -p '0')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Parallel: "--parallel" long option with "0" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --parallel='0')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Parallel: "--parallel" long option with "1" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --parallel='1')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Parallel: "--parallel" long option with "5" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --parallel='5')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Parallel: "--parallel" long option with "-5" value\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --parallel='-5')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Parallel: "HBLOCK_PARALLEL" environment variable with "5" value\n'
	actual="$(set -a; HBLOCK_PARALLEL='5' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
