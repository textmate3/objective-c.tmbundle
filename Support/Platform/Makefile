# Builds the generator and regenerates Platform.tmLanguage and Platform.md
# in the C and Objective-C bundles. See README.md beside this file.

# Everything is located from where this Makefile sits.
# This directory is Support/Platform inside objective-c.tmbundle,
# and c.tmbundle is expected beside that bundle's checkout.
# Either bundle can be pointed elsewhere: make C_BUNDLE=... OBJC_BUNDLE=...
here        := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OBJC_BUNDLE ?= $(abspath $(here)../..)
C_BUNDLE    ?= $(abspath $(OBJC_BUNDLE)/../c.tmbundle)

# libclang and its headers come from Homebrew's llvm, listed in the Brewfile beside this file.
# Apple's toolchain ships the clang compiler but not libclang.
# Homebrew answers with the prefix whether or not llvm is installed, so the llvm target checks for the library.
LLVM ?= $(shell brew --prefix llvm 2>/dev/null)

# clang's own headers, stdarg.h and the like, live in its resource directory.
# libclang does not find them on its own from inside the keg, so the generator is told where they are.
RESOURCE_DIR=$(shell $(LLVM)/bin/clang -print-resource-dir 2>/dev/null)

SDK=$(shell xcrun --sdk macosx --show-sdk-path)
BUILD_DATE=$(shell date +%Y-%m-%d)
CC=xcrun clang
CFLAGS=-Os -Wall -std=c++1y -lc++ --sysroot $(SDK) -DCOMPILE_DATE=\"$(BUILD_DATE)\" -framework Foundation -I$(LLVM)/include -L$(LLVM)/lib -lclang

C_PATH=$(C_BUNDLE)/Syntaxes/Platform
OBJC_PATH=$(OBJC_BUNDLE)/Syntaxes/Platform

# The shape of the grammar, chosen by measurement, see README.md.
# A scope segment per framework, one rule per group of scopes so highlighting stays fast,
# and no introduced-in version on scopes, which halves the capture groups and is what makes the segments affordable.
SHAPE=--framework-segments --merge-rules --without-introduced-versions

all: c objective-c

c: generator bundles
	./generator --sdk=$(SDK) --resource-dir='$(RESOURCE_DIR)' $(SHAPE) --grammar='$(C_PATH).tmLanguage' --text='$(C_PATH).md' --suffix='.c' includes.c

objective-c: generator bundles
	./generator --sdk=$(SDK) --resource-dir='$(RESOURCE_DIR)' $(SHAPE) --grammar='$(OBJC_PATH).tmLanguage' --text='$(OBJC_PATH).md' --suffix='.objc' --cocoa --c-source=includes.c includes.mm

generator: generator.mm Makefile llvm
	@$(CC) $(CFLAGS) -o $@ $<

llvm:
	@test -e '$(LLVM)/lib/libclang.dylib' || { echo "libclang not found under $(LLVM). Install llvm from the Brewfile beside this Makefile: brew bundle --file='$(here)Brewfile'" >&2; exit 1; }

bundles:
	@test -d '$(OBJC_BUNDLE)/Syntaxes' || { echo "objective-c.tmbundle not found at $(OBJC_BUNDLE). Pass OBJC_BUNDLE=path" >&2; exit 1; }
	@test -d '$(C_BUNDLE)/Syntaxes' || { echo "c.tmbundle not found at $(C_BUNDLE). Clone it beside objective-c.tmbundle or pass C_BUNDLE=path" >&2; exit 1; }

.PHONY: all c objective-c llvm bundles
