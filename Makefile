#!/usr/bin/make -f

SHELL := /bin/sh
.SHELLFLAGS := -euc

DESTDIR ?=

prefix ?= /usr/local
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin
libdir ?= $(exec_prefix)/lib
datarootdir ?= $(prefix)/share
mandir ?= $(datarootdir)/man
unitdir ?= $(libdir)/systemd/system

HELP2MAN ?= help2man
PANDOC ?= pandoc
SHELLCHECK ?= shellcheck
SYSTEMCTL ?= systemctl
INSTALL ?= install

INSTALL_PROGRAM ?= $(INSTALL)
INSTALL_DATA ?= $(INSTALL) -m 644

VERSION := $(shell ./resources/version/version.sh get)

##################################################
## "all" target
##################################################
.PHONY: all

all: build

##################################################
## "build" target
##################################################
.PHONY: build

build:
	@printf '%s\n' 'No build step required.'
	@printf '%s\n' 'Run "make install" to install hBlock.'

##################################################
## "hosts" target
##################################################
.PHONY: hosts

ALT_FORMATS_SH := $(wildcard ./resources/alt-formats/*.sh)
ALT_FORMATS_OUT := $(ALT_FORMATS_SH:./resources/alt-formats/%.sh=./dist/hosts_%)

hosts: ./dist/hosts $(ALT_FORMATS_OUT)

./dist/hosts:
	mkdir -p ./dist/
	HOSTNAME='' ./hblock -H builtin -F builtin -S builtin -A builtin -D builtin -O ./dist/hosts

./dist/hosts_%: ./resources/alt-formats/%.sh ./dist/hosts
	'$<' ./dist/hosts '$@' ./hblock

##################################################
## "stats" target
##################################################
.PHONY: stats

stats: ./dist/most_abused_tlds.txt ./dist/most_abused_suffixes.txt

./dist/most_abused_tlds.txt: ./dist/hosts_domains.txt
	./resources/stats/stats.sh ./dist/hosts_domains.txt none > '$@'

./dist/most_abused_suffixes.txt: ./dist/hosts_domains.txt
	./resources/stats/stats.sh ./dist/hosts_domains.txt > '$@'

##################################################
## "index" target
##################################################
.PHONY: index

index: ./dist/index.html

./dist/index.html: ./dist/hosts $(ALT_FORMATS_OUT) ./dist/most_abused_tlds.txt ./dist/most_abused_suffixes.txt
	./resources/index/index.sh ./dist/ > '$@'

##################################################
## "man" target
##################################################
.PHONY: man

man: ./hblock.1 ./hblock.1.md

./hblock.1:
	$(HELP2MAN) --locale='en_US.UTF-8' --no-info --output='$@' ./hblock

./hblock.1.md: ./hblock.1
	$(PANDOC) --from='man' --to='gfm' --output='$@' ./hblock.1

##################################################
## "lint" target
##################################################
.PHONY: lint

lint:
	find ./ -type f '(' -name 'hblock' -or -name '*.sh' ')' | xargs $(SHELLCHECK)

##################################################
## "test-*" targets
##################################################
.PHONY: test test-all test-main test-stats

test: test-main

test-all: test-main test-stats

test-main test-stats:
	find ./resources/tests/ -type f -name '$@-*.sh' | sort -n | xargs -n1 env -i \
		PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
		TEST_SHELL='$(TEST_SHELL)'

##################################################
## "install" target
##################################################
.PHONY: install

install:
	mkdir -p '$(DESTDIR)$(bindir)' '$(DESTDIR)$(mandir)'/man1/
	$(INSTALL_PROGRAM) ./hblock '$(DESTDIR)$(bindir)'/hblock
	$(INSTALL_DATA) ./hblock.1 '$(DESTDIR)$(mandir)'/man1/hblock.1
	if command -v '$(SYSTEMCTL)' >/dev/null && [ '$(SKIP_INSTALL_SERVICE)' != 1 ]; then \
		mkdir -p '$(DESTDIR)$(unitdir)'; \
		$(INSTALL_DATA) ./resources/systemd/hblock.service '$(DESTDIR)$(unitdir)'/hblock.service; \
		$(INSTALL_DATA) ./resources/systemd/hblock.timer '$(DESTDIR)$(unitdir)'/hblock.timer; \
	fi

##################################################
## "installcheck" target
##################################################
.PHONY: installcheck

installcheck:
	if [ ! -x '$(DESTDIR)$(bindir)'/hblock ]; then \
		printf '%s\n' 'hBlock is not installed' >&2; \
		exit 1; \
	fi
	if [ ! -f '$(DESTDIR)$(mandir)'/man1/hblock.1 ]; then \
		printf '%s\n' 'hBlock man page is not installed' >&2; \
		exit 1; \
	fi
	if command -v '$(SYSTEMCTL)' >/dev/null && [ '$(SKIP_INSTALL_SERVICE)' != 1 ]; then \
		if [ ! -f '$(DESTDIR)$(unitdir)'/hblock.service ]; then \
			printf '%s\n' 'hBlock service is not installed' >&2; \
			exit 1; \
		fi; \
		if [ ! -f '$(DESTDIR)$(unitdir)'/hblock.timer ]; then \
			printf '%s\n' 'hBlock timer is not installed' >&2; \
			exit 1; \
		fi; \
	fi

##################################################
## "uninstall" target
##################################################
.PHONY: uninstall

uninstall:
	rm -f '$(DESTDIR)$(bindir)'/hblock
	rm -f '$(DESTDIR)$(mandir)'/man1/hblock.1
	rm -f '$(DESTDIR)$(unitdir)'/hblock.service
	rm -f '$(DESTDIR)$(unitdir)'/hblock.timer

##################################################
## "package-*" targets
##################################################
.PHONY: package-deb package-rpm package-npm

package-deb: ./dist/packages/hblock-$(VERSION).deb

./dist/packages/hblock-$(VERSION).deb:
	PKG_VERSION='$(VERSION)' ./resources/packaging/deb.sh '$@'

package-rpm: ./dist/packages/hblock-$(VERSION).rpm

./dist/packages/hblock-$(VERSION).rpm:
	PKG_VERSION='$(VERSION)' ./resources/packaging/rpm.sh '$@'

package-pkgbuild: ./dist/packages/hblock-$(VERSION).pkg.tar.zst

./dist/packages/hblock-$(VERSION).pkg.tar.zst:
	PKG_VERSION='$(VERSION)' ./resources/packaging/pkgbuild.sh '$@'

package-apkbuild: ./dist/packages/hblock-$(VERSION).apk

./dist/packages/hblock-$(VERSION).apk:
	PKG_VERSION='$(VERSION)' ./resources/packaging/apkbuild.sh '$@'

package-npm: ./dist/packages/hblock-$(VERSION).tgz

./dist/packages/hblock-$(VERSION).tgz:
	PKG_VERSION='$(VERSION)' ./resources/packaging/npm.sh '$@'

##################################################
## "clean" target
##################################################
.PHONY: clean

clean:
	rm -rf ./dist/
