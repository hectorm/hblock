# hBlock
This POSIX-compliant shell script, designed for Unix-like systems, generates a [hosts file](http://man7.org/linux/man-pages/man5/hosts.5.html) based on [popular and reputable sources](#sources).
I also provide [nightly builds](#nightly-builds) of the hosts file and installers for Windows (batch file installer) and Android (flashable zip).

## What is this for?
To prevent your system from connecting to domains that serve ads, tracking scripts and malware. This will increase the security of your system and save bandwidth.

## Usage
Run latest version from GitHub:
```sh
curl -fsS 'https://raw.githubusercontent.com/zant95/hblock/master/hblock' | sh
```
Local install:
```sh
sudo curl -fsS 'https://raw.githubusercontent.com/zant95/hblock/master/hblock' -o /usr/local/bin/hblock
sudo chmod a+rx /usr/local/bin/hblock
```
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
**Note:** be sure to regularly update the hosts file for new additions or download the script and create a scheduled task.

## Preview
[![asciicast](https://asciinema.org/a/95561.png)](https://asciinema.org/a/95561)

## Is it safe to use?
Absolutely, this script uses regular expressions to select only the domain names of the source files, so if a source file redirects a domain name to a rogue server your system will not be affected.

## What about Windows users?
Unfortunately, this script only works on Unix-like systems, but there is some workarounds by using console emulators like [Cmder](http://cmder.net), that includes the necessary tools to run this script.
Simply use the output argument with the appropriate hosts file location:
```
hblock -O "%SystemRoot%\System32\drivers\etc\hosts"
```

Alternatively, you can use [this project](https://github.com/StevenBlack/hosts) written in Python that has a similar approach or try [Bash on Ubuntu on Windows](https://github.com/Microsoft/BashOnWindows).

## Nightly builds
These builds are created automatically using [GitLab CI](https://gitlab.com/zant95/hblock/pipelines) and are triggered with an [Amazon Lambda function](https://gist.github.com/zant95/b181089dac06205c7fd18190e6ab8e67).
- https://hblock.molinero.xyz
- https://zant95.gitlab.io/hblock (mirror)

## Sources
| Name                                  |                                                     |                                                     |
| ------------------------------------- | :-------------------------------------------------: | :-------------------------------------------------: |
| adaway.org                            | [source][source-adaway.org]                         | [mirror][mirror-adaway.org]                         |
| disconnect.me - Ad                    | [source][source-disconnect.me-ad]                   | [mirror][mirror-disconnect.me-ad]                   |
| disconnect.me - Malvertising          | [source][source-disconnect.me-malvertising]         | [mirror][mirror-disconnect.me-malvertising]         |
| disconnect.me - Malware               | [source][source-disconnect.me-malware]              | [mirror][mirror-disconnect.me-malware]              |
| disconnect.me - Tracking              | [source][source-disconnect.me-tracking]             | [mirror][mirror-disconnect.me-tracking]             |
| FadeMind - add.2o7Net                 | [source][source-fademind-add.2o7net]                | [mirror][mirror-fademind-add.2o7net]                |
| FadeMind - add.Dead                   | [source][source-fademind-add.dead]                  | [mirror][mirror-fademind-add.dead]                  |
| FadeMind - add.Risk                   | [source][source-fademind-add.risk]                  | [mirror][mirror-fademind-add.risk]                  |
| FadeMind - add.Spam                   | [source][source-fademind-add.spam]                  | [mirror][mirror-fademind-add.spam]                  |
| KADhosts                              | [source][source-kadhosts]                           | [mirror][mirror-kadhosts]                           |
| malwaredomainlist.com                 | [source][source-malwaredomainlist.com]              | [mirror][mirror-malwaredomainlist.com]              |
| malwaredomains.com - Immortal domains | [source][source-malwaredomains.com-immortaldomains] | [mirror][mirror-malwaredomains.com-immortaldomains] |
| malwaredomains.com - Just domains     | [source][source-malwaredomains.com-justdomains]     | [mirror][mirror-malwaredomains.com-justdomains]     |
| pgl.yoyo.org                          | [source][source-pgl.yoyo.org]                       | [mirror][mirror-pgl.yoyo.org]                       |
| ransomwaretracker.abuse.ch            | [source][source-ransomwaretracker.abuse.ch]         | [mirror][mirror-ransomwaretracker.abuse.ch]         |
| someonewhocares.org                   | [source][source-someonewhocares.org]                | [mirror][mirror-someonewhocares.org]                |
| spam404.com                           | [source][source-spam404.com]                        | [mirror][mirror-spam404.com]                        |
| winhelp2002.mvps.org                  | [source][source-winhelp2002.mvps.org]               | [mirror][mirror-winhelp2002.mvps.org]               |
| zeustracker.abuse.ch                  | [source][source-zeustracker.abuse.ch]               | [mirror][mirror-zeustracker.abuse.ch]               |

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
- **Read the script** to make sure it is what you need.
- This script, by default, replaces the `/etc/hosts` file of your system. I am not responsible for any damage or loss, always make backups.

## I hear those things are awfully loud...
It glides as softly as a cloud.

## License
See the [license](LICENSE) file.

