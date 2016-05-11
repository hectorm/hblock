# hBlock
This shell script, designed for GNU/Linux, generates a hosts file based on multiple sources.
- http://someonewhocares.org/hosts/hosts
- http://winhelp2002.mvps.org/hosts.txt
- https://adaway.org/hosts.txt
- https://isc.sans.edu/feeds/suspiciousdomains_High.txt
- https://mirror.cedia.org.ec/malwaredomains/justdomains
- https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&mimetype=plaintext
- https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt
- https://raw.githubusercontent.com/zant95/hosts/master/hosts
- https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
- https://www.malwaredomainlist.com/hostslist/hosts.txt
- https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist

## What is this for?
To prevent your computer from connecting to domains who serve ads and malware.
This will increase the security of your computer and save bandwidth.

## Usage
```
Usage: hblock [OPTION]...
 -O    Output file
 -R    Redirection IP
 -H    Hosts header
 -S    Hosts sources (space separated entries)
 -W    Whitelist (space separated entries, POSIX basic regex)
 -B    Blacklist (space separated entries)
 -y    Automatic "yes" to prompts
 -n    Automatic "no" to prompts
 -h    Print this help
```
Run latest version from GitHub:
```sh
curl -sL 'https://git.io/hblock' | sh
```
Create an Android flashable zip in your home folder:
```sh
curl -sL 'https://git.io/hblock-android' | sh
```

**Note:** be sure to regularly update the hosts file for new additions or download the script and create a scheduled task.

## Preview
![Preview](preview.png)

## Disclaimer
- **Read the script** to make sure it is what you need.
- This script, by default, replaces the "/etc/hosts" file of your system. I am not responsible for any damage or loss, always make backups.

## License
See the [license](LICENSE) file.

