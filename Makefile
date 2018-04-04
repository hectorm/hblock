#!/usr/bin/make -f

DESTDIR =
PREFIX = $(DESTDIR)/usr/local
BINDIR = $(PREFIX)/bin
SYSCONFDIR = $(DESTDIR)/etc

SYSTEMCTL := $(shell which systemctl)

MKFILE_RELPATH := $(shell printf -- '%s' "$(MAKEFILE_LIST)" | sed 's|^\ ||')
MKFILE_ABSPATH := $(shell readlink -f -- '$(MKFILE_RELPATH)')
MKFILE_DIR := $(shell dirname -- '$(MKFILE_ABSPATH)')

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

.PHONY: all \
	install uninstall \
	build build-hosts build-android build-windows \
	stats stats-tlds stats-suffixes \
	index \
	clean

all: build index

build: build-hosts build-android build-windows

build-hosts: dist/hosts
dist/hosts:
	mkdir -p dist/
	"$(MKFILE_DIR)"/hblock -O dist/hosts

build-android: build-hosts dist/hosts_android.zip
dist/hosts_android.zip:
	cd "$(MKFILE_DIR)"/resources/android/ && zip -r "$(CURDIR)"/dist/hosts_android.zip ./
	cd dist/ && zip -r hosts_android.zip hosts

build-windows: build-hosts dist/hosts_windows.zip
dist/hosts_windows.zip:
	cd "$(MKFILE_DIR)"/resources/windows/ && zip -rl "$(CURDIR)"/dist/hosts_windows.zip ./
	cd dist/ && zip -rl hosts_windows.zip hosts

stats: stats-tlds stats-suffixes

stats-tlds: build-hosts dist/most_abused_tlds.txt
dist/most_abused_tlds.txt:
	"$(MKFILE_DIR)"/resources/stats/suffix.sh dist/hosts none > dist/most_abused_tlds.txt

stats-suffixes: build-hosts dist/most_abused_suffixes.txt
dist/most_abused_suffixes.txt:
	"$(MKFILE_DIR)"/resources/stats/suffix.sh dist/hosts > dist/most_abused_suffixes.txt

index: build-hosts dist/index.html
dist/index.html:
	"$(MKFILE_DIR)"/resources/templates/index.sh dist/ > dist/index.html

install: build-hosts
	mkdir -p -- "$(PREFIX)" "$(BINDIR)" "$(SYSCONFDIR)"
	install -m 0755 -- dist/hosts "$(SYSCONFDIR)"/hosts
	install -m 0755 -- "$(MKFILE_DIR)"/hblock "$(BINDIR)"/hblock
	if test -x "$(SYSTEMCTL)" && test -d "$(SYSCONFDIR)"/systemd/system; then \
		install -m 0644 -- "$(MKFILE_DIR)"/resources/systemd/hblock.service "$(SYSCONFDIR)"/systemd/system/hblock.service \
		&& install -m 0644 -- "$(MKFILE_DIR)"/resources/systemd/hblock.timer "$(SYSCONFDIR)"/systemd/system/hblock.timer \
		&& "$(SYSTEMCTL)" daemon-reload \
		&& "$(SYSTEMCTL)" enable hblock.timer \
		&& "$(SYSTEMCTL)" start hblock.timer; \
	fi

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

clean:
	rm -f \
		dist/hosts \
		dist/hosts.gz \
		dist/hosts_android.zip \
		dist/hosts_windows.zip \
		dist/most_abused_tlds.txt \
		dist/most_abused_suffixes.txt \
		dist/index.html
	-rmdir dist/
