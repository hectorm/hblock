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
$_inkscape -w 16  -h 16  -e "$targetDir/favicon-16x16.png"   "$favicon"
$_inkscape -w 24  -h 24  -e "$targetDir/favicon-24x24.png"   "$favicon"
$_inkscape -w 32  -h 32  -e "$targetDir/favicon-32x32.png"   "$favicon"
$_inkscape -w 48  -h 48  -e "$targetDir/favicon-48x48.png"   "$favicon"
$_inkscape -w 72  -h 72  -e "$targetDir/favicon-72x72.png"   "$favicon"
$_inkscape -w 96  -h 96  -e "$targetDir/favicon-96x96.png"   "$favicon"
$_inkscape -w 128 -h 128 -e "$targetDir/favicon-128x128.png" "$favicon"
$_inkscape -w 152 -h 152 -e "$targetDir/favicon-152x152.png" "$favicon"
$_inkscape -w 256 -h 256 -e "$targetDir/favicon-256x256.png" "$favicon"
$_inkscape -w 384 -h 384 -e "$targetDir/favicon-384x384.png" "$favicon"
$_inkscape -w 512 -h 512 -e "$targetDir/favicon-512x512.png" "$favicon"

rm -f "$targetDir"/logotype-a-*x*.png
logotypeA="$scriptDir/logotype-a.svg"
$_inkscape -w 80   -h 24  -e "$targetDir/logotype-a-80x24.png"    "$logotypeA"
$_inkscape -w 160  -h 48  -e "$targetDir/logotype-a-160x48.png"   "$logotypeA"
$_inkscape -w 240  -h 72  -e "$targetDir/logotype-a-240x72.png"   "$logotypeA"
$_inkscape -w 320  -h 96  -e "$targetDir/logotype-a-320x96.png"   "$logotypeA"
$_inkscape -w 400  -h 120 -e "$targetDir/logotype-a-400x120.png"  "$logotypeA"
$_inkscape -w 560  -h 168 -e "$targetDir/logotype-a-560x168.png"  "$logotypeA"
$_inkscape -w 720  -h 216 -e "$targetDir/logotype-a-720x216.png"  "$logotypeA"
$_inkscape -w 880  -h 264 -e "$targetDir/logotype-a-880x264.png"  "$logotypeA"
$_inkscape -w 1040 -h 312 -e "$targetDir/logotype-a-1040x312.png" "$logotypeA"
$_inkscape -w 1200 -h 360 -e "$targetDir/logotype-a-1200x360.png" "$logotypeA"
$_inkscape -w 1360 -h 408 -e "$targetDir/logotype-a-1360x408.png" "$logotypeA"

rm -f "$targetDir"/logotype-b-*x*.png
logotypeB="$scriptDir/logotype-b.svg"
$_inkscape -w 48   -h 48  -e "$targetDir/logotype-b-48x48.png"   "$logotypeB"
$_inkscape -w 72   -h 72  -e "$targetDir/logotype-b-72x72.png"   "$logotypeB"
$_inkscape -w 96   -h 96  -e "$targetDir/logotype-b-96x96.png"   "$logotypeB"
$_inkscape -w 128  -h 128 -e "$targetDir/logotype-b-128x128.png" "$logotypeB"
$_inkscape -w 152  -h 152 -e "$targetDir/logotype-b-152x152.png" "$logotypeB"
$_inkscape -w 256  -h 256 -e "$targetDir/logotype-b-256x256.png" "$logotypeB"
$_inkscape -w 384  -h 384 -e "$targetDir/logotype-b-384x384.png" "$logotypeB"
$_inkscape -w 512  -h 512 -e "$targetDir/logotype-b-512x512.png" "$logotypeB"
$_inkscape -w 640  -h 640 -e "$targetDir/logotype-b-640x640.png" "$logotypeB"
$_inkscape -w 768  -h 768 -e "$targetDir/logotype-b-768x768.png" "$logotypeB"
$_inkscape -w 896  -h 896 -e "$targetDir/logotype-b-896x896.png" "$logotypeB"
