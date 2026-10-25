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

We parse either `includes.c` or `includes.mm` (based on the `--cocoa` flag) using clang’s C interface. Those two files are the whole universe: a symbol can only enter a grammar if a header reachable from their imports declares it, so adding a framework means adding its import there.

Once the file has been parsed we traverse the parse tree and harvest enumerations, functions, variable declarations, etc.

For each symbol we check the path of the file path (from where the symbol came) against a list of regular expressions, this determines how to name the scope. A header matched by none of them still gets a scope: with `--framework-segments` the segment is derived from the framework, `support.class.core-data.objc` for a Core Data class, and without it the scope is the bare `support.class.objc`. Either way everything the imports reach is highlighted.

## The shape of the grammar, and why

The grammar engine tries every rule of a grammar against every line, so what a grammar costs is its rule count, not its symbol count, and after that the number of capture groups a rule carries. The Makefile passes three flags that follow from measuring that with `gtm`, the grammar test tool that ships with TextMate, on a 370 KB Objective-C sample:

- `--merge-rules` writes one rule per group of scopes, with each scope's alternation as a capture group, instead of one rule per scope. Two thousand rules became three, and the same symbols get the same scopes.
- `--framework-segments` gives every framework its own scope segment. Each segment multiplies the groups, which is affordable once the rules are merged.
- `--without-introduced-versions` drops the `.10.12` style suffix that said which macOS a symbol arrived in. Those suffixes were two thirds of the groups and cost more than they say. Deprecation scopes keep their version, since a theme can act on `invalid.deprecated`.

With all three, the grammars cover every framework in the SDK and highlight at the speed of the 2020 grammars, which covered a tenth of it.

The Objective-C grammar includes the C grammar, so the Objective-C run is also given `includes.c` through `--c-source`, and leaves out every header that file reaches. Each symbol lands in one grammar.

Symbols deprecated in some macOS version get `invalid.deprecated.<version>` in front of their scope, and `invalid.deprecated.tba` when Apple has marked them for deprecation with no version. Symbols introduced after 10.7 get the version appended. OpenGL is the one exception: Apple deprecated all of it in 10.14 and still ships it, so it is never marked deprecated.

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
