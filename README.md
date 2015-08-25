# hosts-update
This script, designed for GNU/Linux, generates a hosts file based on multiple sources.

- http://adaway.org/hosts.txt
- http://hosts-file.net/ad_servers.txt
- http://malwaredomains.lehigh.edu/files/justdomains
- http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&mimetype=plaintext
- http://someonewhocares.org/hosts/hosts
- http://winhelp2002.mvps.org/hosts.txt
- http://www.malwaredomainlist.com/hostslist/hosts.txt

## What is this for?
To prevent your computer from connecting to domains who serve ads and malware.  
This will increase the security of your computer and save bandwidth.

## Usage
Simply type in your terminal:

	wget -qO- https://raw.githubusercontent.com/zant95/hosts-update/master/hosts-update | bash

**Note:** be sure to regularly update the hosts file for new additions or download the script and create a scheduled task.

## Preview
![Preview](https://raw.githubusercontent.com/zant95/hosts-update/master/preview.png)

## Disclaimer
- **Read the script** to make sure it is what you need.
- This script, by default, replaces the "/etc/hosts" file of your system. I am not responsible for any damage or loss, always make backups.

## License
See the [license](https://raw.githubusercontent.com/zant95/hosts-update/master/LICENSE) file.
