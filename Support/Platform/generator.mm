#import <clang-c/Index.h>
#import <Foundation/Foundation.h>
#import <getopt.h>
#import <sysexits.h>
#import <stdio.h>
#import <string>
#import <regex>
#import <string.h>
#import <map>
#import <set>
#import <vector>
#import <algorithm>
#import <utility>
#import <errno.h>

static char const* const kAppVersion = "1.0";

#ifndef COMPILE_DATE
#define COMPILE_DATE "YYYY-MM-DD"
#endif

// Walks every declaration in the translation unit and hands each named one to the callback,
// with its availability on the given platform, `macos`, `ios`, `tvos`, `watchos` or `xros`, or null when the symbol says nothing about it.
static void visit (CXTranslationUnit tu, char const* platform, std::function<void(std::string const&, CXCursorKind, CXPlatformAvailability const*, std::string const&, CXCursor)> callback)
{
	std::set<CXCursorKind> const desiredCursorKinds = { CXCursor_StructDecl, CXCursor_EnumDecl, CXCursor_TypedefDecl, CXCursor_FunctionDecl, CXCursor_ObjCProtocolDecl, CXCursor_ObjCInterfaceDecl, CXCursor_VarDecl, CXCursor_EnumConstantDecl };
	clang_visitChildrenWithBlock(clang_getTranslationUnitCursor(tu), ^(CXCursor cursor, CXCursor parent){
		CXCursorKind kind = clang_getCursorKind(cursor);
		if(desiredCursorKinds.find(kind) == desiredCursorKinds.end())
			return CXChildVisit_Recurse;

		CXString name = clang_getCursorSpelling(cursor);
		std::string const symbol = clang_getCString(name);
		clang_disposeString(name);
		// clang spells an anonymous type as "(unnamed struct at …)" or "enum (unnamed at …)", which is not a name anyone types.
		if(symbol.empty() || symbol.front() == '_' || symbol.find_first_of(" (") != std::string::npos)
			return clang_getCursorKind(cursor) == CXCursor_EnumDecl ? CXChildVisit_Recurse : CXChildVisit_Continue;

		CXSourceRange range = clang_getCursorExtent(cursor);
		CXSourceLocation location = clang_getRangeStart(range);
		CXFile file;
		clang_getFileLocation(location, &file, nullptr, nullptr, nullptr);
		CXString filename = clang_getFileName(file);
		std::string const header = clang_getCString(filename) ?: "";
		clang_disposeString(filename);

		// clang_getCursorPlatformAvailability returns how many platforms the symbol names, not how many it wrote.
		// Current SDKs name more than the four of 2016, so the count is asked for first and the array sized to it.
		// Reading past a fixed array here is what made the Objective-C run on the macOS 27 SDK spin for twenty minutes without finishing.
		int n = clang_getCursorPlatformAvailability(cursor, nullptr, nullptr, nullptr, nullptr, nullptr, 0);
		std::vector<CXPlatformAvailability> availability(std::max(n, 0));
		if(n > 0)
			clang_getCursorPlatformAvailability(cursor, nullptr, nullptr, nullptr, nullptr, availability.data(), n);

		CXPlatformAvailability* available = nullptr;
		for(int i = 0; i < n && !available; ++i)
		{
			if(strcmp(platform, clang_getCString(availability[i].Platform)) == 0)
				available = &availability[i];
		}

		callback(symbol, kind, available, header, cursor);

		for(int i = 0; i < n; ++i)
			clang_disposeCXPlatformAvailability(&availability[i]);

		return clang_getCursorKind(cursor) == CXCursor_EnumDecl ? CXChildVisit_Recurse : CXChildVisit_Continue;
	});
}

template <typename _InputIter>
std::string strings_to_regexp (_InputIter first, _InputIter last)
{
	struct node_t
	{
		void add_string (std::string::const_iterator first, std::string::const_iterator last)
		{
			if(first == last)
			{
				_terminate = true;
			}
			else
			{
				auto it = _nodes.find(*first);
				if(it == _nodes.end())
					it = _nodes.emplace(*first, node_t()).first;
				it->second.add_string(++first, last);
			}
		}

		void to_s (std::string& out) const
		{
			if(_nodes.empty())
				return;

			out += _terminate || _nodes.size() > 1 ? "(?:" : "";
			bool first = true;
			for(auto const& pair : _nodes)
			{
				if(!std::exchange(first, false))
					out += '|';
				out += pair.first;
				pair.second.to_s(out);
			}
			out += _terminate ? ")?" : (_nodes.size() > 1 ? ")" : "");
		}

	private:
		std::map<char, node_t> _nodes;
		bool _terminate = false;
	};

	node_t n;
	for(auto it = first; it != last; ++it)
		n.add_string(it->begin(), it->end());

	std::string res;
	n.to_s(res);
	return res;
}

// One rule for a whole group of scopes: every scope's alternation becomes a capture group, and the captures name the scopes.
// The grammar engine tries each rule against each line, so the cost of a grammar grows with its rule count, not its symbol count.
// A thousand scopes as a thousand rules is a thousand scans per line, as one rule it is one scan.
// `prefix` opens the match before the groups and `captures` receives any capture that prefix defines.
static NSDictionary* merged_rule (std::map<std::string, std::set<std::string>> const& groups, NSString* prefix, NSMutableDictionary* captures)
{
	NSMutableString* match = [NSMutableString stringWithFormat:@"%@\\b(?:", prefix];
	NSUInteger index = captures.count;
	bool first = true;
	for(auto const& pair : groups)
	{
		if(!std::exchange(first, false))
			[match appendString:@"|"];
		[match appendFormat:@"(%@)", @(strings_to_regexp(pair.second.begin(), pair.second.end()).c_str())];
		captures[[NSString stringWithFormat:@"%lu", (unsigned long)++index]] = @{ @"name" : @(pair.first.c_str()) };
	}
	[match appendString:@")\\b"];
	return @{ @"match" : match, @"captures" : captures };
}

// Writes the three merged rules into the grammar: one for functions, one for protocols and one for everything else.
static BOOL update_grammar (NSString* grammarPath, std::map<std::string, std::set<std::string>> const& functions, std::map<std::string, std::set<std::string>> const& protocols, std::map<std::string, std::set<std::string>> const& other, NSString* comment)
{
	NSMutableArray* patternRules  = [NSMutableArray new];
	NSMutableArray* functionRules = [NSMutableArray new];
	NSMutableArray* protocolRules = [NSMutableArray new];

	NSMutableDictionary* functionCaptures = [NSMutableDictionary dictionaryWithDictionary:@{ @"1" : @{ @"name" : @"punctuation.whitespace.support.function.leading" } }];
	if(!functions.empty())
		[functionRules addObject:merged_rule(functions, @"(\\s*)", functionCaptures)];
	if(!protocols.empty())
		[protocolRules addObject:merged_rule(protocols, @"", [NSMutableDictionary new])];
	if(!other.empty())
		[patternRules addObject:merged_rule(other, @"", [NSMutableDictionary new])];

	if(NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:grammarPath])
	{
		plist[@"comment"] = comment ?: @"Generated";
		plist[@"patterns"] = patternRules;
		NSMutableDictionary* repos = [NSMutableDictionary dictionaryWithDictionary:@{
			@"functions" : @{ @"patterns" : functionRules },
		}];
		if(protocolRules.count)
			repos[@"protocols"] = @{ @"patterns" : protocolRules };
		plist[@"repository"] = repos;
		return [plist writeToFile:grammarPath atomically:YES];
	}
	return NO;
}

static void update_summary (char const* summaryPath, std::map<std::string, std::set<std::string>> const& functions, std::map<std::string, std::set<std::string>> const& protocols, std::map<std::string, std::set<std::string>> const& other, NSString* comment)
{
	std::map<std::string, std::map<std::string, std::set<std::string>> const&> const types =
	{
		{ "Functions", functions },
		{ "Protocols", protocols },
		{ "Other",     other     },
	};

	if(FILE* fp = fopen(summaryPath, "w"))
	{
		if(comment)
			fprintf(fp, "%s\n\n", [comment UTF8String]);

		for(auto const& type : types)
		{
			if(type.second.empty())
				continue;

			fprintf(fp, "# %s\n", type.first.c_str());
			for(auto const& pair : type.second)
			{
				fprintf(fp, "\n## %s\n\n", pair.first.c_str());
				for(auto const& function : pair.second)
					fprintf(fp, "- `%s`\n", function.c_str());
			}
			fprintf(fp, "\n");
		}
		fclose(fp);
	}
}

// The scope segment for a header no table entry names, derived from its framework.
// `…/CoreData.framework/Headers/NSManagedObject.h` gives `.core-data`, the innermost framework when they nest.
// A header outside any framework, /usr/include and the like, gives no segment.
static std::string framework_segment (std::string const& header)
{
	static std::regex const pattern("([^/]+)\\.framework/");
	std::string name;
	for(std::sregex_iterator it(header.begin(), header.end(), pattern), last; it != last; ++it)
		name = (*it)[1];
	if(name.empty())
		return "";

	// CoreData to core-data, AVFoundation to av-foundation, IOKit to io-kit: a hyphen where lower case meets upper case, and before the last capital of a run that starts a word.
	std::string segment = ".";
	for(size_t i = 0; i < name.size(); ++i)
	{
		bool const upper = isupper(name[i]);
		bool const previousLower = i > 0 && islower(name[i-1]);
		bool const nextLower = i + 1 < name.size() && islower(name[i+1]);
		bool const previousUpper = i > 0 && isupper(name[i-1]);
		if(upper && i > 0 && (previousLower || (previousUpper && nextLower)))
			segment += '-';
		segment += tolower(name[i]);
	}
	return segment;
}

// Parses a source file and returns its translation unit, or null after printing every error.
// A header that fails to parse leaves its symbols out of the grammar with no other sign, so any error is fatal.
static CXTranslationUnit parse (CXIndex index, char const* sourcePath, std::vector<char const*> const& args)
{
	CXTranslationUnit tu = clang_parseTranslationUnit(index, sourcePath, args.data(), (int)args.size(), nullptr, 0, CXTranslationUnit_None);
	if(!tu)
	{
		fprintf(stderr, "%s: unable to parse %s\n", getprogname(), sourcePath);
		return nullptr;
	}

	unsigned errors = 0;
	for(unsigned i = 0, n = clang_getNumDiagnostics(tu); i < n; ++i)
	{
		CXDiagnostic diagnostic = clang_getDiagnostic(tu, i);
		if(clang_getDiagnosticSeverity(diagnostic) >= CXDiagnostic_Error)
		{
			CXString text = clang_formatDiagnostic(diagnostic, clang_defaultDiagnosticDisplayOptions());
			fprintf(stderr, "%s\n", clang_getCString(text));
			clang_disposeString(text);
			++errors;
		}
		clang_disposeDiagnostic(diagnostic);
	}

	if(errors)
	{
		fprintf(stderr, "%s: %u error%s parsing %s, nothing written\n", getprogname(), errors, errors == 1 ? "" : "s", sourcePath);
		clang_disposeTranslationUnit(tu);
		return nullptr;
	}

	return tu;
}

static void version (FILE* io)
{
	fprintf(io, "%1$s %2$s (" COMPILE_DATE ")\n", getprogname(), kAppVersion);
}

static void usage (FILE* io)
{
	version(io);
	fprintf(io,
		"Usage: %1$s [-o<file>t<file>s<file>s<suffix>chv] source\n"
		"\n"
		"Options:\n"
		" -o, --grammar      The tmGrammar file to generate/update.\n"
		" -t, --text         Write all symbols to this file in a readable format.\n"
		" -S, --sdk          Path to an SDK. Repeat for every platform, with a --platform and a --target for each, in the same order.\n"
		" -p, --platform     The platform's name in availability attributes: macos, ios, tvos, watchos or xros.\n"
		" -T, --target       The target triple to parse the SDK as, such as arm64-apple-ios.\n"
		" -r, --resource-dir Path to clang's resource directory, which holds its own headers such as stdarg.h.\n"
		" -x, --c-source     The C source whose headers belong to the C grammar and are left out of this one.\n"
		" -s, --suffix       Suffix to append to scopes, e.g. `.objc`.\n"
		" -c, --cocoa        Generate grammar for Objective-C frameworks.\n"
		" -h, --help         Show this information.\n"
		" -v, --version      Print version information.\n"
		"\n", getprogname());
}

int main (int argc, char const* argv[])
{
	extern char* optarg;
	extern int optind;
	extern int optreset;

	static struct option const longopts[] = {
		{ "grammar",          required_argument,   0,      'o'   },
		{ "text",             required_argument,   0,      't'   },
		{ "sdk",              required_argument,   0,      'S'   },
		{ "platform",         required_argument,   0,      'p'   },
		{ "target",           required_argument,   0,      'T'   },
		{ "resource-dir",     required_argument,   0,      'r'   },
		{ "c-source",         required_argument,   0,      'x'   },
		{ "suffix",           required_argument,   0,      's'   },
		{ "cocoa",            no_argument,         0,      'c'   },
		{ "help",             no_argument,         0,      'h'   },
		{ "version",          no_argument,         0,      'v'   },
		{ 0,                  0,                   0,      0     }
	};

	char const* grammarPath = nullptr;
	char const* textPath    = nullptr;
	std::vector<char const*> sdkPaths;
	std::vector<char const*> platforms;
	std::vector<char const*> targets;
	char const* resourceDir = nullptr;
	char const* cSourcePath = nullptr;
	char const* suffix      = nullptr;
	bool isObjectiveC       = false;

	int ch;
	while((ch = getopt_long(argc, (char**)argv, "o:t:S:p:T:r:x:s:chv", longopts, NULL)) != -1)
	{
		switch(ch)
		{
			case 'o': grammarPath = optarg;      break;
			case 't': textPath = optarg;         break;
			case 'S': sdkPaths.push_back(optarg);  break;
			case 'p': platforms.push_back(optarg); break;
			case 'T': targets.push_back(optarg);   break;
			case 'r': resourceDir = optarg;      break;
			case 'x': cSourcePath = optarg;      break;
			case 's': suffix = optarg;           break;
			case 'c': isObjectiveC = true;       break;
			case 'h': usage(stdout);        return EX_OK;
			case 'v': version(stdout);      return EX_OK;
			case '?': /* unknown option */  return EX_USAGE;
			case ':': /* missing option */  return EX_USAGE;
			default:  usage(stderr);        return EX_USAGE;
		}
	}

	argc -= optind;
	argv += optind;

	if(argc != 1)
	{
		fprintf(stderr, "%s: Wrong number of argumetns, expected 1 but got %d\n", getprogname(), argc);
		return EX_USAGE;
	}

	char const* sourcePath = argv[0];

	// There is no default SDK: a baked in path names one release and is wrong on the next.
	// The Makefile asks xcrun for each platform's, and names the platform and target beside it.
	if(sdkPaths.empty())
	{
		fprintf(stderr, "%s: --sdk is required, once per platform\n", getprogname());
		usage(stderr);
		return EX_USAGE;
	}

	if(platforms.size() != sdkPaths.size() || targets.size() != sdkPaths.size())
	{
		fprintf(stderr, "%s: every --sdk needs a --platform and a --target, in the same order: %zu SDKs, %zu platforms, %zu targets\n", getprogname(), sdkPaths.size(), platforms.size(), targets.size());
		return EX_USAGE;
	}

	if(access(sourcePath, R_OK) != 0)
	{
		perror("error reading source");
		return EX_USAGE;
	}

	for(char const* sdkPath : sdkPaths)
	{
		if(access(sdkPath, R_OK) != 0)
		{
			fprintf(stderr, "%s: error reading SDK %s: %s\n", getprogname(), sdkPath, strerror(errno));
			return EX_USAGE;
		}
	}

	std::map<CXCursorKind, char const*> cursorTypes =
	{
		{ CXCursor_StructDecl,        "support.type"           },
		{ CXCursor_EnumDecl,          "support.type"           },
		{ CXCursor_TypedefDecl,       "support.type"           },
		{ CXCursor_FunctionDecl,      "support.function"       },
		{ CXCursor_VarDecl,           "support.variable"       },
		{ CXCursor_EnumConstantDecl,  "support.constant"       },
		{ CXCursor_ObjCProtocolDecl,  "support.other.protocol" },
		{ CXCursor_ObjCInterfaceDecl, "support.class"          },
	};

	struct { bool objC; std::string scope; std::regex pattern; } const headerTypes[] =
	{
		{ false, ".clib",         std::regex(".*/(alloca|ctype|_?locale|math|_?select|setjmp|signal|stdarg|stddef|stdint|_?stdio|stdlib|string|strings|time|types|unistd|sys/(fcntl|resource|select|types|wait)|_types/.*)\\.h$") },
		{ false, ".pthread",      std::regex(".*/_?pthread(/.*|\\.h)")           },
		{ false, ".os",           std::regex(".*/(OSByteOrder|gethostuuid)\\.h") },
		{ false, ".dispatch",     std::regex(".*/dispatch/.*")                   },
		{ false, ".quartz",       std::regex(".*/CoreGraphics\\.framework/.*")   },
		{ false, ".mac-classic",  std::regex(".*/MacTypes\\.h")                  },
		{ false, ".cf",           std::regex(".*/CoreFoundation\\.framework/.*") },
		{ true,  ".run-time",     std::regex(".*?/objc/(?:objc|runtime|NSObjCRuntime).h") },
		{ true,  ".cocoa",        std::regex(".*?/(?:AddressBook|AppKit|ExceptionHandling|Foundation|UserNotifications|WebKit)\\.framework/(?!.*\\.framework/).*") },
		// Everything else the includes reach, Core Services, Security, IOKit and the rest of what the frameworks above pull in.
		// These get the bare scope with no framework segment, so they are colored as library symbols without saying which library.
		// A person's code uses these names as much as the named frameworks', and a grammar that stops coloring them is a regression.
		{ false, "",              std::regex(".*") },
		{ true,  "",              std::regex(".*") },
	};

	std::map<std::string, std::set<std::string>> functions;
	std::map<std::string, std::set<std::string>> protocols;
	std::map<std::string, std::set<std::string>> other;

	if(isObjectiveC)
	{
		other = {
			{ "storage.type.objc",       { "instancetype" } },
			{ "storage.type.cocoa.objc", { "IBOutlet", "IBAction", "IBInspectable", "IB_DESIGNABLE" } } // NSNibDeclarations.h
		};
	}

	// The union over every SDK.
	// A symbol is keyed by its kind's scope and its name, so a name that is a function on one platform and a type on another stays two entries.
	// Each entry records its framework segment from the first SDK that declared it, macOS first, so a name that moved frameworks between platforms has one scope.
	// It also records the platforms it exists on and the platforms it is deprecated on.
	struct symbol_t
	{
		CXCursorKind kind;
		std::string segment;
		std::vector<std::string> platforms;
		std::set<std::string> deprecatedOn;
	};
	std::map<std::pair<std::string, std::string>, symbol_t> symbols;

	CXIndex index = clang_createIndex(0, 0);
	NSMutableArray* sdkNames = [NSMutableArray new];

	for(size_t i = 0; i < sdkPaths.size(); ++i)
	{
		char const* sdkPath  = sdkPaths[i];
		char const* platform = platforms[i];
		[sdkNames addObject:[@(sdkPath) lastPathComponent]];

		// The target triple matters as much as the SDK.
		// Without it clang assumes the host, and Foundation on the iOS SDK imports a macOS only header and fails.
		std::vector<char const*> cArgs = { "--sysroot", sdkPath, "-target", targets[i] };

		// libclang looks for clang's own headers, stdarg.h and the like, relative to its own library.
		// Homebrew's keg does not resolve that way, so the caller says where they are.
		if(resourceDir)
		{
			cArgs.push_back("-resource-dir");
			cArgs.push_back(resourceDir);
		}

		// clang picks the language from the extension: includes.c is C and includes.mm is Objective-C++.
		// A C++ standard is an error for a C file, so the C++ flags only go with the Objective-C run.
		std::vector<char const*> args = cArgs;
		if(isObjectiveC)
		{
			args.push_back("-std=c++1y");
			args.push_back("-stdlib=libc++");
		}

		CXTranslationUnit tu = parse(index, sourcePath, args);
		if(!tu)
			return EX_DATAERR;

		// The Objective-C grammar includes the C grammar, so every header the C source reaches belongs to the C run.
		// The C source is parsed here only to learn which headers those are on this SDK.
		std::set<std::string> cHeaders;
		if(cSourcePath)
		{
			CXTranslationUnit cTu = parse(index, cSourcePath, cArgs);
			if(!cTu)
				return EX_DATAERR;
			visit(cTu, platform, [&](std::string const&, CXCursorKind, CXPlatformAvailability const*, std::string const& header, CXCursor){
				cHeaders.insert(header);
			});
			clang_disposeTranslationUnit(cTu);
		}

		visit(tu, platform, [&](std::string const& symbol, CXCursorKind kind, CXPlatformAvailability const* available, std::string const& header, CXCursor cursor){
			// A header the C run owns is skipped here, or the catch-all would copy the whole C grammar into this one.
			if(cHeaders.count(header))
				return;

			// A header can declare a symbol and mark it unavailable on the platform being parsed, UIWebView on visionOS say.
			// That symbol does not exist on this platform, so it is not recorded as existing here, and its deprecation elsewhere stands.
			if(available && available->Unavailable)
				return;

			for(auto const& match : headerTypes)
			{
				if(isObjectiveC != match.objC || !std::regex_match(header, match.pattern))
					continue;

				symbol_t& entry = symbols[{ cursorTypes[kind], symbol }];
				entry.kind = kind;
				if(entry.segment.empty())
					entry.segment = match.scope.empty() ? framework_segment(header) : match.scope;
				if(std::find(entry.platforms.begin(), entry.platforms.end(), platform) == entry.platforms.end())
					entry.platforms.push_back(platform);

				// Apple deprecated the whole of OpenGL in 10.14 and of OpenGL ES in iOS 12, and still ships both.
				// Marking every one of their symbols would turn working OpenGL code red, so neither is ever marked deprecated.
				// Apple's API_TO_BE_DEPRECATED, a deprecation with no version, counts: clang reports it as version 100000.
				bool const deprecated = available && available->Deprecated.Major > 0 && header.find("/OpenGL.framework/") == std::string::npos && header.find("/OpenGLES.framework/") == std::string::npos;
				if(deprecated)
					entry.deprecatedOn.insert(platform);

				break;
			}
		});

		clang_disposeTranslationUnit(tu);
	}

	// A symbol is deprecated when it is deprecated on every platform that has it, and current while any platform still wants it.
	// A theme cannot know which platform a file targets, so the grammar does not pretend to.
	// The scope carries no version: 12.0 is a different year on iOS and on macOS, and each distinct version would cost a capture group.
	for(auto const& pair : symbols)
	{
		std::string const& name = pair.first.second;
		symbol_t const& entry = pair.second;
		std::string scope = pair.first.first + entry.segment;

		if(!entry.deprecatedOn.empty() && entry.deprecatedOn.size() == entry.platforms.size())
			scope = "invalid.deprecated." + scope;

		if(suffix)
			scope += suffix;

		if(entry.kind == CXCursor_FunctionDecl)
			functions[scope].insert(name);
		else if(entry.kind == CXCursor_ObjCProtocolDecl)
			protocols[scope].insert(name);
		else
			other[scope].insert(name);
	}

	NSString* comment = [NSString stringWithFormat:@"This file was generated with clang-C using %@", [sdkNames componentsJoinedByString:@", "]];
	if(grammarPath && !update_grammar(@(grammarPath), functions, protocols, other, comment))
	{
		fprintf(stderr, "%s: error updating %s\n", getprogname(), grammarPath);
		return EX_IOERR;
	}

	if(textPath)
		update_summary(textPath, functions, protocols, other, comment);

	return EX_OK;
}
