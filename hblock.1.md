NAME
====

hBlock - manual page for hBlock 2.1.7

SYNOPSIS
========

**hblock** \[*OPTION*\]...

DESCRIPTION
===========

This POSIX-compliant shell script gets a list of domains that serve ads,
tracking scripts and malware from multiple sources and creates a hosts
file, among other formats, that prevents your system from connecting to
them.

OPTIONS
=======

**-O**, **--output** &lt;FILE&gt;

> Output file location.
>
> \- Environment variable: HBLOCK\_OUTPUT\_FILE
>
> \- Default value: */etc/hosts*

**-H**, **--header** &lt;FILE&gt;

> File to be included at the beginning of the output file.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> \- Environment variable: HBLOCK\_HEADER\_FILE
>
> \- Default value: */etc/hblock/header*

**-F**, **--footer** &lt;FILE&gt;

> File to be included at the end of the output file.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> \- Environment variable: HBLOCK\_FOOTER\_FILE
>
> \- Default value: */etc/hblock/footer*

**-S**, **--sources** &lt;FILE&gt;

> File with line separated URLs used to generate the blocklist.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> \- Environment variable: HBLOCK\_SOURCES\_FILE
>
> \- Default value: */etc/hblock/sources.list*

**-A**, **--allowlist** &lt;FILE&gt;

> File with line separated entries to be removed from the blocklist.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> \- Environment variable: HBLOCK\_ALLOWLIST\_FILE
>
> \- Default value: */etc/hblock/allow.list*

**-D**, **--denylist** &lt;FILE&gt;

> File with line separated entries to be added to the blocklist.
>
> If the default file does not exist or equals "builtin" the built-in
> value is used instead.
>
> \- Environment variable: HBLOCK\_DENYLIST\_FILE
>
> \- Default value: */etc/hblock/deny.list*

**-R**, **--redirection** &lt;REDIRECTION&gt;

> Redirection for all entries in the blocklist.
>
> \- Environment variable: HBLOCK\_REDIRECTION
>
> \- Default value: 0.0.0.0

**-W**, **--WRAP** &lt;NUMBER&gt;

> Break blocklist lines after this number of entries.
>
> \- Environment variable: HBLOCK\_WRAP
>
> \- Default value: 1

**-T**, **--template** &lt;TEMPLATE&gt;

> POSIX BREs replacement applied to each entry.
>
> Capturing group backreferences: \\1 = &lt;DOMAIN&gt;, \\2 =
> &lt;REDIRECTION&gt;
>
> \- Environment variable: HBLOCK\_TEMPLATE
>
> \- Default value: \\2 \\1

**-C**, **--comment** &lt;COMMENT&gt;

> Character used for comments.
>
> \- Environment variable: HBLOCK\_COMMENT
>
> \- Default value: \#

**-l**, **--\[no-\]lenient**

> Match all entries from sources regardless of their IP, instead of
> 0.0.0.0, 127.0.0.1, ::, ::1 or nothing.
>
> \- Environment variable: HBLOCK\_LENIENT
>
> \- Default value: false

**-r**, **--\[no-\]regex**

> Use POSIX BREs in the allowlist instead of fixed strings.
>
> \- Environment variable: HBLOCK\_REGEX
>
> \- Default value: false

**-c**, **--\[no-\]continue**

> Do not abort if a download error occurs.
>
> \- Environment variable: HBLOCK\_CONTINUE
>
> \- Default value: false

**-q**, **--\[no-\]quiet**

> Suppress non-error messages.
>
> \- Environment variable: HBLOCK\_QUIET
>
> \- Default value: false

**-x**, **--color** &lt;auto\|true\|false&gt;

> Colorize the output.
>
> \- Environment variable: HBLOCK\_COLOR
>
> \- Default value: auto

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
