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
	export HBLOCK_REDIRECTION='0.0.0.0'

	printf 'Test: "-R" short option\n'
	actual="$(hBlockInTestShell -qO- -R '::1')"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-redirection-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test: "--redirection" long option\n'
	actual="$(hBlockInTestShell -qO- --redirection='::1')"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-redirection-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
