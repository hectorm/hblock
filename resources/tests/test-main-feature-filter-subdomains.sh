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
	export HBLOCK_FILTER_SUBDOMAINS='false'

	printf 'Test - Main - Filter subdomains: "-f" short option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -f)"
	expected="$(cat -- "${0%.sh}"-true.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Filter subdomains: "--filter-subdomains" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --filter-subdomains)"
	expected="$(cat -- "${0%.sh}"-true.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Filter subdomains: "HBLOCK_FILTER_SUBDOMAINS" environment variable\n'
	actual="$(set -a; HBLOCK_FILTER_SUBDOMAINS='true' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}"-true.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	export HBLOCK_FILTER_SUBDOMAINS='true'

	printf 'Test - Main - Filter subdomains: "--no-filter-subdomains" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --no-filter-subdomains)"
	expected="$(cat -- "${0%.sh}"-false.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
