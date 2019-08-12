# Lemon Slicer

- https://github.com/tajmone/lemon-slicer

A standalone binary de-amalgamator to split the [Lemon parser generator] into multiple source files.

Created by [Tristano Ajmone] on August 12, 2019. MIT License.

    Lemon Slicer v1.0.0 | PureBasic 5.70 LTS


-----

**Table of Contents**


<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3,4" -->

- [Project Files](#project-files)
- [TLTR: What Does It Do?](#tltr-what-does-it-do)
- [What Is All This About?](#what-is-all-this-about)
- [About Lemon Slicer](#about-lemon-slicer)
    - [Usage Instructions](#usage-instructions)
    - [License](#license)
- [External Links](#external-links)

<!-- /MarkdownTOC -->

-----

# Project Files

- [`lemon-slicer.pb`][slicer.pb] — Lemon Slicer source (PureBasic).
- `lemon-slicer.exe` — precompiled Lemon Slicer binary (x64).
- [`lemon.c`][lemon.c] — Lemon amalgamated source (for testing). [From SQLite][us lemon], check-in [2da0eea0]  (2019-06-03)
- [`lempar.c`][lempar.c] — Lemon template (for testing). [From SQLite][us lempar], check-in [9e664585]  (2019-07-16)
- [`LICENSE`][LICENSE] — MIT License.

# TLTR: What Does It Do?

Lemon Slicer takes the source files "`lemon.c`" and "`lempar.c`" from the current folder, copies them into the "`/sliced/`" destination folder, and splits the amalgamated contents of "`lemon.c`" across the following files:

- `action.c`
- `build.c`
- `build.h`
- `configlist.c`
- `configlist.h`
- `error.c`
- `error.h`
- `lemon.c`
- `main.c`
- `msort.c`
- `option.c`
- `option.h`
- `parse.c`
- `parse.h`
- `plink.c`
- `plink.h`
- `report.c`
- `report.h`
- `set.c`
- `set.h`
- `struct.h`
- `table.c`
- `table.h`

Finally, it injects at the end of the left-over contents of the "`lemon.c`" file all the required `#include` directives to ensure that the split contents are loaded back in the correct order, so that the Lemon parser remains buildable by compiling "`lemon.c`".

The "`lempar.c`" template file is copied over to the destination folder untouched, for it's not an amalgamated file.

# What Is All This About?

Lemon Slicer was created as a maintainance tool for the [Lemon Grove] project, which hosts the source files of the [Lemon parser generator]:

- [`lemon.c`][lemon.c] — Lemon source (amalgamated).
- [`lempar.c`][lempar.c] — Lemon template.


The Lemon source file `lemon.c`, like most tools from the [SQLite] project, is created by merging multiple C sources into a single file via a technique called "amalgamation", in order to reduce the number of file dependencies and improve performance (5-10% speed gain).
Except that today only the single source file of Lemon survives in the SQLite project — and all updates to its code are done directly in that amalgamated single source file.

I wanted to include in the __[Lemon Grove]__ project a split version of the Lemon source files, to simplify studying its code and working on derivative versions and ports.
Reversing the amalgamation is not a hard task in itself, for the amalgamator adds some comment lines indicating the name of the original file from which the code was taken:

```c
void Configlist_reset(void);

/********* From the file "error.h" ***************************************/
void ErrorMsg(const char *, int,const char *, ...);

/****** From the file "option.h" ******************************************/
enum option_type { OPT_FLAG=1,  OPT_INT,  OPT_DBL,  OPT_STR,
         OPT_FFLAG, OPT_FINT, OPT_FDBL, OPT_FSTR};
```

So splitting the file manually is neither a huge nor hard task.
The problem is that in the __[Lemon Grove]__ project I need to keep the split sources always up to date with the unsplit sources, which are updated quite often on the [SQLite repository].
Therefore, I needed to create a small tool to automate this task, so that whenever I update the Lemon sources I can easily update their split version in a single click — so I created the __Lemon Slicer__ tool.

# About Lemon Slicer

- [`lemon-slicer.pb`][slicer.pb] — Lemon Slicer source (PureBasic).
- `lemon-slicer.exe` — precompiled Lemon Slicer binary (64-bits).

__Lemon Slicer__ is written in [PureBasic] and compiles as a single-file console application, no dependencies whatsoever.
It can be compiled for Windows, Linux and macOS, targeting either 32- or 64-bits, although it was tested only on Windows so far.

Because PureBasic is a commercial tool, I've included a precompiled 64-bits binary in the repository itself — which also simplifies its integration in the [Lemon Grove] project (for which it was created) since it can be easily downloaded/updated via [cURL]  ([now included in Windows 10]).

## Usage Instructions

Lemon Slicer must be executed in a folder containing the (amalgamated) __[Lemon]__ source files "`lemon.c`" and "`lempar.c`", otherwise it will fail.
Just double click on `lemon-slicer.exe`, or invoke it from the command line, and the tool will work its magic in a matter of seconds.

It will create an output folder named "`/sliced/`", with all the de-amalgamated files from "`lemon.c`", plus "`lempar.c`" (which is just copied as is).

> **IMPORTANT!** — At each execution, Lemon Slicer will delete every "`*.c`" and "`*.h`" file inside the "`/sliced/`" folder, before creating the new split files!
> This was enforced to ensure a clean output at each run.
> Files with other extensions won't be affected, but avoid using the output folder as a storage for important files. 

Before exiting, Lemon Slicer will print a brief report on how many files were created from splitting "`lemon.c`", or an error message (and exit code 1) in case something went wrong.

Since the task at hand is quite straightforward, there are no options switches.
Source files locations and destination folder are hardcoded into the application, for they mirror the needs of the Lemon Grove project — but these can easily be tweaked in the source code, if you need to.

## License

- [`LICENSE`][LICENSE]

Lemon Slicer is released under the MIT License:

```
MIT License

Copyright (c) 2019 Tristano Ajmone <tajmone@gmail.com>
https://github.com/tajmone/lemon-slicer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

When distributing Lemon Slicer in compiled binary form, you must also include the full [`LICENSE`][LICENSE] file found in this project, for the executable file contains third party components which must also be credited and licensed.

# External Links

- [PureBasic]
- [Lemon homepage]
- [Lemon Grove] — a project built around the Lemon parser.
- [The SQLite Amalgamation] — for more info about amalgamation.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[now included in Windows 10]: https://devblogs.microsoft.com/commandline/tar-and-curl-come-to-windows/ "Read MS Blog announcement about cURL being added to tools included with Windows 10"

<!-- project files -->

[LICENSE]: ./LICENSE "View the MIT License of the project"
[lemon.c]: ./lemon.c "View Lemon amalgamated source file"
[lempar.c]: ./lempar.c "View Lemon template source file"
[slicer.pb]: ./lemon-slicer.pb "View Lemon Slicer source file"

<!-- external references -->

[LALR(1)]: https://en.wikipedia.org/wiki/LALR_parser "See Wikipedia page on LALR parser"
[parser generator]: https://en.wikipedia.org/wiki/Compiler-compiler "See Wikipedia page on Compiler-compiler"

<!-- Lemon -->

[Lemon]: http://www.hwaci.com/sw/lemon/ "Visit the official Lemon homepage"
[Lemon homepage]: http://www.hwaci.com/sw/lemon/ "Visit the official Lemon homepage"
[Lemon parser generator]: http://www.hwaci.com/sw/lemon/ "Visit the official Lemon homepage"
[Lemon documentation]: https://sqlite.org/src/doc/trunk/doc/lemon.html "Read the official Lemon documentation"
[Lemon on Wikipedia]: https://en.wikipedia.org/wiki/Lemon_Parser_Generator "Read the Wikepida page for Lemon Parser Generator"
[Lemon Grove]: https://github.com/tajmone/lemon-grove "Visit the Lemon Grove repository on GitHub"

<!-- Lemon upstream sources & check-ins -->

[us lemon]: https://www.sqlite.org/src/file/tool/lemon.c "View upstream source file"
[2da0eea0]: https://www.sqlite.org/src/info/2da0eea02d128c37 "View upstream check-in"

[us lempar]: https://www.sqlite.org/src/file/tool/lempar.c "View upstream source file"
[9e664585]: https://www.sqlite.org/src/info/9e66458592d40fbd "View upstream check-in"

<!-- SQLite -->

[SQLite]: http://www.sqlite.org/ "Visit SQLite website"
[SQLite repository]: https://sqlite.org/src/doc/trunk/README.md "Visit the SQLite source repository"
[The SQLite Amalgamation]: https://www.sqlite.org/amalgamation.html "Learn about amalgamation in the SQLite project"

<!-- PureBasic -->

[PureBasic]: https://www.purebasic.com "Visit the PureBasic website"

<!-- 3rd party tools -->

[cURL]: https://curl.haxx.se/ "Visit cURL website"

<!-- people -->

[Tristano Ajmone]: https://github.com/tajmone "View Tristano Ajmone's GitHub profile"

<!-- EOF -->
