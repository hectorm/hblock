#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.xyz>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

scriptDir=$(dirname "$(readlink -f "$0")")
targetDir="$scriptDir/bitmap"

_args='--without-gui'
_inkscape="inkscape ${_args}";

rm -f "$targetDir"/favicon-*x*.png
favicon="$scriptDir/favicon.svg"
$_inkscape -h 16  -w 16  -e "$targetDir/favicon-16x16.png"   "$favicon"
$_inkscape -h 24  -w 24  -e "$targetDir/favicon-24x24.png"   "$favicon"
$_inkscape -h 32  -w 32  -e "$targetDir/favicon-32x32.png"   "$favicon"
$_inkscape -h 48  -w 48  -e "$targetDir/favicon-48x48.png"   "$favicon"
$_inkscape -h 72  -w 72  -e "$targetDir/favicon-72x72.png"   "$favicon"
$_inkscape -h 96  -w 96  -e "$targetDir/favicon-96x96.png"   "$favicon"
$_inkscape -h 128 -w 128 -e "$targetDir/favicon-128x128.png" "$favicon"
$_inkscape -h 152 -w 152 -e "$targetDir/favicon-152x152.png" "$favicon"
$_inkscape -h 256 -w 256 -e "$targetDir/favicon-256x256.png" "$favicon"
$_inkscape -h 384 -w 384 -e "$targetDir/favicon-384x384.png" "$favicon"
$_inkscape -h 512 -w 512 -e "$targetDir/favicon-512x512.png" "$favicon"

rm -f "$targetDir"/logotype-*x*.png
logotype="$scriptDir/logotype.svg"
$_inkscape -w 80   -h 24  -e "$targetDir/logotype-80x24.png"    "$logotype"
$_inkscape -w 160  -h 48  -e "$targetDir/logotype-160x48.png"   "$logotype"
$_inkscape -w 240  -h 72  -e "$targetDir/logotype-240x72.png"   "$logotype"
$_inkscape -w 320  -h 96  -e "$targetDir/logotype-320x96.png"   "$logotype"
$_inkscape -w 400  -h 120 -e "$targetDir/logotype-400x120.png"  "$logotype"
$_inkscape -w 560  -h 168 -e "$targetDir/logotype-560x168.png"  "$logotype"
$_inkscape -w 720  -h 216 -e "$targetDir/logotype-720x216.png"  "$logotype"
$_inkscape -w 880  -h 264 -e "$targetDir/logotype-880x264.png"  "$logotype"
$_inkscape -w 1040 -h 312 -e "$targetDir/logotype-1040x312.png" "$logotype"
$_inkscape -w 1200 -h 360 -e "$targetDir/logotype-1200x360.png" "$logotype"
$_inkscape -w 1360 -h 408 -e "$targetDir/logotype-1360x408.png" "$logotype"
