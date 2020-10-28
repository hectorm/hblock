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
	hblock="${1:-hblock}"

	export HBLOCK_TEMPLATE='\2 \1'

	printf 'Test: "-T" short option\n'
	actual="$(runInTestShell "${hblock:?}" -qO- -T '\2	\1')"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-template-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test: "--template" long option\n'
	actual="$(runInTestShell "${hblock:?}" -qO- --template='\2	\1')"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-template-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
