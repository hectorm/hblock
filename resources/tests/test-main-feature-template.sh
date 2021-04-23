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
	export HBLOCK_TEMPLATE='%R %D'

	printf 'Test - Main - Template: "-T" short option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -T '%R %D # %% %%R %%D %F\n\t└─ %R %D')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Template: "--template" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --template='%R %D # %% %%R %%D %F\n\t└─ %R %D')"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Template: "HBLOCK_TEMPLATE" environment variable\n'
	actual="$(set -a; HBLOCK_TEMPLATE='%R %D # %% %%R %%D %F\n\t└─ %R %D' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}".out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
