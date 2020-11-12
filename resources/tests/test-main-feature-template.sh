#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${0:?}")" && pwd -P)"

# shellcheck disable=SC1090
. "${SCRIPT_DIR:?}"/env.sh

main() {
	export HBLOCK_SOURCES="file://${SCRIPT_DIR:?}/sources.txt"
	export HBLOCK_TEMPLATE='%R %D'

	printf -- 'Test - Main - Template: "-T" short option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -T '%D\n\t└─ %R')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf -- 'Test - Main - Template: "--template" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --template='%D\n\t└─ %R')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf -- 'Test - Main - Template: "HBLOCK_TEMPLATE" environment variable\n'
	actual="$(HBLOCK_TEMPLATE='%D\n\t└─ %R' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
