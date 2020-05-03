#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

# Check if a program exists
exists() {
	# shellcheck disable=SC2230
	if command -v true; then command -v -- "${1:?}"
	elif eval type type; then eval type -- "${1:?}"
	else which -- "${1:?}"; fi >/dev/null 2>&1
}

# Create a temporary file
createTempFile() {
	if exists mktemp; then mktemp
	else # Since POSIX does not specify mktemp utility, use this as fallback
		# Wait a second to avoid name collisions. Horrible hack, I know
		rand=$(sleep 1; awk 'BEGIN{srand();printf("%08x",rand()*(2**31-1))}')
		file="${TMPDIR:-/tmp}/tmp.$$.${rand:?}"
		(umask 077 && touch -- "${file:?}")
		printf -- '%s\n' "${file:?}"
	fi
}

# Print to stdout the contents of a URL
fetchUrl() {
	# If the protocol is "file://" we can omit the download and simply use cat
	if [ "${1#file://}" != "${1:?}" ]; then cat -- "${1#file://}"
	else
		userAgent='Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0'
		if exists curl; then curl -fsSL -A "${userAgent:?}" -- "${1:?}";
		elif exists wget; then wget -qO- -U "${userAgent:?}" -- "${1:?}";
		elif exists fetch; then fetch -qo- --user-agent="${userAgent:?}" -- "${1:?}";
		else
			logError 'Either curl, wget or fetch is required for this script'
			exit 1
		fi
	fi
}

# Convert an IDN to punycode
punycodeEncode() {
	if exists idn2; then CHARSET=UTF-8 idn2;
	else CHARSET=UTF-8 idn; fi
}

main() {
	file="${1:?}"
	publicSuffixList="${2:-https://publicsuffix.org/list/public_suffix_list.dat}"

	if ! [ -f "${file:?}" ] || ! [ -r "${file:?}" ]; then
		>&2 printf -- '%s\n' "Cannot read file '${file:?}'"
		exit 1
	fi

	header=$(printf -- '%s\t%s\t%s\n' 'Top' 'Hosts' 'Suffix')
	stats=''

	# Create temporary blocklist file
	blocklistFile=$(createTempFile)
	cp -f -- "${file:?}" "${blocklistFile:?}"
	rmtemp() { rm -f -- "${blocklistFile:?}" "${blocklistFile:?}".*; }
	trap rmtemp EXIT

	# Compact blocklist content (remove lowest level domain and count ocurrences)
	sed -e 's/^.\{1,\}[[:blank:]][^.]\{1,\}//' -- "${blocklistFile:?}" \
		| sort | uniq -c > "${blocklistFile:?}.aux" \
		&& mv -f -- "${blocklistFile:?}.aux" "${blocklistFile:?}"

	if [ "${publicSuffixList:?}" != 'none' ]; then
		# Download public suffix list
		fetchUrl "${publicSuffixList:?}" > "${blocklistFile:?}.suffixes"

		# Transform suffix list (punycode encode and sort by length in descending order)
		sed -e '/^\/\//d;/^!/d;/^$/d;s/^\*\.//g' -- "${blocklistFile:?}.suffixes" \
			| punycodeEncode | awk '{print(length($0)":."$0)}' \
			| sort -nr | cut -d: -f2 > "${blocklistFile:?}.aux" \
			&& mv -f -- "${blocklistFile:?}.aux" "${blocklistFile:?}.suffixes"

		# Create regex pattern for each suffix
		sed -e 's/\./\\./g;s/$/$/g' \
			-- "${blocklistFile:?}.suffixes" > "${blocklistFile:?}.aux" \
			&& mv -f -- "${blocklistFile:?}.aux" "${blocklistFile:?}.suffixes"

		# Count blocklist matches for each suffix
		while read -r regex; do
			if grep -- "${regex:?}" "${blocklistFile:?}" > "${blocklistFile:?}.match"; then
				count=$(awk '{s+=$1}END{print(s)}' "${blocklistFile:?}.match")
				stats=$(printf -- '%s\t%s\n%s' "${count:?}" "${regex:?}" "${stats?}")
				(grep -v -- "${regex:?}" "${blocklistFile:?}" > "${blocklistFile:?}.aux" \
					&& mv -f -- "${blocklistFile:?}.aux" "${blocklistFile:?}") || true
			fi
		done < "${blocklistFile:?}.suffixes"

		# Undo regex pattern
		stats=$(printf -- '%s' "${stats?}" | sed 's/\\\././g;s/\$$//g')
	fi

	# If blocklist is not empty use TLD as suffix
	if [ -s "${blocklistFile:?}" ]; then
		tldStats=$(sed -e 's/^\(.\{1,\}[[:blank:]]\).*\(\.[^.]\{1,\}\)$/\1\2/g' -- "${blocklistFile:?}" |
			awk '{arr[$2]+=$1;}END{for (i in arr) print(arr[i]"\t"i)}'
		)

		stats=$(printf -- '%s\n%s' "${tldStats?}" "${stats?}")
	fi

	# Sort stats by the number of matches
	stats=$(printf -- '%s' "${stats?}" | sort -k1,1nr -k2,2 | awk '{print NR"\t"$0}')

	printf -- '%s\n%s\n' "${header:?}" "${stats?}"
}

main "$@"
