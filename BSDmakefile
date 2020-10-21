#!/usr/bin/make -f

SHELL := /bin/sh

# PMake might add -J (private).
FLAGS := ${.MAKEFLAGS:C/\-J ([0-9]+,?)+//W}

all: .DEFAULT

.DEFAULT:
	@command -v gmake >/dev/null 2>&1 || \
		{ printf '%s\n' \
			"GMake is required to build hBlock." \
			"Install it and try again." >&2 \
		&& exit 1; }
	@gmake ${.FLAGS} ${.TARGETS}
