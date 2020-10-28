NAME
====

hBlock - manual page for hBlock 2.1.7

SYNOPSIS
========

**hblock** \[*OPTION*\]...

DESCRIPTION
===========

hBlock is a POSIX-compliant shell script that gets a list of domains
that serve ads, tracking scripts and malware from multiple sources and
creates a hosts file, among other formats, that prevents your system
from connecting to them.

OPTIONS
=======

**-O**, **--output** &lt;FILE&gt;, ${HBLOCK\_OUTPUT\_FILE}

> Output file location.
>
> (default: */etc/hosts*)

**-H**, **--header** &lt;FILE&gt;, ${HBLOCK\_HEADER\_FILE}

> File to be included at the beginning of the output file.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> (default: */etc/hblock/header*)

**-F**, **--footer** &lt;FILE&gt;, ${HBLOCK\_FOOTER\_FILE}

> File to be included at the end of the output file.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> (default: */etc/hblock/footer*)

**-S**, **--sources** &lt;FILE&gt;, ${HBLOCK\_SOURCES\_FILE}

> File with line separated URLs used to generate the blocklist.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> (default: */etc/hblock/sources.list*)

**-A**, **--allowlist** &lt;FILE&gt;, ${HBLOCK\_ALLOWLIST\_FILE}

> File with line separated entries to be removed from the blocklist.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> (default: */etc/hblock/allow.list*)

**-D**, **--denylist** &lt;FILE&gt;, ${HBLOCK\_DENYLIST\_FILE}

> File with line separated entries to be added to the blocklist.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> (default: */etc/hblock/deny.list*)

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

REPORTING BUGS
==============

Report bugs to: &lt;https://github.com/hectorm/hblock/issues&gt;

  
Author: Héctor Molinero Fernández &lt;hector@molinero.dev&gt;  
License: MIT, https://opensource.org/licenses/MIT  
Repository: https://github.com/hectorm/hblock
