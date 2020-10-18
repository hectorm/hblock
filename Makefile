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

DISTDIR := $(CURDIR)/dist
RESOURCESDIR := $(CURDIR)/resources
HBLOCK := $(CURDIR)/hblock
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
	HOSTNAME='' '$(HBLOCK)' -H 'builtin' -F 'builtin' -S 'builtin' -A 'builtin' -D 'builtin' -O '$(HOSTS)'

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
	[ -x '$(SHELLCHECK)' ]
	'$(SHELLCHECK)' '$(HBLOCK)'
	find '$(RESOURCESDIR)' -type f -name '*.sh' -exec '$(SHELLCHECK)' '{}' ';'

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
	if [ -x '$(SYSTEMCTL)' ] && [ '$(SKIP_INSTALL_SERVICE)' != 1 ]; then \
		install -Dm 0644 '$(RESOURCESDIR)'/systemd/hblock.service '$(SYSTEMDUNITDIR)'/hblock.service; \
		install -Dm 0644 '$(RESOURCESDIR)'/systemd/hblock.timer '$(SYSTEMDUNITDIR)'/hblock.timer; \
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
.PHONY: package-deb package-rpm

package-deb: $(DEB_PACKAGE)

$(DEB_PACKAGE): | $(DISTDIR)
	rm -rf '$(DISTDIR)'/debian/
	cp -a '$(RESOURCESDIR)'/deb/ '$(DISTDIR)'/debian/
	cp -a '$(RESOURCESDIR)'/systemd/hblock.service '$(DISTDIR)'/debian/
	cp -a '$(RESOURCESDIR)'/systemd/hblock.timer '$(DISTDIR)'/debian/
	sed -i 's|__PKG_VERSION__|$(HBLOCK_VERSION)|g' '$(DISTDIR)'/debian/changelog
	sed -i "s|__PKG_DATE__|$$(LC_ALL=C date -Ru)|g" '$(DISTDIR)'/debian/changelog
	cd '$(DISTDIR)' && dpkg-buildpackage -us -uc
	mv -f '$(DISTDIR)'/../hblock_'$(HBLOCK_VERSION)'_all.deb '$@'
	rm -f '$(DISTDIR)'/../hblock_'$(HBLOCK_VERSION)'.dsc '$(DISTDIR)'/../hblock_'$(HBLOCK_VERSION)'.tar.gz
	rm -f '$(DISTDIR)'/../hblock_'$(HBLOCK_VERSION)'_*.buildinfo '$(DISTDIR)'/../hblock_'$(HBLOCK_VERSION)'_*.changes

package-rpm: $(RPM_PACKAGE)

$(RPM_PACKAGE): | $(DISTDIR)
	rm -rf '$(DISTDIR)'/rpmbuild/
	cp -a '$(RESOURCESDIR)'/rpm/ '$(DISTDIR)'/rpmbuild/
	sed -i 's|__PKG_VERSION__|$(HBLOCK_VERSION)|g' '$(DISTDIR)'/rpmbuild/SPECS/hblock.spec
	tar -czf '$(DISTDIR)'/rpmbuild/SOURCES/hblock-'$(HBLOCK_VERSION)'.tar.gz --exclude-vcs --exclude='$(DISTDIR)' '$(CURDIR)'
	rpmbuild -D "_topdir $$(readlink -f '$(DISTDIR)'/rpmbuild/)" -bb '$(DISTDIR)'/rpmbuild/SPECS/hblock.spec
	mv -f '$(DISTDIR)'/rpmbuild/RPMS/noarch/hblock-'$(HBLOCK_VERSION)'-*.noarch.rpm '$@'

##################################################
## "clean" target
##################################################
.PHONY: clean

clean:
	rm -f $(addprefix ', $(addsuffix ', $(HOSTS) $(HOSTS_ALT_FORMATS) $(HOSTS_STATS) $(HOSTS_INDEX) $(DEB_PACKAGE) $(RPM_PACKAGE)))
	rm -rf $(addprefix ', $(addsuffix ', $(DISTDIR)/debian/ $(DISTDIR)/rpmbuild/))
	if [ -d '$(DISTDIR)' ] && [ -z "$$(ls -A '$(DISTDIR)')" ]; then rmdir '$(DISTDIR)'; fi
