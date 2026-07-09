# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when
working with code in this repository.

## Overview

`rc.vim` is a personal Vim plugin by `@diacus` — it is **not** a
runnable application. It ships Vim options, key mappings, filetype
tweaks, and helper commands that activate when the plugin is
loaded. There is no build step, no linter, and no automated test
suite; correctness is validated by loading the plugin in Vim and
exercising the relevant command or mapping.

## Repository layout

The plugin follows standard Vim plugin conventions:

- `plugin/` — files loaded once at startup. Defines the user-facing
  mappings, autocommands, and `:` commands. Filenames match a single
  feature (e.g. `writing.vim`, `kb.vim`, `tags.vim`, `spelling.vim`).
- `autoload/` — functions are namespaced by filename
  (`autoload/config.vim` exposes `config#*`). Plugins call into these
  from `plugin/`, `ftplugin/`, and `after/`.
- `ftplugin/` — filetype-scoped settings, key maps, and `:`
  commands. Loaded automatically by Vim based on `&filetype`. Heavy
  logic lives in the matching `autoload/<lang>.vim`.
- `after/plugin/` and `after/ftplugin/` — overrides that run after the
  user's own `~/.vimrc`, so they win against user
  configuration. Currently holds `transparent.vim` and `nfo.vim`.
- `syntax/` — syntax files outside Vim's runtime. Currently only
  `tdl.vim` for TODO-list files.
- `doc/rc.txt` — Vim help source. The file uses standard `*tag*`
  markers, so the full mapping / variable / command surface is
  documented there. **Read `doc/rc.txt` before adding or renaming a
  public mapping, variable, or command.**
- `tools/` — external helper scripts that are *not* part of the Vim
  plugin and are not auto-loaded:
  - `tools/make/markdown.mk` — include from a Makefile to convert
    `*.md` → `*.html` (pandoc + sed) → `*.wp` (perl).
  - `tools/wp/compiler` — Perl script, used as a stdin filter, that
    converts standard HTML into WordPress shortcode form. Documented
    inline.
  - `tools/css/markdown.css` — referenced by the makefile.
  - `tools/sh/mackbl` — macOS helper that prints the current keyboard
    layout name from `com.apple.HIToolbox.plist`.

## Configuration conventions

- A feature is typically split three ways: a thin
  `plugin/<feature>.vim` (mappings, autocommands, `command!`
  declarations) → a `autoload/<feature>.vim` with the actual functions
  → optionally an `ftplugin/<feature>.vim` for filetype-specific
  versions. Follow that pattern when adding a new feature so plugin
  loading stays cheap.
- The leading `g:` variables documented in `doc/rc.txt`
  (`g:use_bpython`, `g:use_ipython`, `g:netrw_style`,
  `g:split_resize`, `g:kb_layout`) are the user-facing knobs. Add new
  ones with the same comment style and register them in `doc/rc.txt`.
- `kb.vim` guards itself via `kb#should_load()` so it is a no-op when
  `g:kb_layout` is unset — copy that guard pattern for any feature
  that depends on user configuration.
- The `SplitsResize` `augroup` in `plugin/config.vim` is cleared and
  redefined at load time (`autocmd!` before re-registering); do the
  same for any new augroup to avoid duplicate autocmds on `:source`.

## Working with the plugin

- Install: per `README.md`, install with a plugin manager (e.g. `Plug
  'diacus/rc.vim'`). For local development, point the plugin manager
  at the checkout (e.g. `Plug '~/Projects/rc.vim'`).
- Help: `:help rc.vim` once installed — generated from `doc/rc.txt`.
- Local artifacts (`.swp` files and a `tags` file from ctags) are
  git-ignored; the repo does not commit them.

## Build pipeline (tools/)

The markdown → WordPress pipeline is independent of Vim. It is invoked from a user-level Makefile that includes `tools/make/markdown.mk`. Targets:

- `make html` — `pandoc` converts `*.md` to `*.html` (with `markdown.css`, justified paragraphs, blank-target links).
- `make wp` — pipes each `*.html` through `tools/wp/compiler` to produce `*.wp` (WordPress shortcodes for code blocks, captions, etc.).
- `make clean` — removes generated `*.html` and `*.wp`.

The compiler's input/output format and special comment markers (`<!--lang-start:LANG-->` … `<!--lang-end-->`, `[![][]][]` caption syntax) are documented inline in `tools/wp/compiler`. Update the makefile in lockstep if the compiler's expected input changes.
