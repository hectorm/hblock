# Install systemd service and timer units

The following commands will schedule a daily update of the hosts file. See [this article](https://wiki.archlinux.org/index.php/systemd/Timers) for more information about systemd timers.

```sh
curl -o '/tmp/hblock.#1' 'https://raw.githubusercontent.com/hectorm/hblock/v2.1.7/resources/systemd/hblock.{service,timer}' \
  && echo '70964235a03152d4bc68096a0b99cc59e3f77595b99330f8c55dcca79d7164ff  /tmp/hblock.service' | shasum -c \
  && echo '79ecc28c13b2489400bd5ddc0ee61ddaf6c3225acb1d54b5cb4026f822ae60e8  /tmp/hblock.timer' | shasum -c \
  && sudo mv /tmp/hblock.{service,timer} /etc/systemd/system/ \
  && sudo chown root:root /etc/systemd/system/hblock.{service,timer} \
  && sudo chmod 644 /etc/systemd/system/hblock.{service,timer} \
  && sudo systemctl daemon-reload \
  && sudo systemctl enable hblock.timer \
  && sudo systemctl start hblock.timer
```

# Modify default options with environment variables

To change the default options instead of modifying the original service you can override its properties.

For example, to have multiple domains on the same line and enable regular expressions in the allowlist, create the file `/etc/systemd/system/hblock.service.d/override.conf` with the following content:

```
[Service]
Environment=HBLOCK_WRAP=20
Environment=HBLOCK_REGEX=true
```

Then reload the systemd configuration and start the service:

```sh
sudo systemctl daemon-reload
sudo systemctl start hblock.service
```
