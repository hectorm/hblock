#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

main() {
	hblock="./hblock"
	hosts="${1:?}"

	$hblock -qO- \
		--sources "file://$hosts" \
		--header "$(cat <<-'EOF'
			$TTL 2h
			@ IN SOA localhost. root.localhost. (1 6h 1h 1w 2h)
			  IN NS  localhost.
		EOF
		)" \
		--footer '' \
		--template '\1 CNAME .' \
		--comment ';'
}

main "$@"
