#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

# Check if a program exists.
exists() {
	# shellcheck disable=SC2230
	if command -v true; then command -v -- "${1:?}"
	elif eval type type; then eval type -- "${1:?}"
	else which -- "${1:?}"; fi >/dev/null 2>&1
}

# Create a temporary directory.
createTempDir() {
	if exists mktemp; then mktemp -d
	else
		# Since POSIX does not specify mktemp utility, use this as fallback.
		# And wait a second as a horrible hack to avoid name collisions.
		rnd="$(sleep 1; awk 'BEGIN{srand();printf("%08x",rand()*(2**31-1))}')"
		dir="${TMPDIR:-/tmp}/tmp.${$-}${rnd:?}"
		(umask 077 && mkdir -- "${dir:?}")
		printf -- '%s' "${dir:?}"
	fi
}

# Print to stdout the contents of a URL.
fetchUrl() {
	# If the protocol is "file://" we can omit the download and simply use cat.
	if [ "${1#file://}" != "${1:?}" ]; then cat -- "${1#file://}"
	else
		userAgent='Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0'
		if exists curl; then curl -fsSL -A "${userAgent:?}" -- "${1:?}"
		elif exists wget; then wget -qO- -U "${userAgent:?}" -- "${1:?}"
		elif exists fetch; then fetch -qo- --user-agent="${userAgent:?}" -- "${1:?}"
		else exit 1; fi
	fi
}

# Convert an IDN to punycode.
punycodeEncode() {
	if exists idn2; then LC_ALL='en_US.UTF-8' idn2
	elif exists idn; then LC_ALL='en_US.UTF-8' idn
	else exit 1; fi
}

main() {
	file="${1:?}"
	publicSuffixList="${2:-https://publicsuffix.org/list/public_suffix_list.dat}"

	if [ ! -f "${file:?}" ] || [ ! -r "${file:?}" ]; then
		printf -- '%s\n' "Cannot read file: '${file:?}'" >&2
		exit 1
	fi

	header="$(printf -- '%s\t%s\t%s\n' 'Top' 'Hosts' 'Suffix')"
	stats=''

	# Create a temporary work directory.
	tmpWorkDir="$(createTempDir)"
	trap 'rm -rf -- "${tmpWorkDir:?}"; trap - EXIT; exit 0' EXIT TERM INT HUP

	# Copy blocklist file.
	blocklistFile="${tmpWorkDir:?}/block.list"
	cp -f -- "${file:?}" "${blocklistFile:?}"

	# Compact blocklist content (remove lowest level domain and count ocurrences).
	sed -e 's/^.\{1,\}[[:blank:]][^.]\{1,\}//' -- "${blocklistFile:?}" \
		| sort | uniq -c > "${blocklistFile:?}.aux" \
		&& mv -f -- "${blocklistFile:?}.aux" "${blocklistFile:?}"

	if [ "${publicSuffixList:?}" != 'none' ]; then
		# Download public suffix list.
		fetchUrl "${publicSuffixList:?}" > "${blocklistFile:?}.suffixes"

		# Transform suffix list (punycode encode and sort by length in descending order).
		sed -e '/^\/\//d;/^!/d;/^$/d;s/^\*\.//g' -- "${blocklistFile:?}.suffixes" \
			| punycodeEncode | awk '{print(length($0)":."$0)}' \
			| sort -nr | cut -d: -f2 > "${blocklistFile:?}.aux" \
			&& mv -f -- "${blocklistFile:?}.aux" "${blocklistFile:?}.suffixes"

		# Create regex pattern for each suffix.
		sed -e 's/\./\\./g;s/$/$/g' \
			-- "${blocklistFile:?}.suffixes" > "${blocklistFile:?}.aux" \
			&& mv -f -- "${blocklistFile:?}.aux" "${blocklistFile:?}.suffixes"

		# Count blocklist matches for each suffix.
		while IFS= read -r regex || [ -n "${regex?}" ]; do
			if grep -- "${regex:?}" "${blocklistFile:?}" > "${blocklistFile:?}.match"; then
				count="$(awk '{s+=$1}END{print(s)}' "${blocklistFile:?}.match")"
				stats="$(printf -- '%s\t%s\n%s' "${count:?}" "${regex:?}" "${stats?}")"
				{ grep -v -- "${regex:?}" "${blocklistFile:?}" > "${blocklistFile:?}.aux" \
					&& mv -f -- "${blocklistFile:?}.aux" "${blocklistFile:?}"; } || true
			fi
		done < "${blocklistFile:?}.suffixes"

		# Undo regex pattern.
		stats="$(printf -- '%s' "${stats?}" | sed 's/\\\././g;s/\$$//g')"
	fi

	# If the blocklist file is not empty, use TLD as suffix.
	if [ -s "${blocklistFile:?}" ]; then
		tldStats="$(sed -e 's/^\(.\{1,\}[[:blank:]]\).*\(\.[^.]\{1,\}\)$/\1\2/g' -- "${blocklistFile:?}" |
			awk '{arr[$2]+=$1;}END{for (i in arr) print(arr[i]"\t"i)}'
		)"

		stats="$(printf -- '%s\n%s' "${tldStats?}" "${stats?}")"
	fi

	# Sort stats by the number of matches.
	stats="$(printf -- '%s' "${stats?}" | sort -k1,1nr -k2,2 | awk '{print NR"\t"$0}')"

	printf -- '%s\n%s\n' "${header:?}" "${stats?}"
}

main "${@-}"
