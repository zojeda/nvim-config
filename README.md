# Neovim config

A Neovim setup that behaves like VS Code: explorer sidebar with git status, file tabs, fuzzy search, language servers with completion, and a review-and-commit flow with side-by-side diffs. Markdown opens rendered.

Every shortcut is on one printable page: [cheatsheet.pdf](cheatsheet.pdf). Inside Neovim, press `Space` and wait to see them.

## Install

```bash
git clone https://github.com/zojeda/nvim-config.git ~/.config/nvim
nvim
```

On a machine with an SSH key on GitHub, `git clone git@github.com:zojeda/nvim-config.git ~/.config/nvim` works too and lets you push changes back.

The first start installs the plugin manager, plugins, syntax parsers and language servers. It takes a few minutes. On native Windows the folder is `%LOCALAPPDATA%\nvim`.

## Requirements

| Needed | Why |
|---|---|
| Neovim 0.11.x | Built-in language-server setup; the syntax plugin is pinned to its 0.11 branch |
| `git`, a C compiler, `make` | Installing plugins and compiling syntax parsers |
| `ripgrep` | Search in files |
| `fd` (or `fdfind`) | Go to file; falls back to ripgrep |
| Node.js | TypeScript language server |
| A Nerd Font in the terminal | File-type icons |

On a device without a Nerd Font, add `export NVIM_NERD_FONT=0` to the shell profile and the config switches to plain symbols.

## Keeping devices in sync

```bash
git pull          # get config changes
```

Plugin versions are pinned in `lazy-lock.json`. After `:Lazy update` on one device, commit that file; on the others, pull and run `:Lazy restore`.

## Layout

| Path | Contents |
|---|---|
| `init.lua` | Entry point |
| `lua/config/` | Options, general shortcuts, plugin manager bootstrap |
| `lua/plugins/ui.lua` | Theme, tabs, status bar, shortcut hints |
| `lua/plugins/explorer.lua` | Sidebar |
| `lua/plugins/navigation.lua` | Search |
| `lua/plugins/git.lua` | Change markers, review, source control |
| `lua/plugins/code.lua` | Syntax, language servers, completion |
| `lua/plugins/markdown.lua` | Markdown preview |
| `cheatsheet.html` | Source of the cheatsheet PDF |
