#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

endsWith() {
	[ "${1%$2}" != "$1" ]
}

encodeURI() {
	printf -- '%s' "$1" | hexdump -ve '/1 "%02x"' | sed 's|\(..\)|%\1|g'
}

escapeHTML() {
	printf -- '%s' "$1" | \
		sed 's|&|\&#38;|g;s|<|\&#60;|g;s|>|\&#62;|g;s|"|\&#34;|g;s|'\''|\&#39;|g' | \
		sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\&#10;/g'
}

main() {
	directory="${1:-./}"

	if ! [ -d "$directory" ] || ! [ -r "$directory" ]; then
		>&2 printf -- '%s\n' "Cannot read directory '$directory'"
		exit 1
	fi

	entries=$(for file in ./"$directory"/*; do
		if ! [ -r "$file" ] || endsWith "$file" 'index.html'; then
			continue
		fi

		fileName=$(basename "$file")
		fileNameURI=$(encodeURI "$fileName")
		fileNameHTML=$(escapeHTML "$fileName")

		if [ -f "$file" ]; then
			fileSize=$(wc -c < "$file" | awk '{printf "%0.2f kB", $1 / 1000}')
		else
			fileSize=$(printf '\x20')
		fi
		fileSizeHTML=$(escapeHTML "$fileSize")

		fileType=$(file -bL --mime-type "$file")
		fileTypeHTML=$(escapeHTML "$fileType")

		fileDate=$(date -ur "$file" '+%Y-%m-%d %H:%M:%S %Z')
		fileDateHTML=$(escapeHTML "$fileDate")

		# Entry template
		printf -- '%s\n' "$(cat <<-EOF
			<a class="row" href="./${fileNameURI}" title="${fileNameHTML}">
				<div class="cell">${fileNameHTML}</div>
				<div class="cell">${fileSizeHTML}</div>
				<div class="cell">${fileTypeHTML}</div>
				<div class="cell">${fileDateHTML}</div>
			</a>
		EOF
		)"
	done)

	# Page template
	printf -- '%s\n' "$(tr -d '\n' <<-EOF
		<!DOCTYPE html>
		<html lang="en">

		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">

			<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline' https://hblock-check.molinero.xyz; img-src data:;">
			<meta http-equiv="X-UA-Compatible" content="IE=Edge">

			<title>Index of /hBlock</title>
			<meta name="description" content="Improve your security and privacy by blocking ads, tracking and malware domains">
			<meta name="author" content="Héctor Molinero Fernández <hector@molinero.xyz>">
			<meta name="license" content="MIT, https://opensource.org/licenses/MIT">

			<link rel="icon" type="image/png" href="data:image/png;base64,iVBORw0KGgo=">

			<!-- This resource is used to check if hBlock is disabled -->
			<link rel="stylesheet" href="https://hblock-check.molinero.xyz/status.css">

			<style>
				html {
					font-family: 'SFMono-Regular', 'Consolas', 'Liberation Mono', 'Menlo', monospace;
					font-size: 14px;
					color: #424242;
					background-color: #FFFFFF;
				}

				a {
					color: #0D47A1;
					text-decoration: none;
				}

				a:hover,
				a:focus {
					text-decoration: underline;
				}

				.container {
					margin: 40px auto;
					width: 100%;
					max-width: 1000px;
				}

				.header {
					margin: 0 10px 10px;
				}

				.title {
					font-weight: 700;
					font-size: 22px;
				}

				.table {
					display: table;
					width: 100%;
					border-collapse: collapse;
					table-layout: fixed;
				}

				.row {
					display: table-row;
				}

				.row:not(:last-child) {
					border-bottom: 1px solid #E0E0E0;
				}

				.row:first-child {
					font-weight: bold;
				}

				a.row {
					color: inherit;
					text-decoration: none;
				}

				a.row:hover,
				a.row:focus {
					background-color: #F5F5F5;
				}

				.cell {
					display: table-cell;
					padding: 15px 10px;
					white-space: pre;
					overflow: hidden;
					text-overflow: ellipsis;
				}

				@media (min-width: 768px) {
					.cell:nth-child(1) { width: 35%; }
					.cell:nth-child(2) { width: 15%; }
					.cell:nth-child(3) { width: 20%; }
					.cell:nth-child(4) { width: 30%; }
				}

				@media (max-width: 767.98px) {
					.table, .row, .cell {
						display: block;
					}

					.row {
						padding: 15px 10px;
					}

					.row:first-child {
						display: none;
					}

					.cell {
						padding: 0 0 5px;
						width: auto;
						white-space: normal;
					}

					.cell::before {
						display: inline-block;
						margin-right: 5px;
						font-weight: bold;
					}

					.cell:nth-child(1)::before {
						content: 'Filename:';
					}

					.cell:nth-child(2)::before {
						content: 'Size:';
					}

					.cell:nth-child(3)::before {
						content: 'Type:';
					}

					.cell:nth-child(4)::before {
						content: 'Modified:';
					}
				}
			</style>
		</head>

		<body>
			<div class="container">
				<div class="header">
					<h1 class="title">Index of /hBlock</h1>
					<p>Improve your security and privacy by blocking ads, tracking and malware domains.</p>
					<p>For details about this project, see <a href="https://github.com/zant95/hblock">github.com/zant95/hblock</a>.</p>
					<p id="hblock-status"><!-- If hBlock is disabled, an informational text will be displayed here --></p>
				</div>
				<div class="table">
					<div class="row">
						<div class="cell">Filename</div>
						<div class="cell">Size</div>
						<div class="cell">Type</div>
						<div class="cell">Modified</div>
					</div>
					${entries}
				</div>
			</div>
		</body>

		</html>
	EOF
	)"
}

main "$@"
