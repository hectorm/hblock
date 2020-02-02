#!/usr/bin/make -f

SHELL := /bin/sh
.SHELLFLAGS = -eu -c

DESTDIR :=
PREFIX := $(DESTDIR)/usr/local
BINDIR := $(PREFIX)/bin
SYSTEMDUNITDIR := $(DESTDIR)/usr/lib/systemd/system

SHELLCHECK := $(shell command -v shellcheck 2>/dev/null)
SYSTEMCTL := $(shell command -v systemctl 2>/dev/null)

DISTDIR := ./dist
RESOURCESDIR := ./resources
HBLOCK := ./hblock
HBLOCK_VERSION := $(shell '$(RESOURCESDIR)'/version.sh get)

HOSTS := $(DISTDIR)/hosts
HOSTS_ALT_FORMATS_SH := $(wildcard $(RESOURCESDIR)/alt-formats/*.sh)
HOSTS_ALT_FORMATS := $(HOSTS_ALT_FORMATS_SH:$(RESOURCESDIR)/alt-formats/%.sh=$(DISTDIR)/hosts_%)
HOSTS_STATS := $(DISTDIR)/most_abused_tlds.txt $(DISTDIR)/most_abused_suffixes.txt
HOSTS_INDEX := $(DISTDIR)/index.html
DEB_PACKAGE := $(DISTDIR)/hblock-$(HBLOCK_VERSION).deb
RPM_PACKAGE := $(DISTDIR)/hblock-$(HBLOCK_VERSION).rpm

##################################################
## "all" target
##################################################
.PHONY: all

all: build

##################################################
## "release" target
##################################################
.PHONY: release

release:
	$(MAKE) clean
	$(MAKE) lint
	$(MAKE) build stats
	$(MAKE) index

##################################################
## "build" target
##################################################
.PHONY: build

build: $(HOSTS)

$(DISTDIR):
	mkdir -p '$(DISTDIR)'

$(HOSTS): | $(DISTDIR)
	'$(HBLOCK)' -O '$(HOSTS)'

ifneq ($(SKIP_HOSTS_ALT_FORMATS),1)

build: $(HOSTS_ALT_FORMATS)

$(HOSTS)_%: $(RESOURCESDIR)/alt-formats/%.sh $(HOSTS)
	'$<' '$(HOSTS)' '$(HBLOCK)' '$(RESOURCESDIR)' > '$@'

endif

##################################################
## "lint" target
##################################################
.PHONY: lint

ifneq ($(SKIP_LINT),1)

lint:
	@[ -x '$(SHELLCHECK)' ]
	'$(SHELLCHECK)' '$(HBLOCK)'
	find '$(RESOURCESDIR)' -type f -name '*.sh' -exec '$(SHELLCHECK)' '{}' '+'

endif

##################################################
## "stats" target
##################################################
.PHONY: stats

ifneq ($(SKIP_STATS),1)
ifneq ($(SKIP_HOSTS_ALT_FORMATS),1)

stats: $(HOSTS_STATS)

$(DISTDIR)/most_abused_tlds.txt: $(DISTDIR)/hosts_domains.txt
	'$(RESOURCESDIR)'/stats/suffix.sh '$(DISTDIR)'/hosts_domains.txt none > '$@'

$(DISTDIR)/most_abused_suffixes.txt: $(DISTDIR)/hosts_domains.txt
	'$(RESOURCESDIR)'/stats/suffix.sh '$(DISTDIR)'/hosts_domains.txt > '$@'

endif
endif

##################################################
## "index" target
##################################################
.PHONY: index

ifneq ($(SKIP_INDEX),1)

index: $(HOSTS_INDEX)

%/index.html: $(filter-out index %/index.html,$(MAKECMDGOALS))
	'$(RESOURCESDIR)'/templates/index.sh "$$(dirname '$@')" > '$@'

endif

##################################################
## "logo" target
##################################################
.PHONY: logo

logo:
	'$(RESOURCESDIR)'/logo/rasterize.sh

##################################################
## "install" target
##################################################
.PHONY: install

install:
	mkdir -p '$(BINDIR)'
	install -Dm 0755 '$(HBLOCK)' '$(BINDIR)'/hblock
	@if [ -x '$(SYSTEMCTL)' ] && [ '$(SKIP_SERVICE_INSTALL)' != 1 ]; then \
		install -Dm 0644 '$(RESOURCESDIR)'/systemd/hblock.service '$(SYSTEMDUNITDIR)'/hblock.service; \
		install -Dm 0644 '$(RESOURCESDIR)'/systemd/hblock.timer '$(SYSTEMDUNITDIR)'/hblock.timer; \
	fi

##################################################
## "installcheck" target
##################################################
.PHONY: installcheck

installcheck:
	@if [ ! -x '$(BINDIR)'/hblock ]; then \
		>&2 printf '%s\n' 'hblock is not installed'; \
		exit 1; \
	fi
	@if [ -x '$(SYSTEMCTL)' ] && [ '$(SKIP_SERVICE_INSTALL)' != 1 ]; then \
		if [ ! -f '$(SYSTEMDUNITDIR)'/hblock.service ]; then \
			>&2 printf '%s\n' 'hblock service is not installed'; \
			exit 1; \
		fi; \
		if [ ! -f '$(SYSTEMDUNITDIR)'/hblock.timer ]; then \
			>&2 printf '%s\n' 'hblock timer is not installed'; \
			exit 1; \
		fi; \
	fi

##################################################
## "uninstall" target
##################################################
.PHONY: uninstall

uninstall:
	rm -f '$(BINDIR)'/hblock
	@if [ -x '$(SYSTEMCTL)' ]; then \
		rm -f '$(SYSTEMDUNITDIR)'/hblock.service; \
		rm -f '$(SYSTEMDUNITDIR)'/hblock.timer; \
	fi

##################################################
## "package-*" targets
##################################################
.PHONY: package-deb package-rpm

package-deb: $(DEB_PACKAGE)

$(DEB_PACKAGE):
	rm -rf ./debian/
	cp -r '$(RESOURCESDIR)'/deb/ ./debian/
	sed -i 's|__PKG_VERSION__|$(HBLOCK_VERSION)|g' ./debian/changelog
	sed -i "s|__PKG_DATE__|$$(LANG=C date -R)|g" ./debian/changelog
	dpkg-buildpackage -us -uc
	mkdir -p "$$(dirname '$@')"
	mv ../hblock_'$(HBLOCK_VERSION)'_all.deb '$@'
	rm -f ../hblock_'$(HBLOCK_VERSION)'.dsc ../hblock_'$(HBLOCK_VERSION)'.tar.gz
	rm -f ../hblock_'$(HBLOCK_VERSION)'_*.buildinfo ../hblock_'$(HBLOCK_VERSION)'_*.changes
	rm -rf ./debian/

package-rpm: $(RPM_PACKAGE)

$(RPM_PACKAGE):
	rm -rf ./rpmbuild/
	cp -r '$(RESOURCESDIR)'/rpm/ ./rpmbuild/
	sed -i 's|__PKG_VERSION__|$(HBLOCK_VERSION)|g' ./rpmbuild/SPECS/hblock.spec
	tar -czf ./rpmbuild/SOURCES/hblock-'$(HBLOCK_VERSION)'.tar.gz --exclude=./rpmbuild --exclude=./.git ./
	rpmbuild -D "_topdir $$(pwd)/rpmbuild" -bb ./rpmbuild/SPECS/hblock.spec
	mkdir -p "$$(dirname '$@')"
	mv ./rpmbuild/RPMS/noarch/hblock-'$(HBLOCK_VERSION)'-*.noarch.rpm '$@'
	rm -rf ./rpmbuild/

##################################################
## "clean" target
##################################################
.PHONY: clean

clean:
	rm -f $(addprefix ', $(addsuffix ', \
		$(HOSTS) $(HOSTS_ALT_FORMATS) $(HOSTS_STATS) $(HOSTS_INDEX) \
		$(DEB_PACKAGE) $(RPM_PACKAGE) \
	))
	if [ -d '$(DISTDIR)' ] && [ -z "$$(ls -A '$(DISTDIR)')" ]; then rmdir '$(DISTDIR)'; fi
