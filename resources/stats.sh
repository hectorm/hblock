#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/misc
# License:    MIT, https://opensource.org/licenses/MIT
#

if [ $# -eq 0 ]; then
	hosts=$(cat /etc/hosts)
elif [ -f "$1" ] && [ -r "$1" ]; then
	hosts=$(cat "$1")
else
	>&2 printf -- '%s\n' "Cannot read file '$1'"
	exit 1
fi

printf -- '%s\t%s\t%s\n' 'Top' 'Domains' 'TLD'
printf -- '%s' "$hosts" | \
	sed -n '/<blocklist>/,/<\/blocklist>/p' | \
	sed -n 's/.\{1,\}\.\(.\{1,\}\)$/\1/p' | \
	sort | uniq -c | sort -rn | \
	awk '{print NR,$0}' | \
	tr -s ' ' '\t'

