# Install Systemd service and timer units

The following commands will schedule a daily update of the hosts file. See [this article](https://wiki.archlinux.org/index.php/Systemd/Timers) for more information about Systemd timers.

```sh
curl -o '/tmp/hblock.#1' 'https://raw.githubusercontent.com/hectorm/hblock/v2.0.10/resources/systemd/hblock.{service,timer}' \
  && echo '70964235a03152d4bc68096a0b99cc59e3f77595b99330f8c55dcca79d7164ff  /tmp/hblock.service' | shasum -c \
  && echo '79ecc28c13b2489400bd5ddc0ee61ddaf6c3225acb1d54b5cb4026f822ae60e8  /tmp/hblock.timer' | shasum -c \
  && sudo mv /tmp/hblock.{service,timer} /etc/systemd/system/ \
  && sudo chown root:root /etc/systemd/system/hblock.{service,timer} \
  && sudo chmod 644 /etc/systemd/system/hblock.{service,timer} \
  && sudo systemctl daemon-reload \
  && sudo systemctl enable hblock.timer \
  && sudo systemctl start hblock.timer
```
