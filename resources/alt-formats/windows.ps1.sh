#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

main() {
	source="${1:?}"
	target="${2:?}"
	hblock="${3:-hblock}"

	mkdir -p -- "${target:?}.tmp"
	# shellcheck disable=SC2154
	trap 'ret="$?"; rm -rf -- "${target:?}.tmp"; trap - EXIT; exit "${ret:?}"' EXIT TERM INT HUP

	# shellcheck disable=SC2155
	export HBLOCK_HEADER="$(cat <<-'EOF'
		#Requires -RunAsAdministrator

		# Get the hosts file.
		$hosts = "$Env:WinDir\System32\drivers\etc\hosts"
		$hostsItem = Get-Item "$hosts"

		# Prevent Windows Defender from blocking the hosts file.
		# See: https://www.bleepingcomputer.com/news/microsoft/windows-10-hosts-file-blocking-telemetry-is-now-flagged-as-a-risk/
		Add-MpPreference -ExclusionPath "$hosts"

		# Disable and stop the Dnscache service.
		Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\Dnscache' -Name 'Start' -Value 4
		Get-WmiObject Win32_Service | Where { $_.name -eq 'Dnscache' -and $_.processID -ne 0 } | ForEach-Object { Stop-Process $_.processID -Force }

		# Set the "Normal" attribute to the hosts file.
		$hostsItem.Attributes = "Normal"

		@'
		# BEGIN HEADER
		127.0.0.1       localhost
		255.255.255.255 broadcasthost
		::1             localhost
		::1             ip6-localhost ip6-loopback
		fe00::0         ip6-localnet
		ff00::0         ip6-mcastprefix
		ff02::1         ip6-allnodes
		ff02::2         ip6-allrouters
		ff02::3         ip6-allhosts
		# END HEADER

		# BEGIN BLOCKLIST
	EOF
	)"
	# shellcheck disable=SC2155
	export HBLOCK_FOOTER="$(cat <<-'EOF'
		# END BLOCKLIST
		'@ | Set-Content "$hosts"

		# Set the "ReadOnly" attribute to the hosts file.
		$hostsItem.Attributes = "ReadOnly"
	EOF
	)"
	export HBLOCK_SOURCES="file://${source:?}"
	export HBLOCK_ALLOWLIST=''
	export HBLOCK_DENYLIST='hblock-check.molinero.dev'

	export HBLOCK_REDIRECTION='0.0.0.0'
	export HBLOCK_WRAP='1'
	export HBLOCK_TEMPLATE='%R %D'
	export HBLOCK_COMMENT=''

	export HBLOCK_LENIENT='false'
	export HBLOCK_REGEX='false'
	export HBLOCK_FILTER_SUBDOMAINS='false'
	export HBLOCK_CONTINUE='false'

	CR="$(printf '\rx')"; CR="${CR%x}"
	"${hblock:?}" -qO- | sed "s/$/${CR:?}/" > "${target:?}"
}

main "${@-}"
