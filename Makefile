#!/usr/bin/make -f

.PHONY: all \
	build build-hosts build-gz build-android build-windows \
	stats stats-tlds stats-suffixes \
	index \
	clean clean-tmp clean-dist

all: build

build: build-hosts build-gz build-android build-windows

build-hosts: dist/hosts
dist/hosts:
	mkdir -p dist
	./hblock -O dist/hosts

build-gz: build-hosts dist/hosts.gz
dist/hosts.gz:
	gzip -c dist/hosts > dist/hosts.gz

build-android: build-hosts dist/hosts_android.zip
dist/hosts_android.zip: clean-tmp
	mkdir -p "$(CURDIR)"/.tmp/hosts_android && \
	cd "$(CURDIR)"/.tmp/hosts_android && \
	cp -r "$(CURDIR)"/resources/android/* "$(CURDIR)"/dist/hosts . && \
	zip -r "$(CURDIR)"/dist/hosts_android.zip .

build-windows: build-hosts dist/hosts_windows.zip
dist/hosts_windows.zip: clean-tmp
	mkdir -p "$(CURDIR)"/.tmp/hosts_windows && \
	cd "$(CURDIR)"/.tmp/hosts_windows && \
	cp -r "$(CURDIR)"/resources/windows/* "$(CURDIR)"/dist/hosts . && \
	unix2dos install.bat hosts && \
	zip -r "$(CURDIR)"/dist/hosts_windows.zip .

stats: stats-tlds stats-suffixes

stats-tlds: build-hosts dist/most_abused_tlds.txt
dist/most_abused_tlds.txt:
	./resources/stats/suffix.sh dist/hosts none > dist/most_abused_tlds.txt

stats-suffixes: build-hosts dist/most_abused_suffixes.txt
dist/most_abused_suffixes.txt:
	./resources/stats/suffix.sh dist/hosts > dist/most_abused_suffixes.txt

index: build-hosts dist/index.html
dist/index.html:
	./resources/templates/index.sh dist > dist/index.html

clean: clean-tmp clean-dist
clean-tmp:
	rm -rf .tmp
clean-dist:
	rm -f dist/hosts \
		dist/hosts.gz \
		dist/hosts_android.zip \
		dist/hosts_windows.zip \
		dist/most_abused_tlds.txt \
		dist/most_abused_suffixes.txt \
		dist/index.html
	-rmdir dist
