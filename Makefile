#!/usr/bin/make -f

MKFILE_RELPATH=$(shell printf -- '%s' "$(MAKEFILE_LIST)" | sed 's|^\ ||')
MKFILE_ABSPATH=$(shell readlink -f -- '$(MKFILE_RELPATH)')
MKFILE_DIR=$(shell dirname -- '$(MKFILE_ABSPATH)')
WORK_DIR=$(shell pwd)

.PHONY: all \
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
	cd "$(MKFILE_DIR)"/resources/android/ && zip -r "$(WORK_DIR)"/dist/hosts_android.zip ./
	cd dist/ && zip -r hosts_android.zip hosts

build-windows: build-hosts dist/hosts_windows.zip
dist/hosts_windows.zip:
	cd "$(MKFILE_DIR)"/resources/windows/ && zip -rl "$(WORK_DIR)"/dist/hosts_windows.zip ./
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

clean:
	rm -f dist/hosts \
		dist/hosts.gz \
		dist/hosts_android.zip \
		dist/hosts_windows.zip \
		dist/most_abused_tlds.txt \
		dist/most_abused_suffixes.txt \
		dist/index.html
	-rmdir dist/
