PROG ?= paste
PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
MANDIR ?= $(PREFIX)/share/man

SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions

BASHCOMPDIR ?= $(PREFIX)/share/bash-completion/completions
ZSHCOMPDIR ?= $(PREFIX)/share/zsh/site-functions

all:
	@echo "pass-$(PROG) is a shell script and does not need compilation, it can be simply executed."
	@echo ""
	@echo "To install it try \"make install\" instead."
	@echo

install:
	@install -vd "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/" "$(DESTDIR)$(BASHCOMPDIR)"
	@install -vm 0755 $(PROG).bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash"
	@install -vm 0644 "pass-$(PROG).bash" "$(DESTDIR)$(BASHCOMPDIR)/pass-$(PROG)"
	@echo
	@echo "pass-$(PROG) is installed succesfully"
	@echo "Hint: You may need to ensure that the completion file is sourced at shell invocation"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/$(PROG).bash" \
		"$(DESTDIR)$(BASHCOMPDIR)/pass-$(PROG)"


COVERAGE ?= false
TMP ?= /tmp/pass-$(PROG)
PASS_TEST_OPTS ?= --verbose --immediate --chain-lint --root=/tmp/sharness
T = $(sort $(wildcard tests/*.sh))
export COVERAGE TMP

tests: $(T)
	@tests/results

$(T):
	@$@ $(PASS_TEST_OPTS)

lint:
	shellcheck --shell=bash $(PROG).bash tests/commons tests/results

clean:
	@rm -vrf debian/.debhelper debian/debhelper* debian/pass-extension-import* \
		tests/test-results/ tests/gnupg/random_seed

.PHONY: install uninstall tests $(T) lint clean
