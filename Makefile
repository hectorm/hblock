#!/usr/bin/make -f

SHELL := /bin/sh
.SHELLFLAGS := -euc

DESTDIR ?=
PREFIX ?= $(DESTDIR)/usr/local
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib
DATADIR ?= $(PREFIX)/share
MANDIR ?= $(DATADIR)/man
SYSTEMDUNITDIR ?= $(LIBDIR)/systemd/system

HELP2MAN := $(shell command -v help2man 2>/dev/null)
PANDOC := $(shell command -v pandoc 2>/dev/null)
SHELLCHECK := $(shell command -v shellcheck 2>/dev/null)
SYSTEMCTL := $(shell command -v systemctl 2>/dev/null)

VERSION := $(shell ./resources/version/version.sh get)

##################################################
## "all" target
##################################################
.PHONY: all

all:
	$(MAKE) build stats
	$(MAKE) index

##################################################
## "build" target
##################################################
.PHONY: build

ALT_FORMATS_SH := $(wildcard ./resources/alt-formats/*.sh)
ALT_FORMATS_OUT := $(ALT_FORMATS_SH:./resources/alt-formats/%.sh=./dist/hosts_%)

build: ./dist/hosts $(ALT_FORMATS_OUT)

./dist/:
	mkdir -p ./dist/

./dist/hosts: | ./dist/
	HOSTNAME='' ./hblock -H builtin -F builtin -S builtin -A builtin -D builtin -O ./dist/hosts

./dist/hosts_%: ./resources/alt-formats/%.sh ./dist/hosts
	'$<' ./dist/hosts '$@' ./hblock

##################################################
## "stats" target
##################################################
.PHONY: stats

stats: ./dist/most_abused_tlds.txt ./dist/most_abused_suffixes.txt

./dist/most_abused_tlds.txt: ./dist/hosts_domains.txt
	./resources/stats/suffix.sh ./dist/hosts_domains.txt none > '$@'

./dist/most_abused_suffixes.txt: ./dist/hosts_domains.txt
	./resources/stats/suffix.sh ./dist/hosts_domains.txt > '$@'

##################################################
## "index" target
##################################################
.PHONY: index

index: ./dist/index.html

%/index.html: $(filter-out index %/index.html,$(MAKECMDGOALS))
	./resources/templates/index.sh "$$(dirname '$@')" > '$@'

##################################################
## "man" target
##################################################
.PHONY: man

man: ./hblock.1 ./hblock.1.md

./hblock.1:
	'$(HELP2MAN)' --locale='en_US.UTF-8' --no-info --output='$@' ./hblock

./hblock.1.md: ./hblock.1
	'$(PANDOC)' --from='man' --to='gfm' --output='$@' ./hblock.1

##################################################
## "lint" target
##################################################
.PHONY: lint

lint:
	'$(SHELLCHECK)' ./hblock
	find ./ -type f -name '*.sh' | xargs '$(SHELLCHECK)'

##################################################
## "install" target
##################################################
.PHONY: install

install:
	mkdir -p '$(BINDIR)' '$(MANDIR)'/man1/
	install -Dm 0755 ./hblock '$(BINDIR)'/hblock
	install -Dm 0644 ./hblock.1 '$(MANDIR)'/man1/hblock.1
	if [ -x '$(SYSTEMCTL)' ] && [ '$(SKIP_INSTALL_SERVICE)' != 1 ]; then \
		mkdir -p '$(SYSTEMDUNITDIR)'; \
		install -Dm 0644 ./resources/systemd/hblock.service '$(SYSTEMDUNITDIR)'/hblock.service; \
		install -Dm 0644 ./resources/systemd/hblock.timer '$(SYSTEMDUNITDIR)'/hblock.timer; \
	fi

##################################################
## "installcheck" target
##################################################
.PHONY: installcheck

installcheck:
	if [ ! -x '$(BINDIR)'/hblock ]; then \
		printf '%s\n' 'hBlock is not installed' >&2; \
		exit 1; \
	fi
	if [ ! -f '$(MANDIR)'/man1/hblock.1 ]; then \
		printf '%s\n' 'hBlock man page is not installed' >&2; \
		exit 1; \
	fi
	if [ -x '$(SYSTEMCTL)' ] && [ '$(SKIP_INSTALL_SERVICE)' != 1 ]; then \
		if [ ! -f '$(SYSTEMDUNITDIR)'/hblock.service ]; then \
			printf '%s\n' 'hBlock service is not installed' >&2; \
			exit 1; \
		fi; \
		if [ ! -f '$(SYSTEMDUNITDIR)'/hblock.timer ]; then \
			printf '%s\n' 'hBlock timer is not installed' >&2; \
			exit 1; \
		fi; \
	fi

##################################################
## "uninstall" target
##################################################
.PHONY: uninstall

uninstall:
	rm -f '$(BINDIR)'/hblock
	rm -f '$(MANDIR)'/man1/hblock.1
	if [ -x '$(SYSTEMCTL)' ]; then \
		rm -f '$(SYSTEMDUNITDIR)'/hblock.service; \
		rm -f '$(SYSTEMDUNITDIR)'/hblock.timer; \
	fi

##################################################
## "package-*" targets
##################################################
.PHONY: package-deb package-rpm package-npm

package-deb: ./dist/hblock-$(VERSION).deb

./dist/hblock-$(VERSION).deb: | ./dist/
	rm -rf ./dist/debbuild/; mkdir ./dist/debbuild/
	cp -a ./hblock ./dist/debbuild/
	cp -a ./hblock.1 ./dist/debbuild/
	cp -a ./resources/deb/ ./dist/debbuild/debian/
	cp -a ./resources/systemd/hblock.service ./dist/debbuild/debian/
	cp -a ./resources/systemd/hblock.timer ./dist/debbuild/debian/
	sed -i 's|__PKG_VERSION__|$(VERSION)|g' ./dist/debbuild/debian/changelog
	sed -i "s|__PKG_DATE__|$$(LC_ALL=C date -Ru)|g" ./dist/debbuild/debian/changelog
	cd ./dist/debbuild/ && dpkg-buildpackage -us -uc
	mv -f ./dist/hblock_'$(VERSION)'_all.deb '$@'
	rm -f ./dist/hblock_'$(VERSION)'.dsc ./dist/hblock_'$(VERSION)'.tar.*
	rm -f ./dist/hblock_'$(VERSION)'_*.buildinfo ./dist/hblock_'$(VERSION)'_*.changes

package-rpm: ./dist/hblock-$(VERSION).rpm

./dist/hblock-$(VERSION).rpm: | ./dist/
	rm -rf ./dist/rpmbuild/; mkdir ./dist/rpmbuild/
	cp -a ./resources/rpm/* ./dist/rpmbuild/
	tar -cf ./dist/rpmbuild/SOURCES/hblock.tar ./hblock
	tar -rf ./dist/rpmbuild/SOURCES/hblock.tar ./hblock.1
	tar -rf ./dist/rpmbuild/SOURCES/hblock.tar ./Makefile
	tar -rf ./dist/rpmbuild/SOURCES/hblock.tar ./LICENSE.md
	tar -rf ./dist/rpmbuild/SOURCES/hblock.tar ./README.md
	tar -rf ./dist/rpmbuild/SOURCES/hblock.tar ./resources/systemd/hblock.service
	tar -rf ./dist/rpmbuild/SOURCES/hblock.tar ./resources/systemd/hblock.timer
	sed -i 's|__PKG_VERSION__|$(VERSION)|g' ./dist/rpmbuild/SPECS/hblock.spec
	rpmbuild -D "_topdir $$(readlink -f ./dist/rpmbuild/)" -bb ./dist/rpmbuild/SPECS/hblock.spec
	mv -f ./dist/rpmbuild/RPMS/noarch/hblock-'$(VERSION)'-*.noarch.rpm '$@'

package-npm: ./dist/hblock-$(VERSION).tgz

./dist/hblock-$(VERSION).tgz: | ./dist/
	rm -rf ./dist/npmbuild/; mkdir ./dist/npmbuild/
	cp -a ./hblock ./dist/npmbuild/
	cp -a ./hblock.1 ./dist/npmbuild/
	cp -a ./LICENSE.md ./dist/npmbuild/
	cp -a ./README.md ./dist/npmbuild/
	cp -a ./resources/npm/* ./dist/npmbuild/
	sed -i 's|__PKG_VERSION__|$(VERSION)|g' ./dist/npmbuild/package.json
	tar -czf '$@' -C ./dist/npmbuild/ ./

##################################################
## "clean" target
##################################################
.PHONY: clean

clean:
	rm -rf ./dist/
