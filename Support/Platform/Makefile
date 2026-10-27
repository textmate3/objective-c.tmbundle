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

# The grammars are the union over every Apple platform, since a .m file does not say which one it targets.
# Each entry is the SDK's name for xcrun, the platform's name in availability attributes, and the target triple to parse it as.
# Every SDK ships inside Xcode, so none has to be installed separately.
PLATFORMS=macosx:macos:arm64-apple-macos iphoneos:ios:arm64-apple-ios appletvos:tvos:arm64-apple-tvos watchos:watchos:arm64-apple-watchos xros:xros:arm64-apple-xros
sdk_name=$(word 1,$(subst :, ,$(1)))
sdk_platform=$(word 2,$(subst :, ,$(1)))
sdk_target=$(word 3,$(subst :, ,$(1)))
sdk_path=$(shell xcrun --sdk $(call sdk_name,$(1)) --show-sdk-path 2>/dev/null)
SDKS=$(foreach p,$(PLATFORMS),--sdk='$(call sdk_path,$(p))' --platform=$(call sdk_platform,$(p)) --target=$(call sdk_target,$(p)))

all: c objective-c

c: generator bundles sdks
	./generator $(SDKS) --resource-dir='$(RESOURCE_DIR)' --grammar='$(C_PATH).tmLanguage' --text='$(C_PATH).md' --suffix='.c' includes.c

objective-c: generator bundles sdks
	./generator $(SDKS) --resource-dir='$(RESOURCE_DIR)' --grammar='$(OBJC_PATH).tmLanguage' --text='$(OBJC_PATH).md' --suffix='.objc' --cocoa --c-source=includes.c includes.mm

sdks:
	@$(foreach p,$(PLATFORMS),test -d '$(call sdk_path,$(p))' || { echo "No SDK for $(call sdk_name,$(p)): xcrun --sdk $(call sdk_name,$(p)) --show-sdk-path found nothing. Every platform SDK ships inside Xcode, so check xcode-select -p names the Xcode you mean" >&2; exit 1; };)

generator: generator.mm Makefile llvm
	@$(CC) $(CFLAGS) -o $@ $<

llvm:
	@test -e '$(LLVM)/lib/libclang.dylib' || { echo "libclang not found under $(LLVM). Install llvm from the Brewfile beside this Makefile: brew bundle --file='$(here)Brewfile'" >&2; exit 1; }

bundles:
	@test -d '$(OBJC_BUNDLE)/Syntaxes' || { echo "objective-c.tmbundle not found at $(OBJC_BUNDLE). Pass OBJC_BUNDLE=path" >&2; exit 1; }
	@test -d '$(C_BUNDLE)/Syntaxes' || { echo "c.tmbundle not found at $(C_BUNDLE). Clone it beside objective-c.tmbundle or pass C_BUNDLE=path" >&2; exit 1; }

.PHONY: all c objective-c llvm bundles sdks
