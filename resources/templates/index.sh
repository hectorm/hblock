#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

# Check if a program exists
exists() {
	if command -v true; then command -v -- "$1"
	elif eval type type; then eval type -- "$1"
	else which -- "$1"; fi >/dev/null 2>&1
}

# Check whether a string ends with the characters of a specified string
endsWith() { str=$1 && substr=$2 && [ "${str%$substr}" != "$str" ]; }

# Escape string for use in HTML
escapeHTML() {
	printf -- '%s' "$1" | \
		sed -e 's|&|\&#38;|g;s|<|\&#60;|g;s|>|\&#62;|g;s|"|\&#34;|g;s|'\''|\&#39;|g' | \
		sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\&#10;/g'
}

# RFC 3986 compliant URL encoding method
encodeURI() {
	_LC_COLLATE=${LC_COLLATE-}; LC_COLLATE=C; _IFS=$IFS; IFS=:
	hex=$(printf -- '%s' "$1" | hexdump -ve '/1 ":%02X"'); hex=${hex#:}
	for h in $hex; do
		case "$h" in
			3[0-9]|\
			4[1-9A-F]|5[0-9A]|\
			6[1-9A-F]|7[0-9A]|\
			2D|5F|2E|7E\
			) printf '%b' "\\$(printf '%o' "0x$h")" ;;
			*) printf '%%%s' "$h"
		esac
	done
	LC_COLLATE=$_LC_COLLATE; IFS=$_IFS
}

# Calculate digest for Content-Security-Policy
cspDigest() {
	hex=$(printf -- '%s' "$1" | sha256sum | cut -f1 -d' ' | sed 's|\(.\{2\}\)|\1 |g')
	b64=$(for h in $hex; do printf '%b' "\\$(printf '%o' "0x$h")"; done | base64)
	printf 'sha256-%s' "$b64"
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
		escapedFileName=$(escapeHTML "$fileName")
		escapedFileNameURI=$(escapeHTML "$(encodeURI "$fileName")")

		if [ -f "$file" ]; then
			fileSize=$(wc -c < "$file" | awk '{printf "%0.2f kB", $1 / 1000}')
			escapedFileSize=$(escapeHTML "$fileSize")
		else
			fileSize=$(printf '\x20')
			escapedFileSize=$fileSize
		fi

		if exists file; then
			fileType=$(file -bL --mime-type "$file")
			escapedFileType=$(escapeHTML "$fileType")
		else
			fileType=$(printf 'application/octet-stream')
			escapedFileType=$fileType
		fi

		fileDate=$(date -ur "$file" '+%Y-%m-%d %H:%M:%S %Z')
		escapedFileDate=$(escapeHTML "$fileDate")

		# Entry template
		printf -- '%s\n' "$(cat <<-EOF
			<a class="row" href="./${escapedFileNameURI}" title="${escapedFileName}">
				<div class="cell">${escapedFileName}</div>
				<div class="cell">${escapedFileSize}</div>
				<div class="cell">${escapedFileType}</div>
				<div class="cell">${escapedFileDate}</div>
			</a>
		EOF
		)"
	done)

	# Generated with:
	#  $ (printf '%s' 'data:image/png;base64,'; base64 -w0 'resources/logo/bitmap/favicon-32x32.png') | fold -w 128
	favicon=$(tr -d '\n' <<-'EOF'
		data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAE7AAABOwBim79cgAAABl0RVh0U2
		9mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAOCSURBVFiFvZdPaBRXHMc/v9l13bLWHHIolvRixVkPFVyUSi6VgL3prTcvQmlrNWBrIQfjoaEnQQu1VLS04qHYQ6
		8eTEAkECrdKLpFyGzDkkqy0iLCJlm3bDPv52FSk533Jrubbfu7ze/P9/d5782beQ96MAVRkF40emoe7t59Kcznr/7vEC+b+76Gvq+9QHRdpIcOpc2TJ18DH8ZCV7wdO0
		7JnTsrPQHowMAr5HJpCYKlFr/vvxqKvAOMiurbTjjVu6h+kfK8SVc99fqKzM83NgQI8/mLqH6y+lgDDJABct2MDKgDTcAD+qJu8mVqZubT9UnpNiJ9XTZdbzk6gPZ6aP
		Cv2OYBRJDjx5Fjx3oCsJfAmAbSfnPIkSPIyEj0MDSEXr4M9+9DGCYXGdOIu2wAkUXLd+AAcuIE0t+PTk2h589DNrtWMjiIDA7C4iJUq+izZxFQsdhW214C1aW4S7LZqI
		HvQ27de9VowMq6bb99O+TzEdDWrZY00B5AHZS6aE+K3ryJKRQwhQI6PAxPn7bGl6xxoJ0AuChZXraz6nVIpyEM0YkJzMmTrevvAECk1hYgpfq7VRgbHQC7duFNTeFNTs
		LAADx8CA8eRDFVZ00KLG17BrLZWUBbfLUaVKstLikUojXv70cOHoz6VipRcGEheiFbzbC8PNsWQEqlOlCJ+/XRI4t1TWVVxpiNcn+L/wecAKt21/KUSskAneUWXU43gM
		hk3KW3boEqsncvcuYMHD68ln70KDI2huzfD6pRbrxe1dKEhPOA+v7rBubjce/GDdi3z8n80qanMfbnWT3VN6RcXogHnDMgQVBVkV8slWvXNm4O6PXrtg9+djVPBAAQ+N
		4SGh+H6enk7sUiOjHhinyXVJII4GUyPwDWZjajo64tBrUa5uxZl9SfqW3bfuwaQEqlOiIXrcDcHHr6dPQf+MfqdczwMDx+7JK6IPfuPU/skxSA6HxocrlfgTet4J49eG
		NjAJhz52BmxiGgs16z+ZbMzf21KQCAv31/yINxIGUFYx+gmIUG3t0SBLc30m97ItoSBLcRGXEGjUlqDvBZu+bQxb0g9P1vgfc7Sla9miqX4/cGp3V8JvSC4ANEPu8g9S
		uvXP6oU92ub0Yrvv+eqF5C5LWWgOofKnIqHQQ/daO3qfuc7tzZZzKZj1GNplnkitdsfiOVinXg+E9NwdMe7xYvAMzCXKEtGQxuAAAAAElFTkSuQmCC
	EOF
	)

	# Generated with:
	#  $ svgo --datauri=enc --output=- 'resources/logo/logotype.svg' | fold -w 128
	logotype=$(tr -d '\n' <<-'EOF'
		data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22320%22%20height%3D%2296%22%20viewBox
		%3D%220%200%20500%20150%22%3E%3Cpath%20fill%3D%22%23FFF%22%20d%3D%22M60.724%20121.732c-3.263-1.302-11.67-5.523-19.214-16.564-8.9
		74-13.134-13.525-31.075-13.525-53.324V39.338l12.126.589c.578-.018%201.859-.072%202.592-.103%201.72-.072%202.09-.087%202.479-.087
		a16.18%2016.18%200%200%200%2011.524-4.78l8.433-8.449%208.431%208.448a16.173%2016.173%200%200%200%2011.523%204.78c.392%200%20.76.
		015%202.48.088.733.03%202.015.085%202.591.103l12.126-.59v12.507c0%2022.249-4.55%2040.19-13.525%2053.324-7.544%2011.041-15.95%201
		5.262-19.214%2016.564l-4.412%201.76z%22%2F%3E%3Cpath%20fill%3D%22%23FD2727%22%20d%3D%22M101.638%2023.847c-.84-.025-2.71-.105-3.7
		8-.15-2.507-.105-3.045-.127-3.616-.127-6.35%200-12.318-2.477-16.806-6.972L65.14%204.277l-12.298%2012.32c-4.489%204.497-10.457%20
		6.973-16.808%206.973-.568%200-1.107.02-3.615.128-1.07.044-2.938.124-3.78.149l-17.686-.86v18.24c0%2032.45%206.637%2058.616%2019.7
		26%2077.772%2011.004%2016.103%2023.264%2022.258%2028.023%2024.157l6.438%202.567%206.436-2.567c4.762-1.898%2017.02-8.054%2028.023
		-24.158%2013.088-19.155%2019.725-45.322%2019.725-77.77v-18.24zm-36.499%2093.788c-3.687-1.47-29.773-13.838-29.773-69.388.49.023%2
		05.733-.23%206.232-.23%202.61%200%205.146-.31%207.585-.88v39.487h9.404V70.252a6.637%206.637%200%200%201%206.453-5.05%206.656%206
		.656%200%200%201%206.647%206.647v14.276h9.404V71.85c0-8.85-7.2-16.052-16.052-16.052-2.283%200-4.47.482-6.453%201.353v-13.8a33.45
		2%2033.452%200%200%200%206.552-5.096c6.02%206.03%2014.344%209.765%2023.54%209.765.498%200%205.741.252%206.231.229.001%2055.55-26
		.087%2067.917-29.77%2069.387z%22%2F%3E%3Cg%20fill%3D%22%23FD2727%22%3E%3Cpath%20d%3D%22M172.213%2058.578c-4.26%200-8.34.9-12.041
		%202.527V33.904h-17.547v82.19h17.547V85.549a12.385%2012.385%200%200%201%2012.041-9.427c6.838%200%2012.408%205.565%2012.408%2012.
		405v26.64h17.544v-26.64c-.002-16.511-13.436-29.948-29.952-29.948zM214.613%2039.552h25.706c15.56%200%2027.668%204.265%2027.668%20
		18.676%200%206.686-3.69%2013.949-9.8%2016.253v.461c7.608%201.96%2013.489%207.61%2013.489%2017.638%200%2015.332-12.913%2022.133-2
		9.165%2022.133h-27.897V39.552zm24.898%2030.087c8.3%200%2011.874-3.457%2011.874-8.876%200-5.88-3.804-8.07-11.758-8.07h-8.07V69.64
		zm1.615%2031.932c9.222%200%2013.948-3.23%2013.948-10.146%200-6.568-4.612-9.221-13.948-9.221h-9.568v19.367zM282.97%2096.96V33.904
		h16.947v63.748c0%203.571%201.615%204.725%202.997%204.725.692%200%201.153%200%202.076-.229l2.075%2012.563c-1.844.808-4.725%201.38
		4-8.531%201.384-11.643.002-15.563-7.608-15.563-19.135zM312.597%2086.123c0-19.02%2013.372-29.972%2027.897-29.972%2014.409%200%202
		7.781%2010.951%2027.781%2029.972%200%2019.022-13.37%2029.973-27.78%2029.973-14.525%200-27.898-10.951-27.898-29.973zm38.387%200c0
		-9.913-3.573-16.253-10.488-16.253-7.032%200-10.49%206.339-10.49%2016.253%200%209.915%203.458%2016.256%2010.49%2016.256%206.913%2
		00%2010.488-6.341%2010.488-16.256zM376.577%2086.123c0-19.02%2013.948-29.972%2029.74-29.972%207.031%200%2012.45%202.534%2016.715%
		206.11l-7.954%2010.951c-2.767-2.307-5.073-3.342-7.725-3.342-8.183%200-13.37%206.339-13.37%2016.253%200%209.915%205.417%2016.256%
		2012.795%2016.256%203.687%200%207.261-1.845%2010.258-4.151l6.688%2011.066c-5.651%204.959-12.682%206.802-18.907%206.802-15.908%20
		0-28.24-10.951-28.24-29.973zM433.753%2033.904h16.484v46.34h.462l18.098-22.708h18.444l-20.059%2023.513%2021.558%2033.66H470.41l-1
		2.91-22.246-7.264%208.183v14.064h-16.484z%22%2F%3E%3C%2Fg%3E%3C%2Fsvg%3E
	EOF
	)

	# JavaScript
	javascript=$(tr -d '\n' <<-'EOF'
		(function(){
		/* This resource is used to check the status of hBlock */
		var c=document.getElementById('status').classList;
		var i=document.createElement('img');c.add('loading');
		i.src='https://hblock-check.molinero.xyz/1.png?_='+Date.now();
		i.onload=function(){c.add('disabled');c.remove('loading');};
		i.onerror=function(){c.add('enabled');c.remove('loading');};
		})();
	EOF
	)

	# CSS
	css=$(tr -d '\n' <<-'EOF'
		html {
			font-family: '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
			font-size: 16px;
			color: #424242;
			background-color: #FAFAFA;
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
			margin: 20px auto;
			width: 100%;
			max-width: 1000px;
		}

		.section {
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

		#status::before {
			display: inline-block;
			content: '';
		}

		#status:not(.loading):before {
			content: 'It was not possible to determine if you are using hBlock.';
			color: #37474F;
		}

		#status.enabled::before {
			content: 'You are using hBlock.';
			color: #388E3C;
		}

		#status.disabled::before {
			content: 'You are currently not using hBlock.';
			color: #D32F2F;
		}
	EOF
	)

	# Page template
	printf -- '%s\n' "$(tr -d '\n' <<-EOF
		<!DOCTYPE html>
		<html lang="en">

		<head>
			<meta charset="utf-8">
			<meta name="viewport" content="width=device-width, initial-scale=1">

			<meta http-equiv="Content-Security-Policy" content="
				default-src 'none';
				 script-src '$(cspDigest "${javascript}")';
				 style-src '$(cspDigest "${css}")';
				 img-src data: https://hblock-check.molinero.xyz/1.png;
			">

			<title>Index of /hBlock</title>
			<meta name="description" content="Improve your security and privacy by blocking ads, tracking and malware domains">
			<meta name="author" content="Héctor Molinero Fernández <hector@molinero.xyz>">
			<meta name="license" content="MIT, https://opensource.org/licenses/MIT">
			<link rel="canonical" href="https://hblock.molinero.xyz/">

			<link rel="icon" type="image/png" href="${favicon}">

			<!-- See: http://ogp.me -->
			<meta property="og:title" content="Index of /hBlock">
			<meta property="og:description" content="Improve your security and privacy by blocking ads, tracking and malware domains">
			<meta property="og:type" content="website">
			<meta property="og:url" content="https://hblock.molinero.xyz/">
			<meta property="og:image" content="https://raw.githubusercontent.com/hectorm/hblock/master/resources/logo/bitmap/favicon-512x512.png">

			<style>${css}</style>
		</head>

		<body>
			<div class="container">
				<div class="section">
					<a title="hBlock project page" href="https://github.com/hectorm/hblock">
						<img src="${logotype}" width="160" height="48" alt="hBlock">
					</a>
					<p>
						hBlock is a POSIX-compliant shell script, designed for Unix-like systems, that gets a list of domains that serve ads, tracking
						 scripts and malware from <a title="hBlock sources" href="https://github.com/hectorm/hblock#sources">multiple sources</a>
						 and creates a <a title="hosts file definition" href="https://en.wikipedia.org/wiki/Hosts_(file)">hosts file</a>
						 (alternative formats are also supported) that prevents your system from connecting to them.
					</p>
					<p>
						On this website you can download the latest build of the default blocklist and you can generate your own by following the
						 instructions on the project page
						 (<a title="hBlock project page" href="https://github.com/hectorm/hblock">github.com/hectorm/hblock</a>).
					</p>
				</div>
				<div class="section">
					<h2 class="title">Status</h2>
					 <span id="status"></span>
				</div>
				<div class="section">
					<h2 class="title">Latest build ($(date '+%Y-%m-%d'))</h2>
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
			</div>
			<script>${javascript}</script>
		</body>

		</html>
	EOF
	)"
}

main "$@"
