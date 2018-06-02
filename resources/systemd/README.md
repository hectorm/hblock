# Install Systemd service and timer units
The following commands will schedule a daily update of the hosts file. See [this article](https://wiki.archlinux.org/index.php/Systemd/Timers) for more information about Systemd timers.

```sh
curl -o '/tmp/hblock.#1' 'https://raw.githubusercontent.com/hectorm/hblock/v1.5.1/resources/systemd/hblock.{service,timer}' \
  && echo '16d547d11d1eff1cd7109ef8436a899f2e868992b8d9de757e65d4ab94f64fe7  /tmp/hblock.service' | shasum -c \
  && echo '79ecc28c13b2489400bd5ddc0ee61ddaf6c3225acb1d54b5cb4026f822ae60e8  /tmp/hblock.timer' | shasum -c \
  && sudo mv /tmp/hblock.{service,timer} /etc/systemd/system/ \
  && sudo chown root:root /etc/systemd/system/hblock.{service,timer} \
  && sudo chmod 644 /etc/systemd/system/hblock.{service,timer} \
  && sudo systemctl daemon-reload \
  && sudo systemctl enable hblock.timer \
  && sudo systemctl start hblock.timer
```
