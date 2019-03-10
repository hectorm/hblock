#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# Repository: https://github.com/hectorm/hblock
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

workDir=./resources/logo/
targetDir=$workDir/bitmap/

_args='--without-gui'
_inkscape="inkscape ${_args}";

rm -f "$targetDir"/favicon-*x*.png
favicon="$workDir"/favicon.svg
$_inkscape -w 16  -h 16  -e "$targetDir"/favicon-16x16.png   "$favicon"
$_inkscape -w 24  -h 24  -e "$targetDir"/favicon-24x24.png   "$favicon"
$_inkscape -w 32  -h 32  -e "$targetDir"/favicon-32x32.png   "$favicon"
$_inkscape -w 48  -h 48  -e "$targetDir"/favicon-48x48.png   "$favicon"
$_inkscape -w 72  -h 72  -e "$targetDir"/favicon-72x72.png   "$favicon"
$_inkscape -w 96  -h 96  -e "$targetDir"/favicon-96x96.png   "$favicon"
$_inkscape -w 128 -h 128 -e "$targetDir"/favicon-128x128.png "$favicon"
$_inkscape -w 152 -h 152 -e "$targetDir"/favicon-152x152.png "$favicon"
$_inkscape -w 256 -h 256 -e "$targetDir"/favicon-256x256.png "$favicon"
$_inkscape -w 384 -h 384 -e "$targetDir"/favicon-384x384.png "$favicon"
$_inkscape -w 512 -h 512 -e "$targetDir"/favicon-512x512.png "$favicon"

rm -f "$targetDir"/logotype-*x*.png
logotypeA="$workDir"/logotype.svg
$_inkscape -w 80   -h 25  -e "$targetDir"/logotype-80x25.png    "$logotypeA"
$_inkscape -w 160  -h 50  -e "$targetDir"/logotype-160x50.png   "$logotypeA"
$_inkscape -w 240  -h 75  -e "$targetDir"/logotype-240x75.png   "$logotypeA"
$_inkscape -w 320  -h 100 -e "$targetDir"/logotype-320x100.png  "$logotypeA"
$_inkscape -w 400  -h 125 -e "$targetDir"/logotype-400x125.png  "$logotypeA"
$_inkscape -w 560  -h 175 -e "$targetDir"/logotype-560x175.png  "$logotypeA"
$_inkscape -w 720  -h 225 -e "$targetDir"/logotype-720x225.png  "$logotypeA"
$_inkscape -w 880  -h 275 -e "$targetDir"/logotype-880x275.png  "$logotypeA"
$_inkscape -w 1040 -h 325 -e "$targetDir"/logotype-1040x325.png "$logotypeA"
$_inkscape -w 1200 -h 375 -e "$targetDir"/logotype-1200x375.png "$logotypeA"
$_inkscape -w 1360 -h 425 -e "$targetDir"/logotype-1360x425.png "$logotypeA"

rm -f "$targetDir"/logotype-alt-*x*.png
logotypeB="$workDir"/logotype-alt.svg
$_inkscape -w 48   -h 36  -e "$targetDir"/logotype-alt-48x36.png   "$logotypeB"
$_inkscape -w 72   -h 54  -e "$targetDir"/logotype-alt-72x54.png   "$logotypeB"
$_inkscape -w 96   -h 72  -e "$targetDir"/logotype-alt-96x72.png   "$logotypeB"
$_inkscape -w 128  -h 96  -e "$targetDir"/logotype-alt-128x96.png  "$logotypeB"
$_inkscape -w 152  -h 114 -e "$targetDir"/logotype-alt-152x114.png "$logotypeB"
$_inkscape -w 256  -h 192 -e "$targetDir"/logotype-alt-256x192.png "$logotypeB"
$_inkscape -w 384  -h 288 -e "$targetDir"/logotype-alt-384x288.png "$logotypeB"
$_inkscape -w 512  -h 384 -e "$targetDir"/logotype-alt-512x384.png "$logotypeB"
$_inkscape -w 640  -h 480 -e "$targetDir"/logotype-alt-640x480.png "$logotypeB"
$_inkscape -w 768  -h 576 -e "$targetDir"/logotype-alt-768x576.png "$logotypeB"
$_inkscape -w 896  -h 672 -e "$targetDir"/logotype-alt-896x672.png "$logotypeB"
