# NAME

hBlock - manual page for hBlock 3.4.0

# SYNOPSIS

**hblock** \[*OPTION*\]...

# DESCRIPTION

hBlock is a POSIX-compliant shell script that gets a list of domains
that serve ads, tracking scripts and malware from multiple sources and
creates a hosts file, among other formats, that prevents your system
from connecting to them.

# OPTIONS

**-O**, **--output** \<FILE\|-\>, ${HBLOCK_OUTPUT_FILE}

> Output file location.
>
> If equals "-", it is printed to stdout.
>
> (default: */etc/hosts*)

**-H**, **--header** \<FILE\|builtin\|none\|-\>, ${HBLOCK_HEADER_FILE}

> File to be included at the beginning of the output file.
>
> If equals "builtin", the built-in value is used.
>
> If equals "none", an empty value is used.
>
> If equals "-", the stdin content is used.
>
> If unspecified and any of the following files exists, its content is
> used.
>
> ${XDG_CONFIG_HOME}/hblock/header
>
> */etc/hblock/header*
>
> (default: builtin)

**-F**, **--footer** \<FILE\|builtin\|none\|-\>, ${HBLOCK_FOOTER_FILE}

> File to be included at the end of the output file.
>
> If equals "builtin", the built-in value is used.
>
> If equals "none", an empty value is used.
>
> If equals "-", the stdin content is used.
>
> If unspecified and any of the following files exists, its content is
> used.
>
> ${XDG_CONFIG_HOME}/hblock/footer
>
> */etc/hblock/footer*
>
> (default: builtin)

**-S**, **--sources** \<FILE\|builtin\|none\|-\>, ${HBLOCK_SOURCES_FILE}

> File with line separated URLs used to generate the blocklist.
>
> If equals "builtin", the built-in value is used.
>
> If equals "none", an empty value is used.
>
> If equals "-", the stdin content is used.
>
> If unspecified and any of the following files exists, its content is
> used.
>
> ${XDG_CONFIG_HOME}/hblock/sources.list
>
> */etc/hblock/sources.list*
>
> (default: builtin)

**-A**, **--allowlist** \<FILE\|builtin\|none\|-\>,
${HBLOCK_ALLOWLIST_FILE}

> File with line separated entries to be removed from the blocklist.
>
> If equals "builtin", the built-in value is used.
>
> If equals "none", an empty value is used.
>
> If equals "-", the stdin content is used.
>
> If unspecified and any of the following files exists, its content is
> used.
>
> ${XDG_CONFIG_HOME}/hblock/allow.list
>
> */etc/hblock/allow.list*
>
> (default: builtin)

**-D**, **--denylist** \<FILE\|builtin\|none\|-\>,
${HBLOCK_DENYLIST_FILE}

> File with line separated entries to be added to the blocklist.
>
> If equals "builtin", the built-in value is used.
>
> If equals "none", an empty value is used.
>
> If equals "-", the stdin content is used.
>
> If unspecified and any of the following files exists, its content is
> used.
>
> ${XDG_CONFIG_HOME}/hblock/deny.list
>
> */etc/hblock/deny.list*
>
> (default: builtin)

**-R**, **--redirection** \<REDIRECTION\>, ${HBLOCK_REDIRECTION}

> Redirection for all entries in the blocklist.
>
> (default: 0.0.0.0)

**-W**, **--wrap** \<NUMBER\>, ${HBLOCK_WRAP}

> Break blocklist lines after this number of entries.
>
> (default: 1)

**-T**, **--template** \<TEMPLATE\>, ${HBLOCK_TEMPLATE}

> Template applied to each entry.
>
> %D = \<DOMAIN\>, %R = \<REDIRECTION\>
>
> (default: %R %D)

**-C**, **--comment** \<COMMENT\>, ${HBLOCK_COMMENT}

> Character used for comments.
>
> (default: \#)

**-l**, **--\[no-\]lenient**, ${HBLOCK_LENIENT}

> Match all entries from sources regardless of their IP, instead of
> 0.0.0.0, 127.0.0.1, ::, ::1 or nothing.
>
> (default: false)

**-r**, **--\[no-\]regex**, ${HBLOCK_REGEX}

> Use POSIX BREs in the allowlist instead of fixed strings.
>
> (default: false)

**-f**, **--\[no-\]filter-subdomains**, ${HBLOCK_FILTER_SUBDOMAINS}

> Do not include subdomains when the parent domain is also blocked.
> Useful for reducing the blocklist size in cases such as when DNS
> blocking makes these subdomains redundant.
>
> (default: false)

**-c**, **--\[no-\]continue**, ${HBLOCK_CONTINUE}

> Do not abort if a download error occurs.
>
> (default: false)

**-p**, **--parallel**, ${HBLOCK_PARALLEL}

> Maximum concurrency for parallel downloads.
>
> (default: 4)

**-q**, **--\[no-\]quiet**, ${HBLOCK_QUIET}

> Suppress non-error messages.
>
> (default: false)

**-x**, **--color** \<auto\|true\|false\>, ${HBLOCK_COLOR}

> Colorize the output.
>
> (default: auto)

**-v**, **--version**

> Show version number and quit.

**-h**, **--help**

> Show this help and quit.

# REPORTING BUGS

Report bugs to: \<https://github.com/hectorm/hblock/issues\>

  
Author: Héctor Molinero Fernández \<hector@molinero.dev\>  
License: MIT, https://opensource.org/licenses/MIT  
Repository: https://github.com/hectorm/hblock
