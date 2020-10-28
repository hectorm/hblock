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
	export HBLOCK_WRAP='1'

	printf 'Test: "-W" short option\n'
	actual="$(hBlockInTestShell -qO- -W '5')"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-wrap-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test: "--wrap" long option\n'
	actual="$(hBlockInTestShell -qO- --wrap='5')"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-wrap-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
