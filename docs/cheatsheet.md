# Neovim Cheatsheet

`Space` is the leader key: press it and wait to see every shortcut.

Printable version: [cheatsheet.pdf](cheatsheet.pdf), one A4 landscape page.

## Files, tabs & panes

| Keys | Action |
|---|---|
| `Ctrl+B` | Show / hide the sidebar |
| `Space e` | Focus the explorer |
| `Shift+L` `Shift+H` | Next / previous tab |
| `Space b d` | Close tab |
| `Space b o` | Close the other tabs |
| `Space b p` | Pin tab |
| `Ctrl+H` `J` `K` `L` | Focus pane ← ↓ ↑ → |
| `Space \` `Space -` | Split right / down |
| `Ctrl+S` | Save |
| `Space q` | Quit (asks to save) |

## Explorer sidebar

| Keys | Action |
|---|---|
| `Enter` `l` | Open file / expand folder |
| `h` | Collapse folder |
| `a` | New file (end with / for a folder) |
| `d` `r` | Delete / rename |
| `c` `m` | Copy / move to a path |
| `x` `y` `p` | Cut / copy / paste |
| `s` `S` | Open in split right / below |
| `P` | Preview without opening |
| `/` | Filter the tree |
| `<` `>` | Switch Files / Git / Open |
| `?` | Show every sidebar key |

## Git tab in the sidebar

| Keys | Action |
|---|---|
| `Enter` | Show the change side by side |
| `gf` | Go to the file |
| `ga` `gu` | Stage / unstage file |
| `gr` | Discard changes in file |
| `gc` | Commit (asks for a message) |

## Editing

| Keys | Action |
|---|---|
| `Ctrl+/` `gcc` | Toggle comment |
| `Alt+J` `Alt+K` | Move line down / up |
| `>` `<` | Indent / outdent selection |
| `Tab` `Enter` | Accept completion |
| `Ctrl+Space` | Open completion |
| `Ctrl+E` | Dismiss completion |

## Find

| Keys | Action |
|---|---|
| `Ctrl+P` `Space f f` | Go to file |
| `Space f g` | Search in all files |
| `Space f w` | Search word under cursor |
| `Space /` | Find in this file |
| `Space f b` | Open tabs |
| `Space f r` | Recent files |
| `Space f s` | Symbols in this file |
| `Space f S` | Symbols in the workspace |
| `Space f d` | Problems |
| `Space f c` | Command palette |
| `Space f k` | Keyboard shortcuts |
| `Space f h` | Help pages |

## Inside a search box

| Keys | Action |
|---|---|
| `Enter` | Open |
| `Ctrl+J` `Ctrl+K` | Move down / up (arrows too) |
| `Ctrl+X` | Open in a split below |
| `Ctrl+D` `Ctrl+U` | Scroll the preview |
| `Ctrl+Q` | Keep the results as a list |
| `Esc` | Close |

## Code

| Keys | Action |
|---|---|
| `gd` `F12` | Go to definition |
| `grr` | Find references |
| `gri` | Go to implementation |
| `gy` `gD` | Type definition / declaration |
| `K` | Hover documentation |
| `F2` `Space c r` | Rename symbol |
| `Space c a` | Quick fix |
| `Space c d` | Show the problem on this line |
| `]d` `[d` | Next / previous problem |
| `Space c f` | Format document |
| `Alt+←` `Alt+→` | Go back / forward |

## Markdown

Opens rendered. The cursor line shows the raw text.

| Keys | Action |
|---|---|
| `Space c m` | Switch preview / source |
| `Space c p` | Preview to the side |

## Git · from anywhere

| Keys | Action |
|---|---|
| `Space g d` | Review all changes (toggle) |
| `Space g g` | Source control panel |
| `Space g e` | Changed files in the sidebar |
| `Space g c` | Commit |
| `Space g P` | Push |
| `Space g F` | Pull |
| `Space g D` | Review the whole branch |
| `Space g h` | History of this file |
| `Space g H` | History of the branch |
| `Space g f` | Changed files (search box) |
| `Space g l` | Commit log |
| `Space g w` | Switch branch |

## Git · in the file you are editing

| Keys | Action |
|---|---|
| `]h` `[h` | Next / previous change |
| `Space g p` | Peek the change |
| `Space g s` | Stage / unstage the change |
| `Space g r` | Discard the change |
| `Space g S` | Stage the whole file |
| `Space g R` | Discard all changes in the file |
| `Space g b` | Blame this line |
| `Space g B` | Toggle inline blame |

## Review panel (Space g d)

| Keys | Action |
|---|---|
| `Enter` | Show the file side by side |
| `Tab` `Shift+Tab` | Next / previous file |
| `]c` `[c` | Next / previous change |
| `gf` | Go to the file (ends review) |
| `Ctrl+W gf` | File in a new tab (gT returns) |
| `s` `-` | Stage / unstage the file |
| `S` `U` | Stage all / unstage all |
| `X` | Discard changes in the file |
| `cc` | Commit what is staged |
| `q` `g?` | Close / show every key |

## Source control panel (Space g g)

| Keys | Action |
|---|---|
| `Enter` | Show the entry side by side |
| `gf` | Go to the file |
| `Tab` | Expand / collapse inline diff |
| `s` `u` | Stage / unstage |
| `S` `U` | Stage all / unstage all |
| `x` | Discard |
| `c` | Commit menu |
| `P` `p` `f` | Push / pull / fetch menu |
| `b` `l` `Z` | Branch / log / stash menu |
| `?` `q` | Show every key / close |

## Commit message

| Keys | Action |
|---|---|
| `i` | Start typing the message |
| `Ctrl+C Ctrl+C` | Confirm the commit |
| `Ctrl+C Ctrl+K` | Cancel |

## Vim essentials

| Keys | Action |
|---|---|
| `i` `a` `o` | Insert before / after / below |
| `Esc` | Back to normal mode |
| `v` `V` | Select characters / whole lines |
| `u` `Ctrl+R` | Undo / redo |
| `dd` `yy` `p` | Cut line / copy line / paste |
| `d` `y` | Cut / copy the selection |
| `ciw` | Change the word under cursor |
| `.` | Repeat the last change |
| `/text` `n` `N` | Search, then next / previous |
| `*` | Search the word under cursor |
| `gg` `G` | Top / bottom of the file |
| `w` `b` | Next / previous word |
| `0` `$` `%` | Line start / end / matching () |
| `:w` `:q` | Save / close the window |

## Help & upkeep

| Keys | Action |
|---|---|
| `Space` | Wait: lists the available shortcuts |
| `:Lazy` | Plugins (install, update) |
| `:Mason` | Language servers |
| `:checkhealth` | Diagnose the setup |

## Notes

- Keys in one box are typed one after another; Ctrl+B means hold Ctrl and press B. Config: ~/.config/nvim
- Inside herdr or tmux, Ctrl+B is their prefix: use Space e, then q to hide the sidebar. If Ctrl+/ does nothing, use gcc.
