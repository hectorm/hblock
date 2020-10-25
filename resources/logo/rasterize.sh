#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${0:?}")" && pwd -P)"
TARGET_DIR="${SCRIPT_DIR:?}/bitmaps/"

main() {
	rm -rf "${TARGET_DIR:?}"
	mkdir -p "${TARGET_DIR:?}"

	vectors="$(cat "${SCRIPT_DIR:?}/rasterize.json")"
	vectorTotal="$(jq -nr --argjson d "${vectors:?}" '$d|length-1')"

	vectorIndex='0'
	while [ "${vectorIndex:?}" -le "${vectorTotal:?}" ]; do
		vector="$(jq -nr --argjson d "${vectors:?}" --arg i "${vectorIndex:?}" '$d[$i|tonumber]')"
		src="$(jq -nr --argjson d "${vector:?}" '$d.src')"
		name="$(jq -nr --argjson d "${vector:?}" '$d.name')"
		heightTotal="$(jq -nr --argjson d "${vector:?}" '$d.heights|length-1')"
		backgroundTotal="$(jq -nr --argjson d "${vector:?}" '$d.backgrounds|length-1')"

		backgroundIndex='0'
		while [ "${backgroundIndex:?}" -le "${backgroundTotal:?}" ]; do
			background="$(jq -nr --argjson d "${vector:?}" --arg i "${backgroundIndex:?}" '$d.backgrounds[$i|tonumber]')"

			heightIndex='0'
			while [ "${heightIndex:?}" -le "${heightTotal:?}" ]; do
				height="$(jq -nr --argjson d "${vector:?}" --arg i "${heightIndex:?}" '$d.heights[$i|tonumber]')"

				inkscapeOpts="--export-filename=${TARGET_DIR:?}/${name:?}-${background#'#'}-h${height:?}.png"
				inkscapeOpts="${inkscapeOpts:?} --export-height=${height:?}"

				if [ "${background:?}" != 'transparent' ]; then
					inkscapeOpts="${inkscapeOpts:?} --export-background=${background:?}"
				fi

				# shellcheck disable=SC2086
				inkscape ${inkscapeOpts:?} "${SCRIPT_DIR:?}/${src:?}"

				heightIndex="$((heightIndex+1))"
			done

			backgroundIndex="$((backgroundIndex+1))"
		done

		vectorIndex="$((vectorIndex+1))"
	done
}

main "${@-}"
