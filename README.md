# Neovim config

A Neovim setup that behaves like VS Code: explorer sidebar with git status, file tabs, fuzzy search, language servers with completion, and a review-and-commit flow with side-by-side diffs. Markdown opens rendered.

Every shortcut is listed in [docs/cheatsheet.md](docs/cheatsheet.md), with a printable one-page version in [docs/cheatsheet.pdf](docs/cheatsheet.pdf). Inside Neovim, press `Space` and wait to see them.

## Install

```bash
git clone https://github.com/zojeda/nvim-config.git ~/.config/nvim
nvim
```

On a machine with an SSH key on GitHub, `git clone git@github.com:zojeda/nvim-config.git ~/.config/nvim` works too and lets you push changes back.

The first start installs the plugin manager, plugins, syntax parsers and language servers. It takes a few minutes. On native Windows the folder is `%LOCALAPPDATA%\nvim`.

On Linux, one command does the whole setup without root, including Neovim itself when it is missing or older than 0.11:

```bash
curl -fsSL https://raw.githubusercontent.com/zojeda/nvim-config/main/install.sh | sh
```

It installs into `~/.local` and `~/.config/nvim`, and is safe to run again.

## Dev containers

`bin/dev-nvim` opens Neovim inside the dev container of the current project, so language servers, git and search run against the container's tools. It needs Docker and the `devcontainer` CLI on the host.

```bash
ln -s ~/.config/nvim/bin/dev-nvim ~/.local/bin/dev-nvim   # once
cd my-project && dev-nvim                                  # or: dev-nvim <worktree>
```

It starts the container if needed, copies this config into the remote user's home, runs `install.sh` there, and opens Neovim at the workspace folder.

- The first run in a container takes about a minute; later runs start in seconds.
- The container's copy mirrors the host config and is replaced on every launch, so edit the config on the host.
- Everything lands in the remote user's home, so a rebuilt container installs again on the next launch.
- Copying to the system clipboard goes through the terminal (OSC 52); paste with the terminal's own shortcut.

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
| `docs/cheatsheet.md` | Every shortcut, by task |
| `docs/cheatsheet.pdf` | The same on one printable page |
| `docs/cheatsheet.html` | Source of both; `docs/build.py` regenerates the Markdown |
| `install.sh` | Installer for Linux machines and dev containers |
| `bin/dev-nvim` | Opens Neovim inside a project's dev container |
