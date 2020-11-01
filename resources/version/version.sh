#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${0:?}")" && pwd -P)"
PROJECT_DIR="${SCRIPT_DIR:?}/../../"

# Check if a program exists.
exists() {
	# shellcheck disable=SC2230
	if command -v true; then command -v -- "${1:?}"
	elif eval type type; then eval type -- "${1:?}"
	else which -- "${1:?}"; fi >/dev/null 2>&1
}

# Base16 encode.
base16Encode() {
	if exists hexdump; then hexdump -ve '/1 "%02x"'
	elif exists od; then od -v -tx1 -An | tr -d '\n '
	else exit 1; fi
}

# Calculate a SHA256 checksum.
sha256Checksum() {
	if exists sha256sum; then sha256sum | cut -c 1-64
	elif exists sha256; then sha256 | cut -c 1-64
	elif exists shasum; then shasum -a 256 | cut -c 1-64
	elif exists openssl; then openssl sha256 -binary | base16Encode
	else exit 1; fi
}

# Print hBlock version.
getVersion() {
	"${PROJECT_DIR:?}"/hblock -v | awk 'NR==1{print($2)}'
}

# Update hBlock version.
setVersion() {
	version="${1:?}"

	sed -e 's|^\(# Version:[[:blank:]]*\).\{1,\}$|\1'"${version:?}"'|g' \
		-- "${PROJECT_DIR:?}"/hblock > "${PROJECT_DIR:?}"/.hblock.tmp \
		&& cat -- "${PROJECT_DIR:?}"/.hblock.tmp > "${PROJECT_DIR:?}"/hblock \
		&& rm -f -- "${PROJECT_DIR:?}"/.hblock.tmp

	hblockScriptChecksum="$(sha256Checksum < "${PROJECT_DIR:?}"/hblock)"

	printf '%s  %s\n' \
		"${hblockScriptChecksum:?}" "hblock" \
		> "${PROJECT_DIR:?}"/SHA256SUMS

	sed -e 's|^\(.*/hblock/v\)[0-9]\{1,\}\(\.[0-9]\{1,\}\)*\(/.*\)$|\1'"${version:?}"'\3|g' \
		-e 's|^\(.*\)[0-9a-f]\{64\}\(  /tmp/hblock.*\)$|\1'"${hblockScriptChecksum:?}"'\2|g' \
		-- "${PROJECT_DIR:?}"/README.md > "${PROJECT_DIR:?}"/.README.md.tmp \
		&& cat -- "${PROJECT_DIR:?}"/.README.md.tmp > "${PROJECT_DIR:?}"/README.md \
		&& rm -f -- "${PROJECT_DIR:?}"/.README.md.tmp

	hblockServiceChecksum="$(sha256Checksum < "${PROJECT_DIR:?}"/resources/systemd/hblock.service)"
	hblockTimerChecksum="$(sha256Checksum < "${PROJECT_DIR:?}"/resources/systemd/hblock.timer)"

	printf '%s  %s\n' \
		"${hblockServiceChecksum:?}" "hblock.service" \
		"${hblockTimerChecksum:?}"   "hblock.timer" \
		> "${PROJECT_DIR:?}"/resources/systemd/SHA256SUMS

	sed -e 's|^\(.*/hblock/v\)[0-9]\{1,\}\(\.[0-9]\{1,\}\)*\(/.*\)$|\1'"${version:?}"'\3|g' \
		-e 's|^\(.*\)[0-9a-f]\{64\}\(  /tmp/hblock.service.*\)$|\1'"${hblockServiceChecksum:?}"'\2|g' \
		-e 's|^\(.*\)[0-9a-f]\{64\}\(  /tmp/hblock.timer.*\)$|\1'"${hblockTimerChecksum:?}"'\2|g' \
		-- "${PROJECT_DIR:?}"/resources/systemd/README.md > "${PROJECT_DIR:?}"/resources/systemd/.README.md.tmp \
		&& cat -- "${PROJECT_DIR:?}"/resources/systemd/.README.md.tmp > "${PROJECT_DIR:?}"/resources/systemd/README.md \
		&& rm -f -- "${PROJECT_DIR:?}"/resources/systemd/.README.md.tmp
}

if [ "${1:?}" = 'get' ]; then
	getVersion
elif [ "${1:?}" = 'set' ]; then
	setVersion "${2-"$(getVersion)"}"
fi
