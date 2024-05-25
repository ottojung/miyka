
PREFIX=/usr/local
PREFIX_BIN=$(PREFIX)/bin
PREFIX_SHARE=$(PREFIX)/share

INSTALL_ROOT=$(PREFIX_SHARE)/miyka/root
BINARY_PATH=$(PREFIX_BIN)/miyka
CODE_INSTALL_ROOT=$(PREFIX_SHARE)/miyka/src
CODE_ROOT=$(PWD)/src

SUBMODULES = dependencies/euphrates/.git

all: dist/miyka

install: $(BINARY_PATH)

uninstall:
	rm -f $(BINARY_PATH)
	rm -rf $(CODE_INSTALL_ROOT)
	rmdir $(INSTALL_ROOT) || true
	rmdir $(PREFIX_SHARE)/miyka || true

build: dist/miyka
	dist/miyka --version 1>/dev/null

dist/miyka: $(SUBMODULES) src/*/*.scm
	mkdir -p "dist"
	guile -s scripts/make-binary.scm "$(CODE_ROOT)" > "$@"
	chmod +x "$@"

$(BINARY_PATH): dist/miyka $(PREFIX_BIN)
	mkdir -p "$(INSTALL_ROOT)"
	chown "$(USER):" "$(INSTALL_ROOT)" || true
	mkdir -p "$(CODE_INSTALL_ROOT)"
	rm -rf "$(CODE_INSTALL_ROOT)"
	cp -p -T -L -r "src" "$(CODE_INSTALL_ROOT)"
	guile -s scripts/make-binary.scm "$(CODE_INSTALL_ROOT)" > "$@"
	chmod +x "$@"
	miyka --version 1>/dev/null

test: build
	sh scripts/run-tests.sh

test-files:
	$(MAKE) -f tests/setup.make test-files-all

$(SUBMODULES):
	git submodule update --init

.PHONY: all build install uninstall test
