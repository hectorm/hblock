# Install Systemd service and timer units
The following commands will schedule a daily update of the hosts file. See [this article](https://wiki.archlinux.org/index.php/Systemd/Timers) for more information about Systemd timers.

```sh
curl -o '/tmp/hblock.#1' 'https://raw.githubusercontent.com/zant95/hblock/v1.2.4/resources/systemd/hblock.{service,timer}' \
  && echo 'e3b6be7089d169a1f43e73c4b1de680a9bb276c2ab3fccb4db89449de97c3741  /tmp/hblock.service' | shasum -c \
  && echo 'ea2442b7bae01cee6369ac7e09c13921147870405af4a240d269a69b1caa9efe  /tmp/hblock.timer' | shasum -c \
  && sudo mv /tmp/hblock.{service,timer} /etc/systemd/system/ \
  && sudo chown root:root /etc/systemd/system/hblock.{service,timer} \
  && sudo chmod 644 /etc/systemd/system/hblock.{service,timer} \
  && sudo systemctl daemon-reload \
  && sudo systemctl enable hblock.timer \
  && sudo systemctl start hblock.timer
```
