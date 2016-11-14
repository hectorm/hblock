#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/zant95/hBlock
# License:    MIT, https://opensource.org/licenses/MIT

# Exit on errors
set -eu

# Globals
export LC_ALL=C
readonly workDir="$1"

# Process
cd "$workDir"

entries=$(find ./ -maxdepth 1 -type f ! -iname '*.html' -exec basename {} \; | sort | \
	while read file; do
		printf -- '%s\n' "\
			<a class=\"row\" href=\"./$file\">
				<div class=\"cell\">$file</div>
				<div class=\"cell\">$(du -sh "$file" | cut -f1)</div>
				<div class=\"cell\">$(date -ur "$file")</div>
			</a>"
	done
)

# Index template
cat > ./index.html <<EOF
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline';">
	<meta name="author" content="Héctor Molinero Fernández <hector@molinero.xyz>">
	<meta name="license" content="MIT, https://opensource.org/licenses/MIT">

	<title>hBlock files</title>

	<style>
		html {
			font-family: monospace;
			font-size: 16px;
			color: #424242;
			background-color: #FAFAFA;
		}

		a {
			color: inherit;
			text-decoration: none;
			border-bottom: 1px dashed #424242;
		}

		#container {
			margin: 0 auto;
			width: 100%;
			max-width: 1000px;
			white-space: nowrap;
		}

		.title {
			margin: 30px 20px;
			font-size: 24px;
		}

		.table {
			display: table;
			width: 100%;
		}

		.table > .row {
			display: table-row;
		}

		.table > .row > .cell {
			display: table-cell;
			padding: 15px 20px;
			width: 33%;
			border-bottom: 1px solid #E0E0E0;
		}

		.table > .row:first-child {
			font-weight: bold;
		}

		.table > a.row:hover,
		.table > a.row:focus {
			background-color: #EEE;
		}
	</style>
</head>

<body>
	<div id="container">
		<h1 class="title"><a href="https://github.com/zant95/hBlock">hBlock</a> files</h1>
		<div class="table">
			<div class="row">
				<div class="cell">Name</div>
				<div class="cell">Size</div>
				<div class="cell">Last modified</div>
			</div>
$entries
		</div>
	</div>
</body>

</html>
EOF

