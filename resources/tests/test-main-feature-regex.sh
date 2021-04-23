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
	export HBLOCK_REGEX='false'
	# shellcheck disable=SC2155
	export HBLOCK_ALLOWLIST="$(cat <<-'EOF'
		.*-00[0-3]\.com$
		^entry-with-comment-
	EOF
	)"

	printf 'Test - Main - Regex: "-r" short option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- -r)"
	expected="$(cat -- "${0%.sh}"-true.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Regex: "--regex" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --regex)"
	expected="$(cat -- "${0%.sh}"-true.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	printf 'Test - Main - Regex: "HBLOCK_REGEX" environment variable\n'
	actual="$(set -a; HBLOCK_REGEX='true' runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO-)"
	expected="$(cat -- "${0%.sh}"-true.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi

	export HBLOCK_REGEX='true'
	# shellcheck disable=SC2155
	export HBLOCK_ALLOWLIST="$(cat <<-'EOF'
		.*-00[0-3]\.com$
		^entry-with-comment-
		single-entry-000.com
	EOF
	)"

	printf 'Test - Main - Regex: "--no-regex" long option\n'
	actual="$(runInTestShell "${SCRIPT_DIR:?}/../../hblock" -qO- --no-regex)"
	expected="$(cat -- "${0%.sh}"-false.out)"
	if ! assertEquals "${actual?}" "${expected?}"; then
		exit 1
	fi
}

main "${@-}"
