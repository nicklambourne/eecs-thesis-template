# (Unofficial) UQ ITEE Undergraduate Thesis Template

## Why?

Having been forced to write not one but two undergraduate theses
at UQ as part of studying software engineering and then transferring 
into computer science, I figured I'd take what I learnt the first 
time around and share it with my peers. This also takes a lot of the 
lessons I've learnt in ~3 years of working in industry and applies them to an academic context. I'm hoping it can serve as an 
introduction to some interesting tooling for inquisitive students 
approaching the end of their undergraduate studies.

The 
[semi-official template](http://itee.uq.edu.au/files/20609/itee-thesis-template_tex.txt)
 is also a mess of barely relevant custom macros. 
 Where possible I've drawn from marking / criteria sheets and 
 official literature to provide (limited) guidance as to what's 
 expected for each section, but this is not a UQ/ITEE-provided or sponsored document, use at your own discretion.

## What's Included?
This Bazel monorepo includes several components:
- A LaTeX template for the "proposal" assessment item.
- A LaTeX template for the final thesis document.
- Bazel-based tooling for building both documents 
- A hermetic (self-contained) Bazel toolchain for building and 
running Python-based projects. Bazel supports pretty much any 
language through plugins called "rules". Of course, you can ignore 
the Bazel component and write Python any old way, though I'd suggest 
giving it a go.
- A Nix/direnv setup to ensure any command line tools you need are
provided.
- GitHub actions that will automatically build the proposal and 
thesis documents when changes are made to the source (on the master 
branch).

## Overleaf Compatible
Bazel not your thing? Local builds a bit slow? You can write both 
documents using Overleaf with no code changes. You can import the 
project into [Overleaf](https://www.overleaf.com/) via their GitHub 
integration, then choosing either `proposal/main.tex` or 
`thesis/main.tex` as the "Main Document" in the settings menu.

## Setup
You can use as little or as much of the tooling as you please, but 
for MacOS and Debian-based Linux users the setup can be nearly 
entirely automated.

```bash
git clone https://github.com/nicklambourne/itee-thesis-template.git
cd itee-thesis-template
# This attempts to install Nix and direnv if they're not already 
# available (Nix via an install script, direnv via brew or apt)
./tools/setup/setup.sh
cd ..  # We need to exit and renter the directory to trigger direnv
cd itee-thesis-template
direnv allow # This will trigger the Nix environment (sadly not 
# pure)
bazel sync # This downloads the requisite Bazel tooling
```

Once the toolchains are set up, the first thing you'll want to do 
is head to `common/tex/globals.tex` and fill in your name, student 
number, supervisor etc. These values will then be used to populate 
both documents.

## Building Docs Locally
To build the proposal document, run the following Bazel command:
```bash
bazel build //:proposal
```

Similarly, for the thesis document:
```bash
bazel build //:thesis
```

The rendered PDF documents will be available in a directory 
called `bazel-bin` at the root of the project.

## Running the Python Project
```bash
bazel run //:main
```

## FAQ
### How Do I Add Additional Python Dependencies
Add your new requirement to `tools/build/python/requirements.in`, 
then run the script to translate that file into the 
`requirements.txt`. This process uses a handy project called 
[pip-tools](https://github.com/jazzband/pip-tools).

```bash
./tools/build/python/build.sh
```

Bazel refers to this `requirements.txt` to fetch packages from the 
Python Package Index (PyPI). 

You'll also need to add the requirement to the dependencies for 
your Bazel target (`//:main`) in `BUILD.bazel`:

```starlark
...
PY_DEPS = [
    requirement("loguru"),
    requirement("mypy"),
    requirement("pytest"),
    requirement("your_dep"),
]


py_binary(
    name = "main",
    srcs = glob(["src/**/*.py"]),
    deps = PY_DEPS,
)
...
```

### How Do I Add Additional LaTeX Dependencies?
This one is tricker because `bazel-latex` is very much a niche 
project, but they've done a pretty neat job of making packages 
available in a Bazel-friendly way. 

If you know you need a particular package or getting 
`*.sty file not found errors`, look first in this 
[file](https://github.com/ProdriveTechnologies/bazel-latex/blob/v1.2.1/packages/BUILD.bazel) 
where the authors have explicitly defined commonly used packages 
in Bazel-native format (note that only the ones labelled 
`latex_package` and not the ones labelled `file_group` will be 
available to you). You can then add the package directly to 
`TEX_DEPS` in the `BUILD.bazel` file:

```starlark
TEX_DEPS = [
...
"@bazel_latex//packages:<insert_package_name>",
...
]
```

If it's not included there, things get a bit harder, but certainly 
not impossible. The `bazel-latex` have created a modular copy of 
TeXLive, the most common (and very comprehensive) TeX distribution.

Unfortunately, this distribution doesn't come with a manifest, so 
while you can fetch individual packages you may have to go digging to 
find them.

You'll want to pull the TeXLive tarball (~3.4GB):
```
wget http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2022/texlive-20220321-texmf.tar.xz
tar -xf texlive-20220321-texmf.tar.xz
```

Then you can go hunting. Most of the packages you'll want will be 
contained in `texmf/texmf-dist/tex/latex` or 
`texmf/texmf-dist/tex/generic`. Once you know where it is you can 
take the relative path, replace the slashes with double underscores 
(`__`) and append the result to the end of `@texlive_` and you'll 
have your package name, e.g.:

```starlark
TEX_DEPS = [
    ...
    "@texlive_texmf__texmf-dist__tex__latex__mathtools",
    ...
]
```

I found [CTAN](https://ctan.org/) (when the site's up, at least) to 
be a valuable resource for working out which packages belonged to 
which bundles.

Of course, TeXLive (and others) come out of the box with Overleaf 
so you can always say "to hell with this" and just use their web 
editor (of course this will break the GitHub Actions, but you can 
always export the PDF from Overleaf :shrug:).

### I'm Not Using Python For My Thesis, How Do?
[Java](https://bazel.build/versions/6.1.0/reference/be/java?hl=en) 
and 
[C++](https://bazel.build/versions/6.1.0/reference/be/c-cpp?hl=en) 
are supported natively, other languages are supported via rule sets 
(plugins), most of which are community-maintained (and of varying 
levels of quality). See a full list 
[here](https://github.com/jin/awesome-bazel).

I can't promise I'll have the time to help you set up other 
languages, but I'll provide what support I can.

If you do get another language toolchain working, please send 
through a PR so others can benefit as well.

### Uh, ackchyually...?
Have I missed something? (almost certainly) Made an error? (probably) 
Or perhaps you have a suggestion for how the template could be 
improved? All PRs and suggestions are welcome! Filing an issue is 
almost as welcome, but I will try to address issues promptly when 
they come up.

## Shout Outs
- Prodrive Technologies B.V., authors of 
[`bazel-latex`](https://github.com/ProdriveTechnologies/bazel-latex).
- The [`rules_python`](https://github.com/bazelbuild/rules_python) 
maintainers who do the best they can with such a flawed language.
- Google, for sharing the frustrating joy that is 
[Bazel](https://bazel.build/).
- The admin staff of ITEE (who didn't contribute to this project 
directly, but do amazing work under trying conditions to make the 
many, many ITEE thesis programs possible). :heart: