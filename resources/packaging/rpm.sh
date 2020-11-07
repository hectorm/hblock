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
	assetsDir="${SCRIPT_DIR:?}/rpm/"
	buildDir="$(mktemp -d)"

	# Create a trap to ensure that the build directory is removed.
	trap 'rm -rf -- "${buildDir:?}"; trap - EXIT; exit 0' EXIT TERM INT HUP

	# Copy the assets directory to the build directory.
	rsync -a -- "${assetsDir:?}"/ "${buildDir:?}"/

	# Execute the templates.
	find -- "${buildDir:?}" -type f -name '*.m4' \
		-exec sh -euc 'm4 --prefix-builtins -- "${1:?}" > "${1%.m4}"' _ '{}' ';' \
		-exec rm -f -- '{}' ';'

	# Pack the project files.
	rsync -a --exclude='.git/' --exclude='dist/' -- "${PROJECT_DIR:?}"/ "${buildDir:?}"/SOURCES/hblock/
	tar --create --remove-files --file "${buildDir:?}"/SOURCES/hblock.tar --directory "${buildDir:?}"/SOURCES/hblock/ ./

	# Remove the previous package.
	rm -f -- "${target:?}"

	# Build the package.
	mkdir -p -- "$(dirname -- "${target:?}")"
	rpmbuild -D "_topdir $(readlink -f -- "${buildDir:?}")" -bb "${buildDir:?}"/SPECS/hblock.spec
	mv -f -- "${buildDir:?}"/RPMS/noarch/hblock-*.noarch.rpm "${target:?}"

	# Cleanup.
	rm -rf -- "${buildDir:?}"
}

main "${@-}"
