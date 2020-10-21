#!/usr/bin/make -f

SHELL := /bin/sh
.SHELLFLAGS := -euc

DESTDIR :=
PREFIX := $(DESTDIR)/usr/local
BINDIR := $(PREFIX)/bin
LIBDIR := $(PREFIX)/lib
SYSTEMDUNITDIR := $(LIBDIR)/systemd/system

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
	HOSTNAME='' ./hblock -H 'builtin' -F 'builtin' -S 'builtin' -A 'builtin' -D 'builtin' -O './dist/hosts'

./dist/hosts_%: ./resources/alt-formats/%.sh ./dist/hosts
	'$<' './dist/hosts' ./hblock ./resources/ > '$@'

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
## "lint" target
##################################################
.PHONY: lint

lint:
	'$(SHELLCHECK)' ./hblock
	'$(SHELLCHECK)' ./resources/alt-formats/*.sh
	'$(SHELLCHECK)' ./resources/logo/rasterize.sh
	'$(SHELLCHECK)' ./resources/stats/suffix.sh
	'$(SHELLCHECK)' ./resources/templates/index.sh
	'$(SHELLCHECK)' ./resources/version/version.sh

##################################################
## "install" target
##################################################
.PHONY: install

install:
	mkdir -p '$(BINDIR)'
	install -Dm 0755 ./hblock '$(BINDIR)'/hblock
	if [ -x '$(SYSTEMCTL)' ] && [ '$(SKIP_INSTALL_SERVICE)' != 1 ]; then \
		install -Dm 0644 ./resources/systemd/hblock.service '$(SYSTEMDUNITDIR)'/hblock.service; \
		install -Dm 0644 ./resources/systemd/hblock.timer '$(SYSTEMDUNITDIR)'/hblock.timer; \
	fi

##################################################
## "installcheck" target
##################################################
.PHONY: installcheck

installcheck:
	if [ ! -x '$(BINDIR)'/hblock ]; then \
		printf '%s\n' 'hblock is not installed' >&2; \
		exit 1; \
	fi
	if [ -x '$(SYSTEMCTL)' ] && [ '$(SKIP_INSTALL_SERVICE)' != 1 ]; then \
		if [ ! -f '$(SYSTEMDUNITDIR)'/hblock.service ]; then \
			printf '%s\n' 'hblock service is not installed' >&2; \
			exit 1; \
		fi; \
		if [ ! -f '$(SYSTEMDUNITDIR)'/hblock.timer ]; then \
			printf '%s\n' 'hblock timer is not installed' >&2; \
			exit 1; \
		fi; \
	fi

##################################################
## "uninstall" target
##################################################
.PHONY: uninstall

uninstall:
	rm -f '$(BINDIR)'/hblock
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
	cp -a ./resources/deb/ ./dist/debbuild/debian/
	cp -a ./resources/systemd/hblock.* ./dist/debbuild/debian/
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
	sed -i 's|__PKG_VERSION__|$(VERSION)|g' ./dist/rpmbuild/SPECS/hblock.spec
	tar -cf ./dist/rpmbuild/SOURCES/hblock-'$(VERSION)'.tar ./hblock
	tar -rf ./dist/rpmbuild/SOURCES/hblock-'$(VERSION)'.tar ./Makefile
	tar -rf ./dist/rpmbuild/SOURCES/hblock-'$(VERSION)'.tar ./resources/systemd/hblock.*
	rpmbuild -D "_topdir $$(readlink -f ./dist/rpmbuild/)" -bb ./dist/rpmbuild/SPECS/hblock.spec
	mv -f ./dist/rpmbuild/RPMS/noarch/hblock-'$(VERSION)'-*.noarch.rpm '$@'

package-npm: ./dist/hblock-$(VERSION).tgz

./dist/hblock-$(VERSION).tgz: | ./dist/
	rm -rf ./dist/npmbuild/; mkdir ./dist/npmbuild/
	cp -a ./hblock ./dist/npmbuild/hblock
	cp -a ./README.md ./dist/npmbuild/README.md
	cp -a ./LICENSE.md ./dist/npmbuild/LICENSE.md
	cp -a ./resources/npm/* ./dist/npmbuild/
	sed -i 's|__PKG_VERSION__|$(VERSION)|g' ./dist/npmbuild/package.json
	tar -czf '$@' -C ./dist/npmbuild/ ./

##################################################
## "clean" target
##################################################
.PHONY: clean

clean:
	rm -rf ./dist/
