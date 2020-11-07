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
	assetsDir="${SCRIPT_DIR:?}/deb/"
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
	cp -a -- "${buildDir:?}"/resources/systemd/hblock.* "${buildDir:?}"/debian/

	# Remove the previous package.
	rm -f -- "${target:?}"

	# Build the package.
	mkdir -p -- "$(dirname -- "${target:?}")"
	(cd -- "${buildDir:?}" && dpkg-buildpackage -us -uc)
	mv -f -- "${buildDir:?}"/../hblock_*_all.deb "${target:?}"

	# Cleanup.
	rm -rf -- \
		"${buildDir:?}" \
		"${buildDir:?}"/../hblock_*.buildinfo \
		"${buildDir:?}"/../hblock_*.changes \
		"${buildDir:?}"/../hblock_*.dsc \
		"${buildDir:?}"/../hblock_*.tar.*
}

main "${@-}"
