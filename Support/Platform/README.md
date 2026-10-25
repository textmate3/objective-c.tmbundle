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

We parse either `includes.c` or `includes.mm` (based on the `--cocoa` flag) using clang’s C interface.

Once the file has been parsed we traverse the parse tree and harvest enumerations, functions, variable declarations, etc.

For each symbol we check the path of the file path (from where the symbol came) against a list of regular expressions, this determines how to name the scope, and also means that if the file is not matched by any of our regular expressions, the symbol is left out.

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
