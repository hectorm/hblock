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
* [Usage](#usage)
  * [Run latest version](#run-latest-version)
  * [Local installation](#local-installation)
  * [Script arguments](#script-arguments)
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

## Usage

#### Run without installation
```sh
curl 'https://raw.githubusercontent.com/zant95/hblock/master/hblock' -o /tmp/hblock && \
  echo '42a822463ea52238e4730374ac4c0f4d530724469c172c93ceca949d5e1ee9d8  /tmp/hblock' | shasum -c && \
  sh /tmp/hblock
```

#### Installation
```sh
curl 'https://raw.githubusercontent.com/zant95/hblock/master/hblock' -o /tmp/hblock && \
  echo '42a822463ea52238e4730374ac4c0f4d530724469c172c93ceca949d5e1ee9d8  /tmp/hblock' | shasum -c && \
  sudo mv /tmp/hblock /usr/local/bin/hblock && sudo chmod a+rx /usr/local/bin/hblock
```

**Note:** be sure to regularly update the hosts file for new additions or download the script and create a scheduled task.

#### Script arguments
You can also change the default behavior using these options:
```
Usage: hblock [options...]
 -O, --output FILE            Output file (default: /etc/hosts)
 -R, --redirection IP         Domain redirection IP (default: 0.0.0.0)
 -H, --header STRING          File header (default: see source code)
 -S, --sources STRING         Space separated URLs (default: see source code)
 -W, --whitelist STRING       Space separated entries, POSIX basic regex (default: see source code)
 -B, --blacklist STRING       Space separated entries (default: see source code)
 -b, --backup                 Make a time-stamped backup (default: disabled)
 -l, --lenient                Select any IP address from sources (default: 0.0.0.0, 127.0.0.1 or none)
 -i, --ignore-download-error  Do not abort on download error (default: disabled)
 -h, --help                   Print this help
```

#### Run preview
[![asciicast](https://asciinema.org/a/95561.png)](https://asciinema.org/a/95561)

## Sources
| Name                                  | Primary                                          | Mirror                                           |
| ------------------------------------- | :----------------------------------------------: | :----------------------------------------------: |
| adaway.org                            | [URL][source-adaway.org]                         | [URL][mirror-adaway.org]                         |
| disconnect.me - Ad                    | [URL][source-disconnect.me-ad]                   | [URL][mirror-disconnect.me-ad]                   |
| disconnect.me - Malvertising          | [URL][source-disconnect.me-malvertising]         | [URL][mirror-disconnect.me-malvertising]         |
| disconnect.me - Malware               | [URL][source-disconnect.me-malware]              | [URL][mirror-disconnect.me-malware]              |
| disconnect.me - Tracking              | [URL][source-disconnect.me-tracking]             | [URL][mirror-disconnect.me-tracking]             |
| FadeMind - add.2o7Net                 | [URL][source-fademind-add.2o7net]                | [URL][mirror-fademind-add.2o7net]                |
| FadeMind - add.Dead                   | [URL][source-fademind-add.dead]                  | [URL][mirror-fademind-add.dead]                  |
| FadeMind - add.Risk                   | [URL][source-fademind-add.risk]                  | [URL][mirror-fademind-add.risk]                  |
| FadeMind - add.Spam                   | [URL][source-fademind-add.spam]                  | [URL][mirror-fademind-add.spam]                  |
| KADhosts                              | [URL][source-kadhosts]                           | [URL][mirror-kadhosts]                           |
| malwaredomainlist.com                 | [URL][source-malwaredomainlist.com]              | [URL][mirror-malwaredomainlist.com]              |
| malwaredomains.com - Immortal domains | [URL][source-malwaredomains.com-immortaldomains] | [URL][mirror-malwaredomains.com-immortaldomains] |
| malwaredomains.com - Just domains     | [URL][source-malwaredomains.com-justdomains]     | [URL][mirror-malwaredomains.com-justdomains]     |
| pgl.yoyo.org                          | [URL][source-pgl.yoyo.org]                       | [URL][mirror-pgl.yoyo.org]                       |
| ransomwaretracker.abuse.ch            | [URL][source-ransomwaretracker.abuse.ch]         | [URL][mirror-ransomwaretracker.abuse.ch]         |
| someonewhocares.org                   | [URL][source-someonewhocares.org]                | [URL][mirror-someonewhocares.org]                |
| spam404.com                           | [URL][source-spam404.com]                        | [URL][mirror-spam404.com]                        |
| winhelp2002.mvps.org                  | [URL][source-winhelp2002.mvps.org]               | [URL][mirror-winhelp2002.mvps.org]               |
| zeustracker.abuse.ch                  | [URL][source-zeustracker.abuse.ch]               | [URL][mirror-zeustracker.abuse.ch]               |

[source-adaway.org]: https://adaway.org/hosts.txt
[mirror-adaway.org]: https://raw.githubusercontent.com/zant95/hmirror/master/data/adaway.org/list.txt
[source-disconnect.me-ad]: https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
[mirror-disconnect.me-ad]: https://raw.githubusercontent.com/zant95/hmirror/master/data/disconnect.me-ad/list.txt
[source-disconnect.me-malvertising]: https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
[mirror-disconnect.me-malvertising]: https://raw.githubusercontent.com/zant95/hmirror/master/data/disconnect.me-malvertising/list.txt
[source-disconnect.me-malware]: https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt
[mirror-disconnect.me-malware]: https://raw.githubusercontent.com/zant95/hmirror/master/data/disconnect.me-malware/list.txt
[source-disconnect.me-tracking]: https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
[mirror-disconnect.me-tracking]: https://raw.githubusercontent.com/zant95/hmirror/master/data/disconnect.me-tracking/list.txt
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
[source-pgl.yoyo.org]: https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&mimetype=plaintext
[mirror-pgl.yoyo.org]: https://raw.githubusercontent.com/zant95/hmirror/master/data/pgl.yoyo.org/list.txt
[source-ransomwaretracker.abuse.ch]: https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt
[mirror-ransomwaretracker.abuse.ch]: https://raw.githubusercontent.com/zant95/hmirror/master/data/ransomwaretracker.abuse.ch/list.txt
[source-someonewhocares.org]: http://someonewhocares.org/hosts/hosts
[mirror-someonewhocares.org]: https://raw.githubusercontent.com/zant95/hmirror/master/data/someonewhocares.org/list.txt
[source-spam404.com]: https://raw.githubusercontent.com/Dawsey21/Lists/master/main-blacklist.txt
[mirror-spam404.com]: https://raw.githubusercontent.com/zant95/hmirror/master/data/spam404.com/list.txt
[source-winhelp2002.mvps.org]: http://winhelp2002.mvps.org/hosts.txt
[mirror-winhelp2002.mvps.org]: https://raw.githubusercontent.com/zant95/hmirror/master/data/winhelp2002.mvps.org/list.txt
[source-zeustracker.abuse.ch]: https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist
[mirror-zeustracker.abuse.ch]: https://raw.githubusercontent.com/zant95/hmirror/master/data/zeustracker.abuse.ch/list.txt

## Disclaimer
This script, by default, replaces the `/etc/hosts` file of your system. I am not responsible for any damage or loss, always make backups.

## License
See the [license](LICENSE.md) file.

