# Install Systemd service and timer units
Assuming you have root permissions, the following commands will schedule a daily update of the hosts file.

```sh
curl -o '/tmp/hblock.#1' 'https://raw.githubusercontent.com/zant95/hblock/master/resources/systemd/hblock.{service,timer}' \
  && sudo mv /tmp/hblock.{service,timer} /etc/systemd/system/ \
  && sudo chown root:root /etc/systemd/system/hblock.{service,timer} \
  && sudo chmod 644 /etc/systemd/system/hblock.{service,timer} \
  && sudo systemctl daemon-reload \
  && sudo systemctl enable hblock.timer \
  && sudo systemctl start hblock.timer
```
