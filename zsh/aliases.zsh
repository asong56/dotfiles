########################################
# Listing — eza when available, ls fallback
########################################
if command -v eza &>/dev/null; then
    alias ls='eza --group-directories-first --icons=auto'
    alias ll='eza -lah --git --group-directories-first --icons=auto'
    alias la='eza -a --group-directories-first --icons=auto'
    alias lt='eza --tree --level=3 --git-ignore --icons=auto'
    alias llt='eza --tree --level=3 --git-ignore -l --icons=auto'
else
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
fi

########################################
# File reading — bat when available
########################################
if command -v bat &>/dev/null; then
    alias cat='bat --style=plain --paging=never'
    alias less='bat --paging=always'
fi

########################################
# Search — ripgrep
########################################
alias grep='grep --color=auto'
if command -v rg &>/dev/null; then
    alias rg='rg --smart-case'
fi

########################################
# Navigation
########################################
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias dotfiles='cd "$DOTFILES"'

########################################
# Git
########################################
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git lg -20'
alias gsw='git switch'

########################################
# Bun
########################################
alias br='bun run'
alias ba='bun add'
alias bad='bun add -d'
alias bd='bun dev'
alias bb='bun run build'
alias bt='bun test'

########################################
# uv (Python)
########################################
alias py='uv run python'
alias venv='uv venv && source .venv/bin/activate'
alias activate='source .venv/bin/activate'

########################################
# Misc utilities
########################################
alias j='z'
alias serve='uv run python -m http.server'
alias reload='exec zsh'
alias path='print -l $path'
alias myip='curl -s ifconfig.me'
alias ports='lsof -i -P -n | grep LISTEN'

########################################
# Safety
########################################
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
