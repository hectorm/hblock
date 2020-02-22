#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROJECT_DIR=${SCRIPT_DIR:?}/../

# Check if a program exists
exists() {
	# shellcheck disable=SC2230
	if command -v true; then command -v -- "${1:?}"
	elif eval type type; then eval type -- "${1:?}"
	else which -- "${1:?}"; fi >/dev/null 2>&1
}

# Escape strings in sed
# See: https://stackoverflow.com/a/29613573
quoteRe() { printf -- '%s' "${1:?}" | sed -e 's/[^^]/[&]/g; s/\^/\\^/g; $!a'\\''"$(printf '\n')"'\\n' | tr -d '\n'; }
quoteSubst() { printf -- '%s' "${1:?}" | sed -e ':a' -e '$!{N;ba' -e '}' -e 's/[&/\]/\\&/g; s/\n/\\&/g'; }

# Base16 encode
base16Encode() {
	if exists hexdump; then hexdump -ve '/1 "%02x"'
	elif exists od; then od -v -tx1 -An | tr -d '\n '
	fi
}

# Calculate a SHA256 checksum
sha256Checksum() {
	if exists sha256sum; then sha256sum | cut -c 1-64
	elif exists sha256; then sha256 | cut -c 1-64
	elif exists shasum; then shasum -a 256 | cut -c 1-64
	elif exists openssl; then openssl sha256 -binary | base16Encode
	fi
}

# Print hBlock version
getVersion() {
	sed -n 's|.*"version"[[:space:]]*:[[:space:]]*"\([0-9]\.[0-9]\.[0-9]\)".*|\1|p' "${PROJECT_DIR:?}"/package.json
}

# Update hBlock version
setVersion() {
	version=${1:?}
	quotedVersion=$(quoteSubst "${version:?}")

	sed -i \
		-e "s|^\(.*# Version:.*\)[0-9]\.[0-9]\.[0-9]\(.*\)$|\1${quotedVersion:?}\2|g" \
		-e "s|^\(.*printStdout.*'\)[0-9]\.[0-9]\.[0-9]\('.*\)$|\1${quotedVersion:?}\2|g" \
		"${PROJECT_DIR:?}"/hblock

	hblockScriptChecksum=$(sha256Checksum < "${PROJECT_DIR:?}"/hblock)

	printf '%s  %s\n' \
		"${hblockScriptChecksum}" "hblock" \
		> "${PROJECT_DIR:?}"/SHA256SUMS

	sed -i \
		-e "s|^\(.*/hblock/v\)[0-9]\.[0-9]\.[0-9]\(/.*\)$|\1${quotedVersion:?}\2|g" \
		-e "s|^\(.*\)[0-9a-f]\{64\}\(  /tmp/hblock.*\)$|\1${hblockScriptChecksum:?}\2|g" \
		"${PROJECT_DIR:?}"/README.md

	hblockServiceChecksum=$(sha256Checksum < "${PROJECT_DIR:?}"/resources/systemd/hblock.service)
	hblockTimerChecksum=$(sha256Checksum < "${PROJECT_DIR:?}"/resources/systemd/hblock.timer)

	printf '%s  %s\n' \
		"${hblockServiceChecksum}" "hblock.service" \
		"${hblockTimerChecksum}"   "hblock.timer" \
		> "${PROJECT_DIR:?}"/resources/systemd/SHA256SUMS

	sed -i \
		-e "s|^\(.*/hblock/v\)[0-9]\.[0-9]\.[0-9]\(/.*\)$|\1${quotedVersion:?}\2|g" \
		-e "s|^\(.*\)[0-9a-f]\{64\}\(  /tmp/hblock.service.*\)$|\1${hblockServiceChecksum:?}\2|g" \
		-e "s|^\(.*\)[0-9a-f]\{64\}\(  /tmp/hblock.timer.*\)$|\1${hblockTimerChecksum:?}\2|g" \
		"${PROJECT_DIR:?}"/resources/systemd/README.md
}

if [ "${1:?}" = 'get' ]; then
	getVersion
elif [ "${1:?}" = 'set' ]; then
	setVersion "${2-$(getVersion)}"
fi
