#!/bin/sh

set -eu

scriptDir=$(dirname "$(readlink -f "$0")")
baseDir="$scriptDir/.."
action="${1:-nothing}"

# Escape strings in sed
# See: https://stackoverflow.com/a/29613573
quoteRe() { printf -- '%s' "$1" | sed -e 's/[^^]/[&]/g; s/\^/\\^/g; $!a'\\''"$(printf '\n')"'\\n' | tr -d '\n'; }
quoteSubst() { printf -- '%s' "$1" | sed -e ':a' -e '$!{N;ba' -e '}' -e 's/[&/\]/\\&/g; s/\n/\\&/g'; }
replaceLiteral() { sed -i -- "s/$(quoteRe "$1")/$(quoteSubst "$2")/g" "$3"; }

version() {
	jq -r '.version' "$baseDir/package.json"
}

checksum() {
	if [ "$action" = 'preversion' ]; then
		cd "$baseDir" && git show "v$(version):$1" | sha256sum | cut -c 1-64
	elif [ "$action" = 'version' ]; then
		sha256sum "$baseDir/$1" | cut -c 1-64
	fi
}

if [ "$action" = 'preversion' ]; then
	replaceLiteral "# Version:    $(version)" '# Version:    __VERSION__' "$baseDir/hblock"
	replaceLiteral "'%s\\n' '$(version)'" "'%s\\n' '__VERSION__'" "$baseDir/hblock"

	replaceLiteral "hblock/v$(version)/" 'hblock/v__VERSION__/' "$baseDir/README.md"
	replaceLiteral "$(checksum hblock)" '__CHECKSUM_HBLOCK__' "$baseDir/README.md"

	replaceLiteral "hblock/v$(version)/" 'hblock/v__VERSION__/' "$baseDir/resources/systemd/README.md"
	replaceLiteral "$(checksum resources/systemd/hblock.service)" '__CHECKSUM_HBLOCK_SERVICE__' "$baseDir/resources/systemd/README.md"
	replaceLiteral "$(checksum resources/systemd/hblock.timer)" '__CHECKSUM_HBLOCK_TIMER__' "$baseDir/resources/systemd/README.md"
elif [ "$action" = 'version' ]; then
	replaceLiteral '__VERSION__' "$(version)" "$baseDir/hblock"

	replaceLiteral '__VERSION__' "$(version)" "$baseDir/README.md"
	replaceLiteral '__CHECKSUM_HBLOCK__' "$(checksum hblock)" "$baseDir/README.md"

	replaceLiteral '__VERSION__' "$(version)" "$baseDir/resources/systemd/README.md"
	replaceLiteral '__CHECKSUM_HBLOCK_SERVICE__' "$(checksum resources/systemd/hblock.service)" "$baseDir/resources/systemd/README.md"
	replaceLiteral '__CHECKSUM_HBLOCK_TIMER__' "$(checksum resources/systemd/hblock.timer)" "$baseDir/resources/systemd/README.md"
fi
