#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${0:?}")" && pwd -P)"
PROJECT_DIR="${SCRIPT_DIR:?}/../../"

main() {
	target="${1:?}"
	assetsDir="${SCRIPT_DIR:?}/npm/"
	buildDir="$(mktemp -d)"

	# Create a trap to ensure that the build directory is removed.
	trap 'rm -rf -- "${buildDir:?}"; trap - EXIT; exit 0' EXIT TERM INT HUP

	# Copy the assets directory to the build directory.
	rsync -a -- "${assetsDir:?}"/ "${buildDir:?}"/

	# Execute the templates.
	find -- "${buildDir:?}" -type f -name '*.m4' \
		-exec sh -euc 'm4 --prefix-builtins -- "${1:?}" > "${1%.m4}"' _ '{}' ';' \
		-exec rm -f -- '{}' ';'

	# Copy the project files.
	rsync -a --exclude='.git/' --exclude='dist/' -- "${PROJECT_DIR:?}"/ "${buildDir:?}"/

	# Remove the previous package.
	rm -f -- "${target:?}"

	# Build the package.
	mkdir -p -- "$(dirname -- "${target:?}")"
	(cd -- "${buildDir:?}" && npm pack)
	mv -f -- "${buildDir:?}"/hblock-*.tgz "${target:?}"

	# Cleanup.
	rm -rf -- "${buildDir:?}"
}

main "${@-}"
