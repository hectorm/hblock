#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(CDPATH='' cd -- "$(dirname -- "${0:?}")" && pwd -P)"

export TEST_SHELL='/bin/sh'

export HBLOCK_OUTPUT_FILE='/dev/null'

export HBLOCK_HEADER_FILE='builtin'
export HBLOCK_HEADER=''

export HBLOCK_FOOTER_FILE='builtin'
export HBLOCK_FOOTER=''

export HBLOCK_SOURCES_FILE='builtin'
export HBLOCK_SOURCES="file://${SCRIPT_DIR:?}/sources.txt"

export HBLOCK_ALLOWLIST_FILE='builtin'
export HBLOCK_ALLOWLIST=''

export HBLOCK_DENYLIST_FILE='builtin'
export HBLOCK_DENYLIST=''

export HBLOCK_REDIRECTION='0.0.0.0'
export HBLOCK_WRAP='1'
export HBLOCK_TEMPLATE='\2 \1'
export HBLOCK_COMMENT='#'

export HBLOCK_LENIENT='false'
export HBLOCK_REGEX='false'
export HBLOCK_CONTINUE='false'

export HBLOCK_QUIET='false'
export HBLOCK_COLOR='false'
