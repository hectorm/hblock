# hosts-update
This bash script, designed for GNU/Linux, generates a hosts file based on multiple sources.
- http://adaway.org/hosts.txt
- http://hosts-file.net/ad_servers.txt
- http://malwaredomains.lehigh.edu/files/justdomains
- http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&mimetype=plaintext
- http://someonewhocares.org/hosts/hosts
- https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_malware.txt
- https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
- http://winhelp2002.mvps.org/hosts.txt
- http://www.malwaredomainlist.com/hostslist/hosts.txt

## What is this for?
To prevent your computer from connecting to domains who serve ads and malware.
This will increase the security of your computer and save bandwidth.

## Usage
Simply type in your terminal:
```bash
curl -sL 'https://git.io/hosts-update' | bash
```
Yes to all:
```bash
yes | ./hosts-update
```

**Note:** be sure to regularly update the hosts file for new additions or download the script and create a scheduled task.

## Preview
![Preview](preview.png)

## Disclaimer
- **Read the script** to make sure it is what you need.
- This script, by default, replaces the "/etc/hosts" file of your system. I am not responsible for any damage or loss, always make backups.

## License
See the [license](LICENSE) file.

