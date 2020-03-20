.POSIX:
.SUFFIXES:

GO ?= go
RM ?= rm
SCDOC ?= scdoc

REV ?= $(shell git rev-parse --short HEAD)
VERSION ?= $(shell git describe --tags --long)

GO_LDFLAGS := ${GO_LDFLAGS}
GO_LDFLAGS += -X main.date=$(shell date -u -I) -X main.commit=$(REV) -X main.version=$(VERSION)
GOFLAGS := ${GOFLAGS}
GOFLAGS += -ldflags '$(GO_LDFLAGS)'

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man

all: porcelain porcelain.1

porcelain:
	$(GO) build $(GOFLAGS)

porcelain.1: porcelain.1.scd
	$(SCDOC) < $< >$@

clean:
	$(RM) porcelain porcelain.1
install: all
	mkdir -p $(DESTDIR)$(BINDIR)
	mkdir -p $(DESTDIR)$(MANDIR)/man1
	cp -f porcelain $(BINDIR)
	cp -f porcelain.1 $(MANDIR)/man1
