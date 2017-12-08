#!/bin/sh

set -eu

scriptDir=$(dirname "$(readlink -f "$0")")
baseDir="$scriptDir/.."
action="${1:-nothing}"

version() {
	jq -r '.version' "$baseDir/package.json"
}

checksum() {
	sha256sum "$baseDir/hblock" | cut -c 1-64
}

replaceInFile() {
	sed -i "s/$1/$2/g" "$3"
}

replaceLiteralInFile() {
	replaceInFile \
		"$(printf -- '%s' "$1" | sed 's/[]\/$*.^|[]/\\&/g')" \
		"$(printf -- '%s' "$2" | sed 's/[&/\]/\\&/g')" \
		"$3"
}

if [ "$action" = 'preversion' ]; then
	replaceInFile '[A-Fa-f0-9]\{64\}\(.*shasum\)' '__CHECKSUM__\1' "$baseDir/README.md"
	replaceLiteralInFile "$(version)" '__VERSION__' "$baseDir/hblock"
elif [ "$action" = 'version' ]; then
	replaceLiteralInFile '__VERSION__' "$(version)" "$baseDir/hblock"
	replaceLiteralInFile '__CHECKSUM__' "$(checksum)" "$baseDir/README.md"
fi
