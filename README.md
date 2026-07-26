# dotfiles

Dotter-managed dotfiles for Zsh, Git, Ghostty, and Zed. Plugin-free shell with a fast custom prompt.

## Install

```bash
git clone https://github.com/asong56/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer is idempotent. Re-running it backs up any real files that would be overwritten to `~/.dotfiles_backup/<timestamp>/`, then restows.

---

## Structure

```
dotfiles/
├── .bashrc                     bash fallback config
├── .config/                    app config files
├── .devcontainer/              Codespaces / Dev Container setup
├── .dotter/                    dotter variables (name, font, paths, features)
├── bin/
│   └── npm-publish.sh          version bump + publish to npm
├── did/                        DID document + signing / verification scripts
├── git/
├── templates/
│   ├── biome.json              shared Biome (JS/TS linter) config
│   └── pyproject.toml          shared Python project template
├── zed/
│   ├── settings.json           Zed editor settings
│   └── asevka.toml             custom font variant config
├── zsh/                        my zsh config
├── dotter.toml
├── Brewfile
└── install.sh                  bootstrap: install deps + stow dotfiles
```

---

## Dependencies

Managed via `Brewfile` (macOS) or the `postCreateCommand` in `.devcontainer/devcontainer.json` (Linux / Codespaces).

Core: `dotter`, `stow`, `zsh`, `fzf`, `zoxide`, `fd`, `starship`, `ripgrep`, `bottom`, `git`, `gh`

Dev: `uv`, `ruff`, `bun`, `rustup`, `biome`, `duckdb`
