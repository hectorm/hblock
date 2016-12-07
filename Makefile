#!/usr/bin/make -f

RESOURCES_DIR:=$(CURDIR)/resources
PUBLIC_DIR:=$(CURDIR)/public
TEMP_DIR:=$(shell mktemp -dt 'hblock.XXXXXXXX')

HBLOCK_SCRIPT:=$(CURDIR)/hblock
STATS_SCRIPT:=$(RESOURCES_DIR)/stats/suffix.sh
TEMPLATE_SCRIPT:=$(RESOURCES_DIR)/templates/index.sh

.PHONY: DEFAULT all \
	build build-hosts build-gz build-android build-windows \
	stats stats-tlds stats-suffixes \
	index \
	clean

DEFAULT: all

all: clean build stats index

build: build-hosts build-gz build-android build-windows

build-hosts:
	mkdir -p "$(PUBLIC_DIR)"
	"$(HBLOCK_SCRIPT)" -O "$(PUBLIC_DIR)"/hosts

build-gz: build-hosts
	gzip -c "$(PUBLIC_DIR)"/hosts > "$(PUBLIC_DIR)"/hosts.gz

build-android: build-hosts
	mkdir -p "$(TEMP_DIR)"/android
	cp -r "$(RESOURCES_DIR)"/android/* "$(PUBLIC_DIR)"/hosts "$(TEMP_DIR)"/android
	cd "$(TEMP_DIR)"/android && zip -r "$(PUBLIC_DIR)"/hosts_android.zip .

build-windows: build-hosts
	mkdir -p "$(TEMP_DIR)"/windows
	cp -r "$(RESOURCES_DIR)"/windows/* "$(PUBLIC_DIR)"/hosts "$(TEMP_DIR)"/windows
	unix2dos "$(TEMP_DIR)"/windows/install.bat "$(TEMP_DIR)"/windows/hosts
	cd "$(TEMP_DIR)"/windows && zip -r "$(PUBLIC_DIR)"/hosts_windows.zip .

stats: stats-tlds stats-suffixes

stats-tlds: build-hosts
	"$(STATS_SCRIPT)" "$(PUBLIC_DIR)"/hosts none > "$(PUBLIC_DIR)"/most_abused_tlds.txt

stats-suffixes: build-hosts
	"$(STATS_SCRIPT)" "$(PUBLIC_DIR)"/hosts > "$(PUBLIC_DIR)"/most_abused_suffixes.txt

index: build-hosts
	"$(TEMPLATE_SCRIPT)" "$(PUBLIC_DIR)" > "$(PUBLIC_DIR)"/index.html

clean:
	rm -rf "$(PUBLIC_DIR)"

