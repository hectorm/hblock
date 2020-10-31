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
		dir="${TMPDIR:-/tmp}/tmp.${$}${rnd:?}"
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
	if exists idn2; then idnCmd='idn2'
	elif exists idn; then idnCmd='idn'
	else exit 1; fi
	for LC_ALL in 'C.UTF-8' 'en_US.UTF-8' "${LC_CTYPE-}" "${LANG-}"; do
		if "${idnCmd:?}" 'λ' >/dev/null 2>&1; then "${idnCmd:?}"; break; fi
	done
}

main() {
	domainsFile="${1:?}"
	publicSuffixList="${2:-https://publicsuffix.org/list/public_suffix_list.dat}"

	if [ ! -e "${domainsFile:?}" ]; then
		printf -- '%s\n' "No such file: '${domainsFile:?}'" >&2
		exit 1
	fi

	header="$(printf -- '%s\t%s\t%s\n' 'Top' 'Hosts' 'Suffix')"
	stats=''

	# Create a temporary work directory.
	tmpWorkDir="$(createTempDir)"
	trap 'rm -rf -- "${tmpWorkDir:?}"; trap - EXIT; exit 0' EXIT TERM INT HUP

	# Copy domains file.
	domainsFileTmp="${tmpWorkDir:?}/domains.list"
	cp -f -- "${domainsFile:?}" "${domainsFileTmp:?}"

	# Compact domains file content (remove lowest level domain and count ocurrences).
	sed -e 's/^.\{1,\}[[:blank:]][^.]\{1,\}//' -- "${domainsFileTmp:?}" \
		| sort | uniq -c > "${domainsFileTmp:?}.aux" \
		&& mv -f -- "${domainsFileTmp:?}.aux" "${domainsFileTmp:?}"

	if [ "${publicSuffixList:?}" != 'no-psl' ]; then
		# Download public suffix list.
		fetchUrl "${publicSuffixList:?}" > "${domainsFileTmp:?}.suffixes"

		# Transform suffix list (punycode encode and sort by length in descending order).
		sed -e '/^\/\//d;/^!/d;/^$/d;s/^\*\.//g' -- "${domainsFileTmp:?}.suffixes" \
			| punycodeEncode | awk '{print(length($0)":."$0)}' \
			| sort -nr | cut -d: -f2 > "${domainsFileTmp:?}.aux" \
			&& mv -f -- "${domainsFileTmp:?}.aux" "${domainsFileTmp:?}.suffixes"

		# Create regex pattern for each suffix.
		sed -e 's/\./\\./g;s/$/$/g' \
			-- "${domainsFileTmp:?}.suffixes" > "${domainsFileTmp:?}.aux" \
			&& mv -f -- "${domainsFileTmp:?}.aux" "${domainsFileTmp:?}.suffixes"

		# Count domains matches for each suffix.
		while IFS= read -r regex || [ -n "${regex?}" ]; do
			if grep -- "${regex:?}" "${domainsFileTmp:?}" > "${domainsFileTmp:?}.match"; then
				count="$(awk '{s+=$1}END{print(s)}' "${domainsFileTmp:?}.match")"
				stats="$(printf -- '%s\t%s\n%s' "${count:?}" "${regex:?}" "${stats?}")"
				{ grep -v -- "${regex:?}" "${domainsFileTmp:?}" > "${domainsFileTmp:?}.aux" \
					&& mv -f -- "${domainsFileTmp:?}.aux" "${domainsFileTmp:?}";
				} || { :> "${domainsFileTmp:?}"; }
			fi
		done < "${domainsFileTmp:?}.suffixes"

		# Undo regex pattern.
		stats="$(printf -- '%s' "${stats?}" | sed 's/\\\././g;s/\$$//g')"
	fi

	# If the domains file is not empty, use TLD as suffix.
	if [ -s "${domainsFileTmp:?}" ]; then
		tldStats="$(sed -e 's/^\(.\{1,\}[[:blank:]]\).*\(\.[^.]\{1,\}\)$/\1\2/g' -- "${domainsFileTmp:?}" |
			awk '{arr[$2]+=$1;}END{for (i in arr) print(arr[i]"\t"i)}'
		)"

		stats="$(printf -- '%s\n%s' "${tldStats?}" "${stats?}")"
	fi

	# Remove the domains file.
	rm -f -- "${domainsFileTmp:?}"

	# Sort stats by the number of matches.
	stats="$(printf -- '%s' "${stats?}" | sort -k1,1nr -k2,2 | awk '{print(NR"\t"$0)}')"

	# Print stats.
	printf -- '%s\n%s\n' "${header:?}" "${stats?}"
}

main "${@-}"
