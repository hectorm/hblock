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
	export HBLOCK_COMMENT='#'

	printf 'Test: "-C" short option\n'
	actual="$(hBlockInTestShell -qO- -C '# %')"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-comment-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test: "--comment" long option\n'
	actual="$(hBlockInTestShell -qO- --comment='# %')"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-comment-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
