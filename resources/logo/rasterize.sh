#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

SCRIPT_DIR="$(dirname "$(readlink -f "${0:?}")")"

inkscapeArgs='--without-gui'
inkscapeCmd="inkscape ${inkscapeArgs:?}"

favicon="${SCRIPT_DIR:?}/favicon.svg"
rm -f "${SCRIPT_DIR:?}"/bitmap/favicon-*x*.png
${inkscapeCmd:?} -w 16  -h 16  -e "${SCRIPT_DIR:?}"/bitmap/favicon-16x16.png   "${favicon:?}"
${inkscapeCmd:?} -w 24  -h 24  -e "${SCRIPT_DIR:?}"/bitmap/favicon-24x24.png   "${favicon:?}"
${inkscapeCmd:?} -w 32  -h 32  -e "${SCRIPT_DIR:?}"/bitmap/favicon-32x32.png   "${favicon:?}"
${inkscapeCmd:?} -w 48  -h 48  -e "${SCRIPT_DIR:?}"/bitmap/favicon-48x48.png   "${favicon:?}"
${inkscapeCmd:?} -w 72  -h 72  -e "${SCRIPT_DIR:?}"/bitmap/favicon-72x72.png   "${favicon:?}"
${inkscapeCmd:?} -w 96  -h 96  -e "${SCRIPT_DIR:?}"/bitmap/favicon-96x96.png   "${favicon:?}"
${inkscapeCmd:?} -w 128 -h 128 -e "${SCRIPT_DIR:?}"/bitmap/favicon-128x128.png "${favicon:?}"
${inkscapeCmd:?} -w 152 -h 152 -e "${SCRIPT_DIR:?}"/bitmap/favicon-152x152.png "${favicon:?}"
${inkscapeCmd:?} -w 256 -h 256 -e "${SCRIPT_DIR:?}"/bitmap/favicon-256x256.png "${favicon:?}"
${inkscapeCmd:?} -w 384 -h 384 -e "${SCRIPT_DIR:?}"/bitmap/favicon-384x384.png "${favicon:?}"
${inkscapeCmd:?} -w 512 -h 512 -e "${SCRIPT_DIR:?}"/bitmap/favicon-512x512.png "${favicon:?}"

logotype="${SCRIPT_DIR:?}/logotype.svg"
rm -f "${SCRIPT_DIR:?}"/bitmap/logotype-*x*.png
${inkscapeCmd:?} -w 80   -h 25  -e "${SCRIPT_DIR:?}"/bitmap/logotype-80x25.png    "${logotype:?}"
${inkscapeCmd:?} -w 160  -h 50  -e "${SCRIPT_DIR:?}"/bitmap/logotype-160x50.png   "${logotype:?}"
${inkscapeCmd:?} -w 240  -h 75  -e "${SCRIPT_DIR:?}"/bitmap/logotype-240x75.png   "${logotype:?}"
${inkscapeCmd:?} -w 320  -h 100 -e "${SCRIPT_DIR:?}"/bitmap/logotype-320x100.png  "${logotype:?}"
${inkscapeCmd:?} -w 400  -h 125 -e "${SCRIPT_DIR:?}"/bitmap/logotype-400x125.png  "${logotype:?}"
${inkscapeCmd:?} -w 560  -h 175 -e "${SCRIPT_DIR:?}"/bitmap/logotype-560x175.png  "${logotype:?}"
${inkscapeCmd:?} -w 720  -h 225 -e "${SCRIPT_DIR:?}"/bitmap/logotype-720x225.png  "${logotype:?}"
${inkscapeCmd:?} -w 880  -h 275 -e "${SCRIPT_DIR:?}"/bitmap/logotype-880x275.png  "${logotype:?}"
${inkscapeCmd:?} -w 1040 -h 325 -e "${SCRIPT_DIR:?}"/bitmap/logotype-1040x325.png "${logotype:?}"
${inkscapeCmd:?} -w 1200 -h 375 -e "${SCRIPT_DIR:?}"/bitmap/logotype-1200x375.png "${logotype:?}"
${inkscapeCmd:?} -w 1360 -h 425 -e "${SCRIPT_DIR:?}"/bitmap/logotype-1360x425.png "${logotype:?}"

logotypeAlt="${SCRIPT_DIR:?}/logotype-alt.svg"
rm -f "${SCRIPT_DIR:?}"/bitmap/logotype-alt-*x*.png
${inkscapeCmd:?} -w 48   -h 36  -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-48x36.png   "${logotypeAlt:?}"
${inkscapeCmd:?} -w 72   -h 54  -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-72x54.png   "${logotypeAlt:?}"
${inkscapeCmd:?} -w 96   -h 72  -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-96x72.png   "${logotypeAlt:?}"
${inkscapeCmd:?} -w 128  -h 96  -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-128x96.png  "${logotypeAlt:?}"
${inkscapeCmd:?} -w 152  -h 114 -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-152x114.png "${logotypeAlt:?}"
${inkscapeCmd:?} -w 256  -h 192 -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-256x192.png "${logotypeAlt:?}"
${inkscapeCmd:?} -w 384  -h 288 -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-384x288.png "${logotypeAlt:?}"
${inkscapeCmd:?} -w 512  -h 384 -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-512x384.png "${logotypeAlt:?}"
${inkscapeCmd:?} -w 640  -h 480 -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-640x480.png "${logotypeAlt:?}"
${inkscapeCmd:?} -w 768  -h 576 -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-768x576.png "${logotypeAlt:?}"
${inkscapeCmd:?} -w 896  -h 672 -e "${SCRIPT_DIR:?}"/bitmap/logotype-alt-896x672.png "${logotypeAlt:?}"
