#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

main() {
	file="${1:-/etc/hosts}"
	publicSuffixList="${2:-https://publicsuffix.org/list/public_suffix_list.dat}"

	if ! [ -f "$file" ] || ! [ -r "$file" ]; then
		>&2 printf -- '%s\n' "Cannot read file '$file'"
		exit 1
	fi

	header=$(printf -- '%s\t%s\t%s\n' 'Top' 'Hosts' 'Suffix')
	stats=''

	# Get blocklist content
	blocklist=$(cat -- "$file" | sed '/^#.*<blocklist>/,/^#.*<\/blocklist>/!d;/^\s*#.*$/d')

	# Compact blocklist content (remove lowest level domain and count ocurrences)
	blocklist=$(printf -- '%s' "$blocklist" | sed 's/^.\{1,\}[[:blank:]][^.]\{1,\}//' | sort | uniq -c)

	if [ "$publicSuffixList" != 'none' ]; then
		# Download public suffix list
		suffixes=$(curl -fsSL -- "$publicSuffixList")

		# Transform suffix list (punycode encode and sort by length in descending order)
		suffixes=$(printf -- '%s' "$suffixes" |
			sed '/^\/\//d;/^!/d;/^$/d;s/^\*\.//g' | CHARSET=UTF-8 idn |
			awk '{print(length($0)":."$0)}' | sort -nr | cut -d: -f2
		)

		# Create regex pattern for each suffix
		suffixesRegex=$(printf -- '%s' "$suffixes" | sed 's/\./\\./g;s/$/$/g')

		# Count blocklist matches for each suffix
		for regex in $suffixesRegex; do
			match=$(printf -- '%s' "$blocklist" | grep -- "$regex") || true

			if [ -n "$match" ]; then
				count=$(printf -- '%s' "$match" | awk '{s+=$1}END{print(s)}')
				stats=$(printf -- '%s\t%s\n%s' "$count" "$regex" "$stats")
				blocklist=$(printf -- '%s' "$blocklist" | grep -v -- "$regex") || true
			fi
		done

		# Undo regex pattern
		stats=$(printf -- '%s' "$stats" | sed 's/\\\././g;s/\$$//g')
	fi

	# If blocklist is not empty use TLD as suffix
	if [ -n "$blocklist" ]; then
		tldStats=$(printf -- '%s' "$blocklist" |
			sed 's/^\(.\{1,\}[[:blank:]]\).*\(\.[^.]\{1,\}\)$/\1\2/g' |
			awk '{arr[$2]+=$1;}END{for (i in arr) print(arr[i]"\t"i)}'
		)

		stats=$(printf -- '%s\n%s' "$tldStats" "$stats")
	fi

	# Sort stats by the number of matches
	stats=$(printf -- '%s' "$stats" | sort -k1,1nr -k2,2 | awk '{print NR"\t"$0}')

	printf -- '%s\n%s\n' "$header" "$stats"
}

main "$@"
