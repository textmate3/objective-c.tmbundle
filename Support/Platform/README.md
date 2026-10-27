The code in this directory is used to generate `Platform.tmLanguage`.

It requires `libclang` and the clang C includes, which Apple's toolchain does not ship. The `Brewfile` in this directory lists them:

	brew bundle --file=Brewfile

There is a `Makefile` which builds the `generator` executable and will also update `Platform.tmLanguage` and `Platform.md` in the C and Objective-C bundles.

The Makefile finds everything from its own location. This directory is `Support/Platform` inside `objective-c.tmbundle`, and `c.tmbundle` is expected to be checked out beside it, so a layout like this needs no configuration:

	bundles/
	  c.tmbundle/
	  objective-c.tmbundle/

Either bundle can be somewhere else, and libclang can come from somewhere other than Homebrew:

	make C_BUNDLE=/path/to/c.tmbundle OBJC_BUNDLE=/path/to/objective-c.tmbundle LLVM=/path/to/llvm

`make` refuses with a message naming what is missing when libclang or a bundle is not where it expects.

## How it Works

We parse either `includes.c` or `includes.mm` (based on the `--cocoa` flag) using clang’s C interface, once per SDK. Those two files are the whole universe: a symbol can only enter a grammar if a header reachable from their imports declares it, so adding a framework means adding its import there. Each import is guarded with `__has_include`, so a framework a platform lacks is skipped on that platform, and a few carry a `TARGET_OS_` condition where Apple's own headers do not parse on one platform.

## Every Apple platform

The grammars are the union over the macOS, iOS, tvOS, watchOS and visionOS SDKs, because a `.m` file does not say which platform it targets and a person with a Mac app and an iPhone app open wants both colored. The Makefile lists the platforms, asks `xcrun` for each SDK, and hands the generator one `--sdk`, `--platform` and `--target` per platform. Every SDK ships inside Xcode, so nothing is installed separately, and `make` refuses by name when one is missing.

Two rules make the union more than a sum:

- A symbol is deprecated when it is deprecated on every platform that has it, and current while any platform still wants it. A theme cannot know which platform a file targets, so the grammar does not pretend to.
- A symbol marked unavailable on a platform is treated as absent there, so `UIWebView`, deprecated on iOS and unavailable on visionOS, is deprecated. A symbol unavailable everywhere it is declared is left out.

A name keeps the framework segment of the first SDK that declared it, macOS first, so a name that moved frameworks between platforms has one scope. There are no versions on scopes, neither introduced-in nor deprecated-in: `12.0` is a different year on iOS and on macOS, so a version from one platform's numbering says nothing on another, and each distinct version costs a capture group. Deprecated symbols are `invalid.deprecated.<scope>`, which is what themes act on.

Once the file has been parsed we traverse the parse tree and harvest enumerations, functions, variable declarations, etc.

For each symbol we check the path of the file path (from where the symbol came) against a list of regular expressions, this determines how to name the scope. A header matched by none of them still gets a scope: with `--framework-segments` the segment is derived from the framework, `support.class.core-data.objc` for a Core Data class, and without it the scope is the bare `support.class.objc`. Either way everything the imports reach is highlighted.

## The shape of the grammar, and why

The grammar engine tries every rule of a grammar against every line, so what a grammar costs is its rule count, not its symbol count, and after that the number of capture groups a rule carries. The Makefile passes three flags that follow from measuring that with `gtm`, the grammar test tool that ships with TextMate, on a 370 KB Objective-C sample:

- `--merge-rules` writes one rule per group of scopes, with each scope's alternation as a capture group, instead of one rule per scope. Two thousand rules became three, and the same symbols get the same scopes.
- `--framework-segments` gives every framework its own scope segment. Each segment multiplies the groups, which is affordable once the rules are merged.
- `--without-deprecation-versions` marks a deprecated symbol `invalid.deprecated` with no version, so every deprecation of a kind in a framework shares one group instead of one per version per platform.

With all three, the grammars cover every framework on every platform and highlight at the speed of the 2020 grammars, which covered a tenth of one platform.

The Objective-C grammar includes the C grammar, so the Objective-C run is also given `includes.c` through `--c-source`, and leaves out every header that file reaches. Each symbol lands in one grammar.

Deprecated symbols get `invalid.deprecated` in front of their scope. OpenGL and OpenGL ES are the exceptions: Apple deprecated all of both and still ships them, so neither is ever marked deprecated.

Here is an excerpt from the table:

```c
struct { bool objC; std::string scope; std::regex pattern; } const headerTypes[] =
{
	{ false, ".pthread",     std::regex(".*/_?pthread(/.*|\\.h)")                    },
	{ false, ".dispatch",    std::regex(".*/dispatch/.*")                            },
	{ false, ".quartz",      std::regex(".*/CoreGraphics\\.framework/.*")            },
	{ false, ".mac-classic", std::regex(".*/MacTypes\\.h")                           },
	{ false, ".cf",          std::regex(".*/CoreFoundation\\.framework/.*")          },
	{ true,  ".run-time",    std::regex(".*?/objc/(?:objc|runtime|NSObjCRuntime).h") },
	⋮
};
```

If you want to add more symbols to the generated `Platform.tmLanguage` file then you need to edit this table and you may also need to add new include statements to one or both of the `includes.{c,mm}` files.
