# Install Systemd service and timer units
Assuming you have root permissions, the following commands will schedule a daily update of the hosts file.

```sh
cp hblock.{service,timer} /etc/systemd/system/
chmod 644 /etc/systemd/system/hblock.{service,timer}
systemctl daemon-reload
systemctl enable hblock.timer
systemctl start hblock.timer
```
