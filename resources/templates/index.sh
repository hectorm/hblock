#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hBlock
# License:    MIT, https://opensource.org/licenses/MIT

# Exit on errors
set -eu

# Globals
export LC_ALL=C

# Process
main() {
	directory="${1:-./}"

	if ! [ -d "$directory" ] || ! [ -r "$directory" ]; then
		>&2 printf -- '%s\n' "Cannot read directory '$directory'"
		exit 1
	fi

	entries=$(find -L "$directory" -maxdepth 1 -type f ! -iname '*.html' | sort |
		while IFS= read -r file; do
			if ! [ -r "$file" ]; then
				>&2 printf -- '%s\n' "Cannot read file '$file'"
				continue
			fi

			fileName=$(basename "$file")
			fileSize=$(du -shL "$file" | cut -f1)
			fileType=$(file -bL --mime-type "$file")
			fileDate=$(date -ur "$file" '+%Y-%m-%d %H:%M:%S %Z')

			# Entry template
			printf -- '%s\n' "$(cat <<-EOF
				<a class="row" href="./${fileName}">
					<div class="cell">${fileName}</div>
					<div class="cell">${fileSize}</div>
					<div class="cell">${fileType}</div>
					<div class="cell">${fileDate}</div>
				</a>
			EOF
			)"
		done
	)

	# Page template
	printf -- '%s\n' "$(tr -d '\n' <<-EOF
		<!DOCTYPE html>
		<html>

		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">

			<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; img-src data:;">
			<meta http-equiv="X-UA-Compatible" content="IE=Edge">

			<title>Index of /hBlock</title>
			<meta name="description" content="Save bandwidth by blocking ads, tracking and malware domains">
			<meta name="author" content="Héctor Molinero Fernández <hector@molinero.xyz>">
			<meta name="license" content="MIT, https://opensource.org/licenses/MIT">

			<link rel="icon" type="image/png" href="data:image/png;base64,iVBORw0KGgo=">

			<style>
				html {
					font-family: monospace;
					font-size: 14px;
					color: #424242;
					background-color: #FAFAFA;
				}

				a {
					color: inherit;
					text-decoration: none;
				}

				#container {
					margin: 40px auto;
					width: 100%;
					max-width: 1000px;
				}

				.title {
					margin: 0 10px 10px;
					font-size: 22px;
				}

				.table {
					display: table;
					width: 100%;
					border-collapse: collapse;
				}

				.row {
					display: table-row;
					border-bottom: 1px solid #BDBDBD;
				}

				.cell {
					display: table-cell;
					padding: 15px 10px;
					width: 25%;
					white-space: pre;
				}

				.row:first-child {
					font-weight: bold;
				}

				a.row:hover,
				a.row:focus {
					background-color: #EEE;
				}

				@media all and (max-width: 768px) {
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
			<div id="container">
				<h1 class="title">Index of <a href="https://github.com/zant95/hBlock">/hBlock</a></h1>
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

