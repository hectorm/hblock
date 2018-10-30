#!/usr/bin/make -f

DESTDIR =
PREFIX = $(DESTDIR)/usr/local
BINDIR = $(PREFIX)/bin
SYSCONFDIR = $(DESTDIR)/etc

SYSTEMCTL := $(shell which systemctl 2>/dev/null)

define DEFAULT_HOSTS
127.0.0.1       localhost $(shell uname -n)
255.255.255.255 broadcasthost
::1             localhost ip6-localhost ip6-loopback
fe00::0         ip6-localnet
ff00::0         ip6-mcastprefix
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
ff02::3         ip6-allhosts
endef
export DEFAULT_HOSTS

.PHONY: all
all: build index

.PHONY: build
build: \
	build-hosts \
	build-domains \
	build-adblock \
	build-rpz \
	build-dnsmasq \
	build-unbound \
	build-android \
	build-windows

.PHONY: build-hosts
build-hosts: dist/hosts
dist/hosts:
	mkdir -p ./dist/
	./hblock -O ./dist/hosts

.PHONY: build-domains
build-domains: build-hosts dist/hosts_domains.txt
dist/hosts_domains.txt:
	./resources/alt-formats/domains.sh ./dist/hosts > ./dist/hosts_domains.txt

.PHONY: build-adblock
build-adblock: build-hosts dist/hosts_adblock.txt
dist/hosts_adblock.txt:
	./resources/alt-formats/adblock.sh ./dist/hosts > ./dist/hosts_adblock.txt

.PHONY: build-rpz
build-rpz: build-hosts dist/hosts_rpz.txt
dist/hosts_rpz.txt:
	./resources/alt-formats/rpz.sh ./dist/hosts > ./dist/hosts_rpz.txt

.PHONY: build-dnsmasq
build-dnsmasq: build-hosts dist/hosts_dnsmasq.conf
dist/hosts_dnsmasq.conf:
	./resources/alt-formats/dnsmasq.sh ./dist/hosts > ./dist/hosts_dnsmasq.conf

.PHONY: build-unbound
build-unbound: build-hosts dist/hosts_unbound.conf
dist/hosts_unbound.conf:
	./resources/alt-formats/unbound.sh ./dist/hosts > ./dist/hosts_unbound.conf

.PHONY: build-android
build-android: build-hosts dist/hosts_android.zip
dist/hosts_android.zip:
	cd ./resources/alt-formats/android/ && zip -r "$(CURDIR)"/dist/hosts_android.zip ./
	cd ./dist/ && zip -r ./hosts_android.zip ./hosts

.PHONY: build-windows
build-windows: build-hosts dist/hosts_windows.zip
dist/hosts_windows.zip:
	cd ./resources/alt-formats/windows/ && zip -rl "$(CURDIR)"/dist/hosts_windows.zip ./
	cd ./dist/ && zip -rl ./hosts_windows.zip ./hosts

.PHONY: stats
stats: stats-tlds stats-suffixes

.PHONY: stats-tlds
stats-tlds: build-domains dist/most_abused_tlds.txt
dist/most_abused_tlds.txt:
	./resources/stats/suffix.sh ./dist/hosts_domains.txt none > ./dist/most_abused_tlds.txt

.PHONY: stats-suffixes
stats-suffixes: build-domains dist/most_abused_suffixes.txt
dist/most_abused_suffixes.txt:
	./resources/stats/suffix.sh ./dist/hosts_domains.txt > ./dist/most_abused_suffixes.txt

.PHONY: index
index: build-hosts dist/index.html
dist/index.html:
	./resources/templates/index.sh ./dist/ > ./dist/index.html

.PHONY: logo
logo:
	./resources/logo/rasterize.sh

.PHONY: install
install: build-hosts
	mkdir -p -- "$(PREFIX)" "$(BINDIR)" "$(SYSCONFDIR)"
	install -m 0755 -- ./dist/hosts "$(SYSCONFDIR)"/hosts
	install -m 0755 -- ./hblock "$(BINDIR)"/hblock
	if test -x "$(SYSTEMCTL)" && test -d "$(SYSCONFDIR)"/systemd/system; then \
		install -m 0644 -- ./resources/systemd/hblock.service "$(SYSCONFDIR)"/systemd/system/hblock.service \
		&& install -m 0644 -- ./resources/systemd/hblock.timer "$(SYSCONFDIR)"/systemd/system/hblock.timer \
		&& "$(SYSTEMCTL)" daemon-reload \
		&& "$(SYSTEMCTL)" enable hblock.timer \
		&& "$(SYSTEMCTL)" start hblock.timer; \
	fi

.PHONY: uninstall
uninstall:
	rm -f -- "$(BINDIR)"/hblock
	printf -- '%s\n' "$$DEFAULT_HOSTS" > "$(SYSCONFDIR)"/hosts
	if test -x "$(SYSTEMCTL)" && test -d "$(SYSCONFDIR)"/systemd/system; then \
		"$(SYSTEMCTL)" stop hblock.timer \
		&& "$(SYSTEMCTL)" disable hblock.timer \
		&& rm -f -- \
			"$(SYSCONFDIR)"/systemd/system/hblock.service \
			"$(SYSCONFDIR)"/systemd/system/hblock.timer \
		&& "$(SYSTEMCTL)" daemon-reload; \
	fi

.PHONY: clean
clean:
	rm -f \
		./dist/hosts \
		./dist/hosts_domains.txt \
		./dist/hosts_adblock.txt \
		./dist/hosts_rpz.txt \
		./dist/hosts_dnsmasq.conf \
		./dist/hosts_unbound.conf \
		./dist/hosts_android.zip \
		./dist/hosts_windows.zip \
		./dist/most_abused_tlds.txt \
		./dist/most_abused_suffixes.txt \
		./dist/index.html
	-rmdir ./dist/
