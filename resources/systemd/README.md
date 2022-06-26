# Install systemd service and timer units

The following commands will schedule a daily update of the hosts file. See [this article](https://wiki.archlinux.org/index.php/systemd/Timers) for
more information about systemd timers.

```sh
curl -o '/tmp/hblock.#1' 'https://raw.githubusercontent.com/hectorm/hblock/v3.4.0/resources/systemd/hblock.{service,timer}' \
  && echo '45980a80506df48cbfa6dd18d20f0ad4300744344408a0f87560b2be73b7c607  /tmp/hblock.service' | shasum -c \
  && echo '87a7ba5067d4c565aca96659b0dce230471a6ba35fbce1d3e9d02b264da4dc38  /tmp/hblock.timer' | shasum -c \
  && sudo mv /tmp/hblock.{service,timer} /etc/systemd/system/ \
  && sudo chown 0:0 /etc/systemd/system/hblock.{service,timer} \
  && sudo chmod 644 /etc/systemd/system/hblock.{service,timer} \
  && sudo systemctl daemon-reload \
  && sudo systemctl enable hblock.timer \
  && sudo systemctl start hblock.timer
```

# Modify default options with environment variables

To change the default options instead of modifying the original service it is possible to override its properties.

For example, to have multiple domains on the same line and enable regular expressions in the allowlist, create the file
`/etc/systemd/system/hblock.service.d/override.conf` with the following content:

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
