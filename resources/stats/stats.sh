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
	for l in 'C.UTF-8' 'en_US.UTF-8' "${LC_CTYPE-}" "${LANG-}"; do
		if LC_ALL="${l?}" "${idnCmd:?}" 'λ' >/dev/null 2>&1; then LC_ALL="${l?}" "${idnCmd:?}"; break; fi
	done
}

main() {
	domainsFile="${1:?}"
	publicSuffixList="${2:-https://publicsuffix.org/list/public_suffix_list.dat}"

	if [ ! -e "${domainsFile:?}" ]; then
		printf -- '%s\n' "No such file: '${domainsFile:?}'" >&2
		exit 1
	fi

	# Create a temporary work directory.
	tmpWorkDir="$(createTempDir)"
	trap 'rm -rf -- "${tmpWorkDir:?}"; trap - EXIT; exit 0' EXIT TERM INT HUP

	# Copy domains file.
	domainsFileTmp="${tmpWorkDir:?}/domains.list"
	cp -f -- "${domainsFile:?}" "${domainsFileTmp:?}"

	if [ "${publicSuffixList:?}" = 'no-psl' ]; then
		# Remove until the last part of the domain and count occurrences.
		sed -ne 's/^.*\(\.[^.]\{1,\}\)$/\1/p' -- "${domainsFileTmp:?}" \
			| awk '{A[$1]++}END{for(i in A)printf("%s\t%s\n",A[i],i)}' >> "${domainsFileTmp:?}.stats"
	else
		# Download public suffix list.
		fetchUrl "${publicSuffixList:?}" > "${domainsFileTmp:?}.suffixes"

		# Punycode encode suffix list, sort suffixes by length in descending order and transform each one into regexes.
		sed -e '/^\/\//d;/^!/d;/^$/d;s/^\*\.//g' -- "${domainsFileTmp:?}.suffixes" \
			| punycodeEncode | awk '{printf("%s\t.%s\n",length($0),$0)}' | sort -nr | cut -f2 \
			| sed -e 's/\./\\./g;s/$/$/g' > "${domainsFileTmp:?}.suffixes.aux" \
			&& mv -f -- "${domainsFileTmp:?}.suffixes.aux" "${domainsFileTmp:?}.suffixes"

		# Remove the last part of the domain and count occurrences.
		sed -e 's/^[^.]\{1,\}//' -- "${domainsFileTmp:?}" \
			| awk '{A[$1]++}END{for(i in A)printf("%s\t%s\n",A[i],i)}' > "${domainsFileTmp:?}.aux" \
			&& mv -f -- "${domainsFileTmp:?}.aux" "${domainsFileTmp:?}"

		# Count occurrences for each suffix.
		while IFS= read -r suffix || [ -n "${suffix?}" ]; do
			if grep -- "${suffix:?}" "${domainsFileTmp:?}" > "${domainsFileTmp:?}.match"; then
				count="$(awk '{N+=$1}END{print(N)}' < "${domainsFileTmp:?}.match")"
				printf -- '%s\t%s\n' "${count:?}" "${suffix:?}" >> "${domainsFileTmp:?}.stats"
				{ grep -v -- "${suffix:?}" "${domainsFileTmp:?}" > "${domainsFileTmp:?}.aux" \
					&& mv -f -- "${domainsFileTmp:?}.aux" "${domainsFileTmp:?}";
				} || { true > "${domainsFileTmp:?}"; }
			fi
		done < "${domainsFileTmp:?}.suffixes"

		# Transform back regexes into fixed strings.
		if [ -s "${domainsFileTmp:?}.stats" ]; then
			sed -e 's/\\\././g;s/\$$//g' \
				-- "${domainsFileTmp:?}.stats" > "${domainsFileTmp:?}.stats.aux" \
				&& mv -f -- "${domainsFileTmp:?}.stats.aux" "${domainsFileTmp:?}.stats"
		fi

		# If the domains file is not empty, use TLD as suffix.
		if [ -s "${domainsFileTmp:?}" ]; then
			# Remove until the last part of the domain and count occurrences.
			sed -ne 's/^\([0-9]\{1,\}[[:blank:]]\).*\(\.[^.]\{1,\}\)$/\1\2/p' -- "${domainsFileTmp:?}" \
				| awk '{A[$2]+=$1}END{for(i in A)printf("%s\t%s\n",A[i],i)}' >> "${domainsFileTmp:?}.stats"
		fi
	fi

	# Sort suffixes by the number of occurrences in descending order and then alphabetically in ascending order.
	# Using the "-k" option of the sort command would be much simpler, but I have found in the wild some BusyBox
	# builds that do not include this option (e.g. OpenWrt).
	awkSortScript="$(cat <<-'EOF'
		function qsort(A, left, right) {
			if (left >= right) return
			swap(A, left, left+int((right-left+1)*rand()))
			last = left
			for (i = left+1; i <= right; i++) {
				if (compare(A, i, left)) swap(A, ++last, i)
			}
			swap(A, left, last)
			qsort(A, left, last-1)
			qsort(A, last+1, right)
		}
		function swap(A, i, j) {
			t1 = A[i,1]; A[i,1] = A[j,1]; A[j,1] = t1
			t2 = A[i,2]; A[i,2] = A[j,2]; A[j,2] = t2
		}
		function compare(A, a, b) {
			if (int(A[a,1]) > int(A[b,1])) return 1
			if (int(A[a,1]) < int(A[b,1])) return 0
			if (A[a,2] < A[b,2]) return 1
			if (A[a,2] > A[b,2]) return 0
		}
		{ split($0, r); A[NR,1] = r[1]; A[NR,2] = r[2] }
		END {
			qsort(A, 1, NR)
			printf("%s\t%s\t%s\n", "Top", "Hosts", "Suffix")
			for (i = 1; i <= NR; i++) printf("%s\t%s\t%s\n", i, A[i,1], A[i,2])
		}
	EOF
	)"
	awk "${awkSortScript:?}" < "${domainsFileTmp:?}.stats"
}

main "${@-}"
