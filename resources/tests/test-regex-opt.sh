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
	export HBLOCK_REGEX='false'
	# shellcheck disable=SC2155
	export HBLOCK_ALLOWLIST="$(cat <<-'EOF'
		.*-00[0-3]\.com$
		^entry-with-comment-
	EOF
	)"

	printf 'Test: "-r" short option\n'
	actual="$(hBlockInTestShell -qO- -r)"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-regex-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test: "--regex" long option\n'
	actual="$(hBlockInTestShell -qO- --regex)"
	expected="$(cat -- "${SCRIPT_DIR:?}"/test-regex-opt.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
