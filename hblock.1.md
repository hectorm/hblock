# NAME

hBlock - manual page for hBlock 3.2.0

# SYNOPSIS

**hblock** \[*OPTION*\]...

# DESCRIPTION

hBlock is a POSIX-compliant shell script that gets a list of domains
that serve ads, tracking scripts and malware from multiple sources and
creates a hosts file, among other formats, that prevents your system
from connecting to them.

# OPTIONS

**-O**, **--output** &lt;FILE\|-&gt;, ${HBLOCK\_OUTPUT\_FILE}

> Output file location.
>
> If equals "-", it is printed to stdout.
>
> (default: */etc/hosts*)

**-H**, **--header** &lt;FILE\|builtin\|none\|-&gt;,
${HBLOCK\_HEADER\_FILE}

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
> ${XDG\_CONFIG\_HOME}/hblock/header
>
> */etc/hblock/header*
>
> (default: builtin)

**-F**, **--footer** &lt;FILE\|builtin\|none\|-&gt;,
${HBLOCK\_FOOTER\_FILE}

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
> ${XDG\_CONFIG\_HOME}/hblock/footer
>
> */etc/hblock/footer*
>
> (default: builtin)

**-S**, **--sources** &lt;FILE\|builtin\|none\|-&gt;,
${HBLOCK\_SOURCES\_FILE}

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
> ${XDG\_CONFIG\_HOME}/hblock/sources.list
>
> */etc/hblock/sources.list*
>
> (default: builtin)

**-A**, **--allowlist** &lt;FILE\|builtin\|none\|-&gt;,
${HBLOCK\_ALLOWLIST\_FILE}

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
> ${XDG\_CONFIG\_HOME}/hblock/allow.list
>
> */etc/hblock/allow.list*
>
> (default: builtin)

**-D**, **--denylist** &lt;FILE\|builtin\|none\|-&gt;,
${HBLOCK\_DENYLIST\_FILE}

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
> ${XDG\_CONFIG\_HOME}/hblock/deny.list
>
> */etc/hblock/deny.list*
>
> (default: builtin)

**-R**, **--redirection** &lt;REDIRECTION&gt;, ${HBLOCK\_REDIRECTION}

> Redirection for all entries in the blocklist.
>
> (default: 0.0.0.0)

**-W**, **--wrap** &lt;NUMBER&gt;, ${HBLOCK\_WRAP}

> Break blocklist lines after this number of entries.
>
> (default: 1)

**-T**, **--template** &lt;TEMPLATE&gt;, ${HBLOCK\_TEMPLATE}

> Template applied to each entry.
>
> %D = &lt;DOMAIN&gt;, %R = &lt;REDIRECTION&gt;
>
> (default: %R %D)

**-C**, **--comment** &lt;COMMENT&gt;, ${HBLOCK\_COMMENT}

> Character used for comments.
>
> (default: \#)

**-l**, **--\[no-\]lenient**, ${HBLOCK\_LENIENT}

> Match all entries from sources regardless of their IP, instead of
> 0.0.0.0, 127.0.0.1, ::, ::1 or nothing.
>
> (default: false)

**-r**, **--\[no-\]regex**, ${HBLOCK\_REGEX}

> Use POSIX BREs in the allowlist instead of fixed strings.
>
> (default: false)

**-f**, **--\[no-\]filter-subdomains**, ${HBLOCK\_FILTER\_SUBDOMAINS}

> Do not include subdomains when the parent domain is also blocked.
> Useful for reducing the blocklist size in cases such as when DNS
> blocking makes these subdomains redundant.
>
> (default: false)

**-c**, **--\[no-\]continue**, ${HBLOCK\_CONTINUE}

> Do not abort if a download error occurs.
>
> (default: false)

**-q**, **--\[no-\]quiet**, ${HBLOCK\_QUIET}

> Suppress non-error messages.
>
> (default: false)

**-x**, **--color** &lt;auto\|true\|false&gt;, ${HBLOCK\_COLOR}

> Colorize the output.
>
> (default: auto)

**-v**, **--version**

> Show version number and quit.

**-h**, **--help**

> Show this help and quit.

# REPORTING BUGS

Report bugs to: &lt;https://github.com/hectorm/hblock/issues&gt;

  
Author: Héctor Molinero Fernández &lt;hector@molinero.dev&gt;  
License: MIT, https://opensource.org/licenses/MIT  
Repository: https://github.com/hectorm/hblock
