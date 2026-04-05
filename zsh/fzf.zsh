########################################
# fzf — fuzzy finder
# Loaded only when fzf is installed
########################################
command -v fzf &>/dev/null || return

# ── Source shell integration ─────────────
if [[ "$OS" == mac ]]; then
    local _fzf_base="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/fzf"
    [[ -f "$_fzf_base/shell/key-bindings.zsh" ]] && source "$_fzf_base/shell/key-bindings.zsh"
    [[ -f "$_fzf_base/shell/completion.zsh"   ]] && source "$_fzf_base/shell/completion.zsh"
    unset _fzf_base
else
    [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [[ -f /usr/share/doc/fzf/examples/completion.zsh   ]] && source /usr/share/doc/fzf/examples/completion.zsh
    # Also works with: eval "$(fzf --zsh)"  (fzf >= 0.48)
fi

# ── Default command ───────────────────────
# Use fd if available — faster and respects .gitignore
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command -v rg &>/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules}"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ── File preview command ──────────────────
if command -v bat &>/dev/null; then
    _fzf_file_preview='bat --style=numbers,header --color=always --line-range=:200 {}'
else
    _fzf_file_preview='head -200 {}'
fi

# ── Global defaults ───────────────────────
# Catppuccin Mocha palette (matches nvim theme)
export FZF_DEFAULT_OPTS="
  --height=50%
  --layout=reverse
  --border=rounded
  --info=inline
  --pointer='▶'
  --marker='●'
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-a:select-all'
  --bind='ctrl-d:deselect-all'
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=border:#6c7086,label:#cdd6f4
"

# ── CTRL-T: insert file path ──────────────
export FZF_CTRL_T_OPTS="
  --preview '$_fzf_file_preview'
  --preview-window='right:55%:wrap'
"

# ── ALT-C: cd into directory ──────────────
if command -v eza &>/dev/null; then
    export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
else
    export FZF_ALT_C_OPTS="--preview 'ls -la --color=always {}'"
fi

# ── CTRL-R: history search ────────────────
export FZF_CTRL_R_OPTS="
  --no-preview
  --layout=reverse
  --border=rounded
  --prompt='hist > '
"

# ── Custom functions using fzf ────────────

# fzf-cd: interactive directory jump (fallback when zoxide is unavailable)
fzf-cd() {
    local dir
    dir=$(
        fd --type d --hidden --follow --exclude .git --exclude node_modules 2>/dev/null \
        | fzf --preview 'eza --tree --level=2 --color=always {} 2>/dev/null || ls -la {}'
    )
    [[ -n "$dir" ]] && cd "$dir"
}

# fzf-branch: switch git branch interactively
fzf-branch() {
    git rev-parse --is-inside-work-tree &>/dev/null || { echo "Not a git repo" >&2; return 1; }
    local branch
    branch=$(
        git branch --all --format='%(refname:short)' \
        | grep -v 'HEAD' \
        | fzf --preview 'git log --oneline --color=always -10 {1}' \
              --preview-window='right:50%' \
              --prompt='branch > '
    )
    [[ -n "$branch" ]] && git switch "${branch#origin/}"
}

# fzf-kill: interactively kill a process
fzf-kill() {
    local pid
    pid=$(ps -ef | fzf --header='Select process to kill' --no-preview | awk '{print $2}')
    [[ -n "$pid" ]] && kill -${1:-9} "$pid" && echo "Killed PID $pid"
}

unset _fzf_file_preview
