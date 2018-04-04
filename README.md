[![Build](https://gitlab.com/zant95/hblock/badges/master/build.svg)](https://gitlab.com/zant95/hblock/pipelines)
[![Website](https://img.shields.io/website/https/hblock.molinero.xyz.svg)](https://hblock.molinero.xyz)
[![License](https://img.shields.io/github/license/zant95/hblock.svg)](LICENSE.md)

***

# hBlock
Improve your security and privacy by blocking ads, tracking and malware domains.

## Table of contents
* [What is this for?](#what-is-this-for)
* [Is it safe to use?](#is-it-safe-to-use)
* [Nightly builds](#nightly-builds)
* [Installation](#installation)
* [Usage](#usage)
  * [Script arguments](#script-arguments)
  * [Preserve content](#preserve-content)
  * [Run preview](#run-preview)
* [Sources](#sources)
* [Disclaimer](#disclaimer)
* [License](#license)

## What is this for?
This POSIX-compliant shell script, designed for Unix-like systems, gets a list of domains that serve ads, tracking scripts and malware from
multiple [reputable sources](#sources) and creates a [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)) that prevents your system from
connecting to them.

## Is it safe to use?
Absolutely, this script selects only the domain names for each source, so if a domain name is redirected to a rogue server your system will not be
affected. In the worst scenario you can lose access to a legitimate domain name due a false positive, but you can reverse it by adding that domain to
the whitelist.

## Nightly builds
I provide nightly builds of the hosts file and installers for **Windows** (batch file installer) and **Android** (flashable zip).

| URL                         |
| --------------------------- |
| https://hblock.molinero.xyz |

## Installation

```sh
curl -o /tmp/hblock 'https://raw.githubusercontent.com/zant95/hblock/v1.3.0/hblock' \
  && echo 'd13f328e6d40e06d4657dc33f72b2f501c31bb65018282623a02dd00c11a0839  /tmp/hblock' | shasum -c \
  && sudo mv /tmp/hblock /usr/local/bin/hblock \
  && sudo chown root:root /usr/local/bin/hblock \
  && sudo chmod 755 /usr/local/bin/hblock
```

**Note:** you can use [this Systemd timer](resources/systemd/README.md) to regularly update the hosts file for new additions.

#### Optionally, it is possible to use [NPX](https://www.npmjs.com/package/npx) to run hBlock without installation
```sh
npx hblock
```

## Usage

#### Script arguments
You can also change the default behavior using these options:
```
Usage: hblock [options...]
 -O, --output FILE            Hosts file location (default: /etc/hosts)
 -R, --redirection IP         Destination IP for all entries in the blocklist
                              (default: 0.0.0.0)
 -H, --header HEADER          Content to be included at the beginning of the
                              hosts file. You can use the output of any other
                              command (e.g. "$(cat header.txt)")
 -S, --sources URLS           Sources to be used to generate the blocklist
                              (whitespace separated URLs)
 -W, --whitelist ENTRIES      Entries to be removed from the blocklist
                              (whitespace separated POSIX BREs)
 -B, --blacklist ENTRIES      Entries to be added to the blocklist
                              (whitespace separated domain names)
 -b, --backup [DIRECTORY]     Make a time-stamped backup in DIRECTORY
                              (default: output file directory)
 -l, --lenient                Match any IP address from sources, although it
                              will be replaced by the destination IP
                              (default: 0.0.0.0, 127.0.0.1 or none)
 -i, --ignore-download-error  Do not abort if a download error occurs
 -v, --version                Show version number and quit
 -h, --help                   Show this help and quit
```

#### Preserve content
This script replaces the hosts file of your system, if you want to preserve part of its content, you should wrap that content with the following
structure:
```
# <custom>
...
# </custom>
```

#### Run preview
[![asciicast](https://asciinema.org/a/149165.png)](https://asciinema.org/a/149165)

## Sources
| Name                                  | Primary                                          | Mirror                                           |
| ------------------------------------- | :----------------------------------------------: | :----------------------------------------------: |
| adaway.org                            | [URL][source-adaway.org]                         | [URL][mirror-adaway.org]                         |
| AdBlock NoCoin List                   | [URL][source-adblock-nocoin-list]                | [URL][mirror-adblock-nocoin-list]                |
| AdGuard - Simplified                  | [URL][source-adguard-simplified]                 | [URL][mirror-adguard-simplified]                 |
| disconnect.me - Ad                    | [URL][source-disconnect.me-ad]                   | [URL][mirror-disconnect.me-ad]                   |
| disconnect.me - Malvertising          | [URL][source-disconnect.me-malvertising]         | [URL][mirror-disconnect.me-malvertising]         |
| disconnect.me - Malware               | [URL][source-disconnect.me-malware]              | [URL][mirror-disconnect.me-malware]              |
| disconnect.me - Tracking              | [URL][source-disconnect.me-tracking]             | [URL][mirror-disconnect.me-tracking]             |
| ETH Phishing Detect                   | [URL][source-eth-phishing-detect]                | [URL][mirror-eth-phishing-detect]                |
| FadeMind - add.2o7Net                 | [URL][source-fademind-add.2o7net]                | [URL][mirror-fademind-add.2o7net]                |
| FadeMind - add.Dead                   | [URL][source-fademind-add.dead]                  | [URL][mirror-fademind-add.dead]                  |
| FadeMind - add.Risk                   | [URL][source-fademind-add.risk]                  | [URL][mirror-fademind-add.risk]                  |
| FadeMind - add.Spam                   | [URL][source-fademind-add.spam]                  | [URL][mirror-fademind-add.spam]                  |
| KADhosts                              | [URL][source-kadhosts]                           | [URL][mirror-kadhosts]                           |
| malwaredomainlist.com                 | [URL][source-malwaredomainlist.com]              | [URL][mirror-malwaredomainlist.com]              |
| malwaredomains.com - Immortal domains | [URL][source-malwaredomains.com-immortaldomains] | [URL][mirror-malwaredomains.com-immortaldomains] |
| malwaredomains.com - Just domains     | [URL][source-malwaredomains.com-justdomains]     | [URL][mirror-malwaredomains.com-justdomains]     |
| matomo.org - Spammers                 | [URL][source-matomo.org-spammers]                | [URL][mirror-matomo.org-spammers]                |
| mitchellkrogza - Badd-Boyz-Hosts      | [URL][source-mitchellkrogza-badd-boyz-hosts]     | [URL][mirror-mitchellkrogza-badd-boyz-hosts]     |
| pgl.yoyo.org                          | [URL][source-pgl.yoyo.org]                       | [URL][mirror-pgl.yoyo.org]                       |
| ransomwaretracker.abuse.ch            | [URL][source-ransomwaretracker.abuse.ch]         | [URL][mirror-ransomwaretracker.abuse.ch]         |
| someonewhocares.org                   | [URL][source-someonewhocares.org]                | [URL][mirror-someonewhocares.org]                |
| spam404.com                           | [URL][source-spam404.com]                        | [URL][mirror-spam404.com]                        |
| StevenBlack                           | [URL][source-stevenblack]                        | [URL][mirror-stevenblack]                        |
| winhelp2002.mvps.org                  | [URL][source-winhelp2002.mvps.org]               | [URL][mirror-winhelp2002.mvps.org]               |
| ZeroDot1 - CoinBlockerLists           | [URL][source-zerodot1-coinblockerlists-browser]  | [URL][mirror-zerodot1-coinblockerlists-browser]  |
| zeustracker.abuse.ch                  | [URL][source-zeustracker.abuse.ch]               | [URL][mirror-zeustracker.abuse.ch]               |

[source-adaway.org]: https://adaway.org/hosts.txt
[mirror-adaway.org]: https://raw.githubusercontent.com/zant95/hmirror/master/data/adaway.org/list.txt
[source-adblock-nocoin-list]: https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/hosts.txt
[mirror-adblock-nocoin-list]: https://raw.githubusercontent.com/zant95/hmirror/master/data/adblock-nocoin-list/list.txt
[source-adguard-simplified]: https://filters.adtidy.org/extension/chromium/filters/15.txt
[mirror-adguard-simplified]: https://raw.githubusercontent.com/zant95/hmirror/master/data/adguard-simplified/list.txt
[source-disconnect.me-ad]: https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
[mirror-disconnect.me-ad]: https://raw.githubusercontent.com/zant95/hmirror/master/data/disconnect.me-ad/list.txt
[source-disconnect.me-malvertising]: https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
[mirror-disconnect.me-malvertising]: https://raw.githubusercontent.com/zant95/hmirror/master/data/disconnect.me-malvertising/list.txt
[source-disconnect.me-malware]: https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt
[mirror-disconnect.me-malware]: https://raw.githubusercontent.com/zant95/hmirror/master/data/disconnect.me-malware/list.txt
[source-disconnect.me-tracking]: https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
[mirror-disconnect.me-tracking]: https://raw.githubusercontent.com/zant95/hmirror/master/data/disconnect.me-tracking/list.txt
[source-eth-phishing-detect]: https://raw.githubusercontent.com/MetaMask/eth-phishing-detect/master/src/hosts.txt
[mirror-eth-phishing-detect]: https://raw.githubusercontent.com/zant95/hmirror/master/data/eth-phishing-detect/list.txt
[source-fademind-add.2o7net]: https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts
[mirror-fademind-add.2o7net]: https://raw.githubusercontent.com/zant95/hmirror/master/data/fademind-add.2o7net/list.txt
[source-fademind-add.dead]: https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Dead/hosts
[mirror-fademind-add.dead]: https://raw.githubusercontent.com/zant95/hmirror/master/data/fademind-add.dead/list.txt
[source-fademind-add.risk]: https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts
[mirror-fademind-add.risk]: https://raw.githubusercontent.com/zant95/hmirror/master/data/fademind-add.risk/list.txt
[source-fademind-add.spam]: https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts
[mirror-fademind-add.spam]: https://raw.githubusercontent.com/zant95/hmirror/master/data/fademind-add.spam/list.txt
[source-kadhosts]: https://raw.githubusercontent.com/azet12/KADhosts/master/KADhosts.txt
[mirror-kadhosts]: https://raw.githubusercontent.com/zant95/hmirror/master/data/kadhosts/list.txt
[source-malwaredomainlist.com]: https://www.malwaredomainlist.com/hostslist/hosts.txt
[mirror-malwaredomainlist.com]: https://raw.githubusercontent.com/zant95/hmirror/master/data/malwaredomainlist.com/list.txt
[source-malwaredomains.com-immortaldomains]: http://mirror1.malwaredomains.com/files/immortal_domains.txt
[mirror-malwaredomains.com-immortaldomains]: https://raw.githubusercontent.com/zant95/hmirror/master/data/malwaredomains.com-immortaldomains/list.txt
[source-malwaredomains.com-justdomains]: http://mirror1.malwaredomains.com/files/justdomains
[mirror-malwaredomains.com-justdomains]: https://raw.githubusercontent.com/zant95/hmirror/master/data/malwaredomains.com-justdomains/list.txt
[source-matomo.org-spammers]: https://raw.githubusercontent.com/matomo-org/referrer-spam-blacklist/master/spammers.txt
[mirror-matomo.org-spammers]: https://raw.githubusercontent.com/zant95/hmirror/master/data/matomo.org-spammers/list.txt
[source-mitchellkrogza-badd-boyz-hosts]: https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts
[mirror-mitchellkrogza-badd-boyz-hosts]: https://raw.githubusercontent.com/zant95/hmirror/master/data/mitchellkrogza-badd-boyz-hosts/list.txt
[source-pgl.yoyo.org]: https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&mimetype=plaintext
[mirror-pgl.yoyo.org]: https://raw.githubusercontent.com/zant95/hmirror/master/data/pgl.yoyo.org/list.txt
[source-ransomwaretracker.abuse.ch]: https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt
[mirror-ransomwaretracker.abuse.ch]: https://raw.githubusercontent.com/zant95/hmirror/master/data/ransomwaretracker.abuse.ch/list.txt
[source-someonewhocares.org]: http://someonewhocares.org/hosts/hosts
[mirror-someonewhocares.org]: https://raw.githubusercontent.com/zant95/hmirror/master/data/someonewhocares.org/list.txt
[source-spam404.com]: https://raw.githubusercontent.com/Dawsey21/Lists/master/main-blacklist.txt
[mirror-spam404.com]: https://raw.githubusercontent.com/zant95/hmirror/master/data/spam404.com/list.txt
[source-stevenblack]: https://raw.githubusercontent.com/StevenBlack/hosts/master/data/StevenBlack/hosts
[mirror-stevenblack]: https://raw.githubusercontent.com/zant95/hmirror/master/data/stevenblack/list.txt
[source-winhelp2002.mvps.org]: http://winhelp2002.mvps.org/hosts.txt
[mirror-winhelp2002.mvps.org]: https://raw.githubusercontent.com/zant95/hmirror/master/data/winhelp2002.mvps.org/list.txt
[source-zerodot1-coinblockerlists-browser]: https://raw.githubusercontent.com/ZeroDot1/CoinBlockerLists/master/hosts_browser
[mirror-zerodot1-coinblockerlists-browser]: https://raw.githubusercontent.com/zant95/hmirror/master/data/zerodot1-coinblockerlists-browser/list.txt
[source-zeustracker.abuse.ch]: https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist
[mirror-zeustracker.abuse.ch]: https://raw.githubusercontent.com/zant95/hmirror/master/data/zeustracker.abuse.ch/list.txt

## Disclaimer
This script, by default, replaces the `/etc/hosts` file of your system. I am not responsible for any damage or loss, always make backups.

## License
See the [license](LICENSE.md) file.
