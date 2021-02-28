m4_changequote([[, ]])m4_dnl
{
  "name": "hblock",
  "version": "m4_esyscmd(printf '%s' "${PKG_VERSION?}")",
  "description": "Adblocker that creates a hosts file from multiple sources",
  "keywords": [
    "ad-block",
    "ad-blocker",
    "ads",
    "advertisements",
    "dns",
    "dnsmasq",
    "domains",
    "filter",
    "filter-lists",
    "filterlist",
    "hosts",
    "hostsfile",
    "malware",
    "privacy",
    "security",
    "shell",
    "trackers",
    "tracking",
    "unbound",
    "unified-hosts"
  ],
  "author": "Héctor Molinero Fernández <hector@molinero.dev>",
  "license": "MIT",
  "homepage": "https://hblock.molinero.dev",
  "repository": {
    "type": "git",
    "url": "https://github.com/hectorm/hblock.git"
  },
  "bugs": {
    "url": "https://github.com/hectorm/hblock/issues"
  },
  "files": [
    "hblock",
    "hblock.1"
  ],
  "bin": {
    "hblock": "./hblock"
  },
  "man": [
    "./hblock.1"
  ],
  "os": [
    "!win32"
  ],
  "preferGlobal": true
}
