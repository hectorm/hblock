# hBlock
This shell script, designed for Unix-like systems, generates a [hosts file](http://man7.org/linux/man-pages/man5/hosts.5.html) based on [popular and reputable sources](#sources).

## What is this for?
To prevent your system from connecting to domains that serve ads, tracking scripts and malware. This will increase the security of your system and save bandwidth.

## Nightly builds
I provide pregenerated nightly builds with the default configuration. This builds are created automatically with [GitLab CI](https://gitlab.com/zant95/hblock/pipelines) and are triggered using an [Amazon Lambda function](https://gist.github.com/zant95/b181089dac06205c7fd18190e6ab8e67).
- https://hblock.molinero.xyz
- https://zant95.gitlab.io/hblock (mirror)

## Usage
Run latest version from GitHub:
```sh
curl -sL 'https://raw.githubusercontent.com/zant95/hblock/master/hblock' | sh
```
You can also change the default behavior using these arguments:
```
Usage: hblock [OPTION]...
  -O  Output file
  -R  Redirection IP
  -H  Hosts header
  -S  Hosts sources (space separated entries)
  -W  Whitelist (space separated entries, POSIX basic regex)
  -B  Blacklist (space separated entries)
  -b  Backup (make a time-stamped backup)
  -l  Lenient (select any IP address)
  -y  Automatic 'yes' to prompts
  -n  Automatic 'no' to prompts
  -h  Print this help
```
**Note:** be sure to regularly update the hosts file for new additions or download the script and create a scheduled task.

## Preview
[![asciicast](https://asciinema.org/a/92741.png)](https://asciinema.org/a/92741)

## Is it safe to use?
Absolutely, this script uses regular expressions to select only the domain names of the source files, so if a source file redirects a domain name to a rogue server your system will not be affected.

## What about Windows users?
Unfortunately, this script only works on Unix-like systems, but there is some workarounds by using console emulators like [Cmder](http://cmder.net), that includes the necessary tools to run this script.
Simply use the output argument with the appropriate hosts file location:
```
hblock -O "%SystemRoot%\System32\drivers\etc\hosts"
```

Alternatively, you can use [this project](https://github.com/StevenBlack/hosts) written in Python that has a similar approach or try [Bash on Ubuntu on Windows](https://github.com/Microsoft/BashOnWindows).

## I hear those things are awfully loud...
It glides as softly as a cloud.

## Sources
- http://mirror1.malwaredomains.com/files/immortal_domains.txt
- http://mirror1.malwaredomains.com/files/justdomains
- http://someonewhocares.org/hosts/hosts
- http://winhelp2002.mvps.org/hosts.txt
- https://adaway.org/hosts.txt
- https://isc.sans.edu/feeds/suspiciousdomains_High.txt
- https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&mimetype=plaintext
- https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
- https://www.malwaredomainlist.com/hostslist/hosts.txt
- https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist

## Disclaimer
- **Read the script** to make sure it is what you need.
- This script, by default, replaces the `/etc/hosts` file of your system. I am not responsible for any damage or loss, always make backups.

## License
See the [license](LICENSE) file.

