# Build automation Makefile for the cello package
#
# Copyright © 2024 Red Hat, Inc.
# Copyright © 2024 林博仁(Buo-ren Lin) <buo.ren.lin@gmail.com>
# SPDX-License-Identifier: CC-BY-SA-3.0
PREFIX=/usr
INSTALL=install

cello:
	gcc -g -o cello cello.c
clean:
	rm cello
install: cello
	$(INSTALL) -d "$(DESTDIR)$(PREFIX)/bin"
	$(INSTALL) cello "$(DESTDIR)$(PREFIX)/bin/cello"
uninstall:
	rm -f "$(DESTDIR)$(PREFIX)/bin/cello"
