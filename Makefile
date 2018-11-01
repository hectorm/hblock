#!/usr/bin/make -f

SHELL := /bin/sh
.SHELLFLAGS = -eu -c

DESTDIR :=
PREFIX := $(DESTDIR)/usr/local
BINDIR := $(PREFIX)/bin
SYSCONFDIR := $(DESTDIR)/etc

SYSTEMCTL := $(shell command -v systemctl 2>/dev/null)
SHELLCHECK := $(shell command -v shellcheck 2>/dev/null)

DISTDIR := ./dist
RESOURCESDIR := ./resources
HBLOCK := ./hblock
HOSTS := $(DISTDIR)/hosts
HOSTS_ALT_FORMATS_SH := $(wildcard $(RESOURCESDIR)/alt-formats/*.sh)
HOSTS_ALT_FORMATS := $(HOSTS_ALT_FORMATS_SH:$(RESOURCESDIR)/alt-formats/%.sh=$(DISTDIR)/hosts_%)
HOSTS_STATS := $(DISTDIR)/most_abused_tlds.txt $(DISTDIR)/most_abused_suffixes.txt
HOSTS_INDEX := $(DISTDIR)/index.html

define DEFAULT_HOSTS :=
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

install: $(HOSTS)
	mkdir -p '$(PREFIX)' '$(BINDIR)' '$(SYSCONFDIR)'
	install -m 0755 '$(HBLOCK)' '$(BINDIR)'/hblock
	install -m 0644 '$(HOSTS)' '$(SYSCONFDIR)'/hosts
	if [ -x '$(SYSTEMCTL)' ] && [ -d '$(SYSCONFDIR)'/systemd/system ]; then \
		install -m 0644 '$(RESOURCESDIR)'/systemd/hblock.service '$(SYSCONFDIR)'/systemd/system/hblock.service; \
		install -m 0644 '$(RESOURCESDIR)'/systemd/hblock.timer '$(SYSCONFDIR)'/systemd/system/hblock.timer; \
		'$(SYSTEMCTL)' daemon-reload; \
		'$(SYSTEMCTL)' enable hblock.timer; \
		'$(SYSTEMCTL)' start hblock.timer; \
	fi

##################################################
## "installcheck" target
##################################################
.PHONY: installcheck

installcheck:
	[ -x '$(BINDIR)'/hblock ] || exit 1
	[ -f '$(SYSCONFDIR)'/hosts ] || exit 1
	if [ -x '$(SYSTEMCTL)' ] && [ -d '$(SYSCONFDIR)'/systemd/system ]; then \
		[ -f '$(SYSCONFDIR)'/systemd/system/hblock.service ]; \
		[ -f '$(SYSCONFDIR)'/systemd/system/hblock.timer ]; \
	fi

##################################################
## "uninstall" target
##################################################
.PHONY: uninstall

uninstall:
	rm -f '$(BINDIR)'/hblock
	printf '%s\n' "$$DEFAULT_HOSTS" > '$(SYSCONFDIR)'/hosts
	if [ -x '$(SYSTEMCTL)' ] && [ -d '$(SYSCONFDIR)'/systemd/system ]; then \
		if [ -f '$(SYSCONFDIR)'/systemd/system/hblock.timer ]; then \
			'$(SYSTEMCTL)' stop hblock.timer; \
			'$(SYSTEMCTL)' disable hblock.timer; \
			rm -f '$(SYSCONFDIR)'/systemd/system/hblock.timer; \
		fi; \
		if [ -f '$(SYSCONFDIR)'/systemd/system/hblock.service ]; then \
			rm -f '$(SYSCONFDIR)'/systemd/system/hblock.service; \
		fi; \
		'$(SYSTEMCTL)' daemon-reload; \
	fi

##################################################
## "clean" target
##################################################
.PHONY: clean

clean:
	rm -f $(HOSTS) $(HOSTS_ALT_FORMATS) $(HOSTS_STATS) $(HOSTS_INDEX)
	if [ -d '$(DISTDIR)' ]; then rmdir '$(DISTDIR)'; fi
