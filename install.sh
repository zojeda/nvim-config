#!/bin/sh
# Sets up this Neovim config on a Linux machine or dev container without root:
# everything goes under ~/.local and ~/.config/nvim. Safe to run again.
#
#   curl -fsSL https://raw.githubusercontent.com/zojeda/nvim-config/main/install.sh | sh
#
# It is also picked up as a dev container dotfiles installer:
#   devcontainer up --dotfiles-repository https://github.com/zojeda/nvim-config.git \
#                   --dotfiles-target-path '~/.config/nvim'
set -eu

NVIM_VERSION=0.11.6 # the config targets the 0.11 series
RG_VERSION=15.2.0
FD_VERSION=10.5.0
REPO=https://github.com/zojeda/nvim-config.git

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
BIN="$HOME/.local/bin"
OPT="$HOME/.local/opt"

have() { command -v "$1" >/dev/null 2>&1; }
say() { printf 'nvim-config: %s\n' "$*"; }
fetch() { if have curl; then curl -fsSL "$1"; else wget -qO- "$1"; fi; }

[ "$(uname -s)" = Linux ] || { say "this installer supports Linux only"; exit 1; }
case "$(uname -m)" in
  x86_64) nvim_arch=x86_64 tool_arch=x86_64 ;;
  aarch64 | arm64) nvim_arch=arm64 tool_arch=aarch64 ;;
  *) say "unsupported CPU: $(uname -m)"; exit 1 ;;
esac

case ":$PATH:" in
  *":$BIN:"*) on_path=yes ;;
  *) on_path=no ;;
esac
mkdir -p "$BIN" "$OPT" "$STATE"
PATH="$BIN:$PATH"

# 1. The config itself, unless a copy is already in place.
if [ ! -f "$CONFIG/init.lua" ]; then
  say "cloning the config into $CONFIG"
  git clone --quiet "$REPO" "$CONFIG"
fi

# 2. Neovim: the pinned release, when missing or older than 0.11.
nvim_is_current() {
  have nvim || return 1
  version=$(nvim --version | sed -n '1s/^NVIM v//p')
  [ -n "$version" ] || return 1
  major=${version%%.*}
  rest=${version#*.}
  minor=${rest%%.*}
  [ "$major" -gt 0 ] || [ "$minor" -ge 11 ]
}
if ! nvim_is_current; then
  say "installing Neovim $NVIM_VERSION into $OPT"
  dest="$OPT/nvim-$NVIM_VERSION"
  rm -rf "$dest"
  mkdir -p "$dest"
  fetch "https://github.com/neovim/neovim/releases/download/v$NVIM_VERSION/nvim-linux-$nvim_arch.tar.gz" |
    tar -xz -C "$dest" --strip-components=1
  ln -sfn "$dest/bin/nvim" "$BIN/nvim"
  "$BIN/nvim" --version >/dev/null 2>&1 || {
    say "the Neovim release build does not run on this system (it needs a recent glibc)"
    exit 1
  }
fi

# 3. Search tools used by "Go to file" and "Search in files".
install_tool() { # binary, archive URL
  tmp=$(mktemp -d)
  fetch "$2" | tar -xz -C "$tmp" --strip-components=1
  install -m 755 "$tmp/$1" "$BIN/$1"
  rm -rf "$tmp"
}
if ! have rg; then
  say "installing ripgrep"
  install_tool rg "https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-$tool_arch-unknown-linux-musl.tar.gz"
fi
if ! have fd && ! have fdfind; then
  say "installing fd"
  install_tool fd "https://github.com/sharkdp/fd/releases/download/v$FD_VERSION/fd-v$FD_VERSION-$tool_arch-unknown-linux-musl.tar.gz"
fi

# 4. Plugins and syntax parsers, so the first start is not a wall of install output.
have cc || have gcc || have clang || say "no C compiler: syntax parsers will be skipped (install gcc or clang for better highlighting)"
have make || say "make not found: search still works, with a slower sorter"
have npm || say "npm not found: the TypeScript language server will be skipped"
if [ ! -d "$DATA/lazy/lazy.nvim" ]; then
  say "installing plugins and syntax parsers (a few minutes, first time only)"
  if ! nvim --headless "+Lazy! restore" +qa >"$STATE/install.log" 2>&1; then
    say "plugin install reported a problem; see $STATE/install.log"
  fi
fi

[ "$on_path" = yes ] || say "add $BIN to your PATH to use what was installed"
say "ready: $(nvim --version | sed -n 1p)"
