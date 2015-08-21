# hosts-update
This script, designed for GNU/Linux, generates a hosts file based on multiple sources.

- http://winhelp2002.mvps.org/hosts.txt
- http://someonewhocares.org/hosts/hosts
- http://www.malwaredomainlist.com/hostslist/hosts.txt
- http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext
- http://adaway.org/hosts.txt

## Usage
Simply type in your terminal:

	wget -qO- https://raw.githubusercontent.com/zant95/hosts-update/master/hosts-update | bash

**Note:** be sure to regularly update the hosts file for new additions or download the script and create a scheduled task.

## Preview
![Preview](https://i.imgur.com/BXi1dX8.png)

## Disclaimer
This script replaces the "/etc/hosts" file of your system. I am not responsible for any damage or loss, always make backups.

## License
See the [license](https://raw.githubusercontent.com/zant95/hosts-update/master/LICENSE) file.
