#!/usr/bin/make -f

SHELL := /bin/sh

DESTDIR :=
PREFIX := $(DESTDIR)/usr/local
BINDIR := $(PREFIX)/bin
SYSCONFDIR := $(DESTDIR)/etc

SYSTEMCTL := $(shell which systemctl 2>/dev/null)

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

.PHONY: all
all: build

.PHONY: release
release:
	$(MAKE) clean
	$(MAKE) build stats
	$(MAKE) index

.PHONY: build
build: $(HOSTS) $(HOSTS_ALT_FORMATS)

$(DISTDIR):
	mkdir -p '$(DISTDIR)'

$(HOSTS): | $(DISTDIR)
	'$(HBLOCK)' -O '$(HOSTS)'

$(HOSTS)_%: $(RESOURCESDIR)/alt-formats/%.sh $(HOSTS)
	'$<' '$(HOSTS)' '$(HBLOCK)' '$(RESOURCESDIR)' > '$@'

.PHONY: stats
stats: $(HOSTS_STATS)

$(DISTDIR)/most_abused_tlds.txt: $(DISTDIR)/hosts_domains.txt
	'$(RESOURCESDIR)'/stats/suffix.sh '$(DISTDIR)'/hosts_domains.txt none > '$@'

$(DISTDIR)/most_abused_suffixes.txt: $(DISTDIR)/hosts_domains.txt
	'$(RESOURCESDIR)'/stats/suffix.sh '$(DISTDIR)'/hosts_domains.txt > '$@'

.PHONY: index
index: $(HOSTS_INDEX)

%/index.html: $(filter-out index %/index.html,$(MAKECMDGOALS))
	'$(RESOURCESDIR)'/templates/index.sh "$$(dirname '$@')" > '$@'

.PHONY: logo
logo:
	'$(RESOURCESDIR)'/logo/rasterize.sh

.PHONY: install
install: $(HOSTS)
	mkdir -p '$(PREFIX)' '$(BINDIR)' '$(SYSCONFDIR)'
	install -m 0644 '$(HOSTS)' '$(SYSCONFDIR)'/hosts
	install -m 0755 '$(HBLOCK)' '$(BINDIR)'/hblock
	set -eu; \
	if [ -x '$(SYSTEMCTL)' ] && [ -d '$(SYSCONFDIR)'/systemd/system ]; then \
		install -m 0644 '$(RESOURCESDIR)'/systemd/hblock.service '$(SYSCONFDIR)'/systemd/system/hblock.service; \
		install -m 0644 '$(RESOURCESDIR)'/systemd/hblock.timer '$(SYSCONFDIR)'/systemd/system/hblock.timer; \
		'$(SYSTEMCTL)' daemon-reload; \
		'$(SYSTEMCTL)' enable hblock.timer; \
		'$(SYSTEMCTL)' start hblock.timer; \
	fi

.PHONY: installcheck
installcheck:
	[ -f '$(SYSCONFDIR)'/hosts ]
	[ -x '$(BINDIR)'/hblock ]
	set -eu; \
	if [ -x '$(SYSTEMCTL)' ] && [ -d '$(SYSCONFDIR)'/systemd/system ]; then \
		[ -f '$(SYSCONFDIR)'/systemd/system/hblock.service ]; \
		[ -f '$(SYSCONFDIR)'/systemd/system/hblock.timer ]; \
	fi

.PHONY: uninstall
uninstall:
	rm -f '$(BINDIR)'/hblock
	printf '%s\n' "$$DEFAULT_HOSTS" > '$(SYSCONFDIR)'/hosts
	set -eu; \
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

.PHONY: clean
clean:
	rm -f $(HOSTS) $(HOSTS_ALT_FORMATS) $(HOSTS_STATS) $(HOSTS_INDEX)
	if [ -d '$(DISTDIR)' ]; then rmdir '$(DISTDIR)'; fi
