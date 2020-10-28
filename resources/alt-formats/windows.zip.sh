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
	trap 'rm -rf -- "${target:?}.tmp"; trap - EXIT; exit 0' EXIT TERM INT HUP

	export HBLOCK_HEADER_FILE='builtin'
	export HBLOCK_HEADER=''

	export HBLOCK_FOOTER_FILE='builtin'
	export HBLOCK_FOOTER=''

	export HBLOCK_SOURCES_FILE='builtin'
	export HBLOCK_SOURCES="file://${source:?}"

	export HBLOCK_ALLOWLIST_FILE='builtin'
	export HBLOCK_ALLOWLIST=''

	export HBLOCK_DENYLIST_FILE='builtin'
	export HBLOCK_DENYLIST='hblock-check.molinero.dev'

	export HBLOCK_REDIRECTION='0.0.0.0'
	export HBLOCK_WRAP='1'
	export HBLOCK_TEMPLATE='%R %D'
	export HBLOCK_COMMENT='#'

	export HBLOCK_LENIENT='false'
	export HBLOCK_REGEX='false'
	export HBLOCK_CONTINUE='false'

	"${hblock:?}" -qO "${target:?}.tmp"/hosts

	tee -- "${target:?}.tmp"/install.bat >/dev/null <<-'EOF'
		:: Author:     Héctor Molinero Fernández <hector@molinero.dev>
		:: License:    MIT, https://opensource.org/licenses/MIT
		:: Repository: https://github.com/hectorm/hblock

		:: This script needs administrator privileges.
		:: WARNING: consider disabling "DNS Client" service if your machine slows down.

		@echo off

		set "source=%~dp0hosts"
		set "target=%windir%\System32\drivers\etc\hosts"

		echo.
		echo ==================
		echo #     hBlock     #
		echo ==================
		echo.

		if exist "%source%" (
		    if exist "%target%" (
		        attrib -r -s -h "%target%" > nul
		    )

		    copy /y "%source%" "%target%" > nul
		    attrib +r "%target%" > nul
		) else (
		    echo Error, source file not found.
		)

		echo Execution finished.
		echo.

		pause
	EOF

	find "${target:?}.tmp" -exec touch -d '1980-01-01T00:00:00.0Z' '{}' ';'
	TZ='UTC' zip -rjlXq "${target:?}" "${target:?}.tmp"
}

main "${@-}"
