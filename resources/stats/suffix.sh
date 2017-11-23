#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

# Process
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
	blocklist=$(cat -- "$file" |
		awk '/<blocklist>/{p=1;next}/<\/blocklist>/{p=0}p' |
		sed 's/^.\{1,\}[[:blank:]][^.]\{1,\}//'
	)

	if [ "$publicSuffixList" != 'none' ]; then
		# Download public suffix list
		suffixes=$(curl -fsSL -- "$publicSuffixList")

		# Transform suffix list (punycode encode and sort by length in descending order)
		suffixes=$(printf -- '%s\n' "$suffixes" |
			sed '/^\/\//d;/^!/d;/^$/d;s/^\*\.//g' | CHARSET=UTF-8 idn |
			awk '{print length($0)":."$0}' | sort -nr | cut -d: -f2
		)

		# Count blocklist matches for each suffix
		for suffix in $suffixes; do
			regex=$(printf -- '%s' "$suffix" | sed 's/\./\\./g')\$
			count=$(printf -- '%s' "$blocklist" | grep -c "$regex") || true

			if [ "$count" != '0' ]; then
				stats=$(printf -- '%s\t%s\n%s' "$count" "$suffix" "$stats")
				blocklist=$(printf -- '%s' "$blocklist" | grep -v "$regex") || true
			fi

			unset regex count
		done
	fi

	# If blocklist is not empty use TLD as suffix
	if [ -n "$blocklist" ]; then
		tldStats=$(printf -- '%s' "$blocklist" |
			grep -o '\.[^.]\{1,\}$' | sort | uniq -c |
			sed 's/^[[:blank:]]*\([0-9]\{1,\}\)[[:blank:]]\{1,\}/\1	/'
		)

		stats=$(printf -- '%s\n%s' "$tldStats" "$stats")
	fi

	# Sort stats by the number of matches
	stats=$(printf -- '%s' "$stats" | sort -nr | awk '{print NR"\t"$0}')

	printf -- '%s\n%s\n' "$header" "$stats"
}

main "$@"
