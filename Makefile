# Basic make variables.

CC	= cc
INSTALL	= /usr/bin/install -c -s
MKDIR_P	= /usr/bin/mkdir -p

PREFIX	= /usr/local
BINDIR	= $(PREFIX)/bin
MANDIR	= $(PREFIX)/man

CFLAGS	= -g -O2 -Wall -I. -I$(PROTODIR) -flto -lwayland-client -lxkbcommon  # -std=c99 -pedantic -D_POSIX_C_SOURCE=200112L

CONFIG	= config.c
CFILES	= drwm.c layout.c bindings.c $(CONFIG) $(PROTOC)
HFILES	= drwm.h $(PROTOH)
PROTODIR = ./protocol


# Generated file variables.

PROTOS	= $(PROTODIR)/river-layer-shell-v1.xml $(PROTODIR)/river-window-management-v1.xml $(PROTODIR)/river-xkb-bindings-v1.xml \
	  $(PROTODIR)/river-xkb-config-v1.xml $(PROTODIR)/river-libinput-config-v1.xml $(PROTODIR)/river-input-management-v1.xml
PROTOC	= $(PROTOS:.xml=.c)
PROTOH	= $(PROTOS:.xml=.h)


# Manual targets that you would actually want to call.

drwm	: $(CFILES) $(HFILES)
	$(CC) -o drwm $(CFLAGS) $(CFILES)

clean	:
	rm -f drwm $(PROTOC) $(PROTOH)

install	: drwm
	$(MKDIR_P) $(BINDIR)
	$(INSTALL) drwm $(BINDIR)
	$(MKDIR_P) $(MANDIR)/man1
	cp doc/drwm.1 $(MANDIR)/man1
	chmod 644 $(MANDIR)/man1/drwm.1

.PHONY	: clean


# XML file conversion.

.SUFFIXES: .xml .c .h

.xml.c	:
	wayland-scanner private-code $< $@

.xml.h	:
	wayland-scanner client-header $< $@
