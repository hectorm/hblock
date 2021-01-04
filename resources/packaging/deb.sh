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

	# shellcheck disable=SC2154
	trap 'ret="$?"; rm -rf -- "${buildDir:?}"; trap - EXIT; exit "${ret:?}"' EXIT TERM INT HUP

	# Copy the assets directory to the build directory.
	rsync -a -- "${assetsDir:?}"/ "${buildDir:?}"/

	# Copy the project files to the build directory.
	rsync -a --exclude='.git/' --exclude='dist/' -- "${PROJECT_DIR:?}"/ "${buildDir:?}"/
	cp -a -- "${buildDir:?}"/resources/systemd/hblock.* "${buildDir:?}"/debian/

	# Change the working directory to the build directory.
	cd -- "${buildDir:?}"

	# Execute the templates.
	find -- "${buildDir:?}" -type f -name '*.m4' \
		-exec sh -euc 'm4 --prefix-builtins -- "${1:?}" > "${1%.m4}"' _ '{}' ';' \
		-exec rm -f -- '{}' ';'

	# Build the package.
	dpkg-buildpackage -us -uc

	# Change to the previous working directory.
	cd -- "${OLDPWD:?}"

	# Copy the package to the target file.
	mkdir -p -- "$(dirname -- "${target:?}")"
	mv -f -- "${buildDir:?}"/../hblock*.deb "${target:?}"

	# Cleanup.
	rm -rf -- \
		"${buildDir:?}" \
		"${buildDir:?}"/../hblock*.buildinfo \
		"${buildDir:?}"/../hblock*.changes \
		"${buildDir:?}"/../hblock*.dsc \
		"${buildDir:?}"/../hblock*.tar.*
}

main "${@-}"
