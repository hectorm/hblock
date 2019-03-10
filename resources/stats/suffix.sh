#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

# Check if a program exists
exists() {
	# shellcheck disable=SC2230
	if command -v true; then command -v -- "$1"
	elif eval type type; then eval type -- "$1"
	else which -- "$1"; fi >/dev/null 2>&1
}

# Create temporary file
createTempFile() {
	if exists mktemp; then mktemp
	else # Since POSIX does not specify mktemp utility, use this as fallback
		tempCounter=${tempCounter:-9999}
		tempFile="${TMPDIR:-/tmp}/hblock.$$.$((tempCounter+=1))"
		rm -f -- "$tempFile" && (umask 077 && touch -- "$tempFile")
		printf -- '%s\n' "$tempFile"
	fi
}

# Print to stdout the contents of a URL
fetchUrl() {
	if exists curl; then curl -fsSL -- "$1";
	elif exists wget; then wget -qO- -- "$1";
	else
		logError 'Either wget or curl are required for this script'
		exit 1
	fi
}

main() {
	file="${1:?}"
	publicSuffixList="${2:-https://publicsuffix.org/list/public_suffix_list.dat}"

	if ! [ -f "$file" ] || ! [ -r "$file" ]; then
		>&2 printf -- '%s\n' "Cannot read file '$file'"
		exit 1
	fi

	header=$(printf -- '%s\t%s\t%s\n' 'Top' 'Hosts' 'Suffix')
	stats=''

	# Create temporary blocklist file
	blocklist=$(createTempFile)
	cp -f -- "$file" "$blocklist"
	rmtemp() { rm -f -- "$blocklist" "$blocklist".*; }
	trap rmtemp EXIT

	# Compact blocklist content (remove lowest level domain and count ocurrences)
	sed -e 's/^.\{1,\}[[:blank:]][^.]\{1,\}//' -- "$blocklist" \
		| sort | uniq -c > "$blocklist.aux" \
		&& mv -f -- "$blocklist.aux" "$blocklist"

	if [ "$publicSuffixList" != 'none' ]; then
		# Download public suffix list
		fetchUrl "$publicSuffixList" > "$blocklist.suffixes"

		# Transform suffix list (punycode encode and sort by length in descending order)
		sed -e '/^\/\//d;/^!/d;/^$/d;s/^\*\.//g' -- "$blocklist.suffixes" \
			| CHARSET=UTF-8 idn | awk '{print(length($0)":."$0)}' \
			| sort -nr | cut -d: -f2 > "$blocklist.aux" \
			&& mv -f -- "$blocklist.aux" "$blocklist.suffixes"

		# Create regex pattern for each suffix
		sed -e 's/\./\\./g;s/$/$/g' \
			-- "$blocklist.suffixes" > "$blocklist.aux" \
			&& mv -f -- "$blocklist.aux" "$blocklist.suffixes"

		# Count blocklist matches for each suffix
		while read -r regex; do
			if grep -- "$regex" "$blocklist" > "$blocklist.match"; then
				count=$(awk '{s+=$1}END{print(s)}' "$blocklist.match")
				stats=$(printf -- '%s\t%s\n%s' "$count" "$regex" "$stats")
				(grep -v -- "$regex" "$blocklist" > "$blocklist.aux" \
					&& mv -f -- "$blocklist.aux" "$blocklist") || true
			fi
		done < "$blocklist.suffixes"

		# Undo regex pattern
		stats=$(printf -- '%s' "$stats" | sed 's/\\\././g;s/\$$//g')
	fi

	# If blocklist is not empty use TLD as suffix
	if [ -s "$blocklist" ]; then
		tldStats=$(sed -e 's/^\(.\{1,\}[[:blank:]]\).*\(\.[^.]\{1,\}\)$/\1\2/g' -- "$blocklist" |
			awk '{arr[$2]+=$1;}END{for (i in arr) print(arr[i]"\t"i)}'
		)

		stats=$(printf -- '%s\n%s' "$tldStats" "$stats")
	fi

	# Sort stats by the number of matches
	stats=$(printf -- '%s' "$stats" | sort -k1,1nr -k2,2 | awk '{print NR"\t"$0}')

	printf -- '%s\n%s\n' "$header" "$stats"
}

main "$@"
