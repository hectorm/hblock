## Usage

```
 -O, --output <FILE>
        Output file location.
         * Environment variable: HBLOCK_OUTPUT_FILE
         * Default value: /etc/hosts
 -H, --header <FILE>
        File to be included at the beginning of the output file.
        If the default file does not exist or equals "builtin" the built-in
        value is used instead.
         * Environment variable: HBLOCK_HEADER_FILE
         * Default value: /etc/hblock/header
 -F, --footer <FILE>
        File to be included at the end of the output file.
        If the default file does not exist or equals "builtin" the built-in
        value is used instead.
         * Environment variable: HBLOCK_FOOTER_FILE
         * Default value: /etc/hblock/footer
 -S, --sources <FILE>
        File with line separated URLs used to generate the blocklist.
        If the default file does not exist or equals "builtin" the built-in
        value is used instead.
         * Environment variable: HBLOCK_SOURCES_FILE
         * Default value: /etc/hblock/sources.list
 -A, --allowlist <FILE>
        File with line separated entries to be removed from the blocklist.
        If the default file does not exist or equals "builtin" the built-in
        value is used instead.
         * Environment variable: HBLOCK_ALLOWLIST_FILE
         * Default value: /etc/hblock/allow.list
 -D, --denylist <FILE>
        File with line separated entries to be added to the blocklist.
        If the default file does not exist or equals "builtin" the built-in
        value is used instead.
         * Environment variable: HBLOCK_DENYLIST_FILE
         * Default value: /etc/hblock/deny.list
 -R, --redirection <REDIRECTION>
        Redirection for all entries in the blocklist.
         * Environment variable: HBLOCK_REDIRECTION
         * Default value: 0.0.0.0
 -W, --WRAP <NUMBER>
        Break blocklist lines after this number of entries.
         * Environment variable: HBLOCK_WRAP
         * Default value: 1
 -T, --template <TEMPLATE>
        POSIX BREs replacement applied to each entry.
        Capturing group backreferences: \1 = <DOMAIN>, \2 = <REDIRECTION>
         * Environment variable: HBLOCK_TEMPLATE
         * Default value: \2 \1
 -C, --comment <COMMENT>
        Character used for comments.
         * Environment variable: HBLOCK_COMMENT
         * Default value: #
 -l, --[no-]lenient
        Match all entries from sources regardless of their IP, instead
        of 0.0.0.0, 127.0.0.1, ::, ::1 or nothing.
         * Environment variable: HBLOCK_LENIENT
         * Default value: false
 -r, --[no-]regex
        Use POSIX BREs in the allowlist instead of fixed strings.
         * Environment variable: HBLOCK_REGEX
         * Default value: false
 -c, --[no-]continue
        Do not abort if a download error occurs.
         * Environment variable: HBLOCK_CONTINUE
         * Default value: false
 -q, --[no-]quiet
        Suppress non-error messages.
         * Environment variable: HBLOCK_QUIET
         * Default value: false
 -x, --color <auto|true|false>
        Colorize the output.
         * Environment variable: HBLOCK_COLOR
         * Default value: auto
 -v, --version
        Show version number and quit.
 -h, --help
        Show this help and quit.
```
