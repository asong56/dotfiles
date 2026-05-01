########################################
# mkcd — create directory and enter it
########################################
mkcd() {
    [[ -z "$1" ]] && { echo "usage: mkcd <dir>" >&2; return 1; }
    mkdir -p "$1" && cd "$1"
}

########################################
# up [n] — cd up n levels (default 1)
########################################
up() {
    local n="${1:-1}" target=""
    for (( i=0; i<n; i++ )); do target="../$target"; done
    cd "${target:-.}" || return 1
}

########################################
# extract — universal archive extractor
########################################
extract() {
    if [[ ! -f "$1" ]]; then
        echo "❌ Not a file: $1" >&2; return 1
    fi
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf  "$1" ;;
        *.tar.gz|*.tgz)   tar xzf  "$1" ;;
        *.tar.xz)         tar xJf  "$1" ;;
        *.tar.zst)        tar --zstd -xf "$1" ;;
        *.tar)            tar xf   "$1" ;;
        *.gz)             gunzip   "$1" ;;
        *.bz2)            bunzip2  "$1" ;;
        *.xz)             unxz     "$1" ;;
        *.zip)            unzip    "$1" ;;
        *.7z)             7z x     "$1" ;;
        *.rar)            unrar x  "$1" ;;
        *) echo "❌ Unknown format: $1" >&2; return 1 ;;
    esac
}

########################################
# save — lint, stash, pull, pop, commit, push
########################################
save() {
    git rev-parse --is-inside-work-tree &>/dev/null || {
        echo "❌ Not a git repository." >&2; return 1
    }

    # ── Lint staged files ─────────────────
    local staged
    staged=$(git status --porcelain | awk '{print $2}')

    if echo "$staged" | grep -q '\.py$'; then
        echo "🔍 Linting Python..."
        ruff check --fix . && ruff format . || {
            echo "❌ Ruff: errors remain — fix before saving." >&2; return 1
        }
    fi

    if echo "$staged" | grep -qE '\.(js|ts|jsx|tsx|json)$'; then
        echo "🔍 Linting JS/TS..."
        biome check --write . || {
            echo "❌ Biome: errors remain — fix before saving." >&2; return 1
        }
    fi

    # ── Sync with remote ──────────────────
    local stashed=false
    if [[ -n $(git status --porcelain) ]]; then
        git stash push -u -m "save-$(date +%F-%T)" || { echo "❌ Stash failed." >&2; return 1; }
        stashed=true
    fi

    git pull --rebase || {
        $stashed && git stash pop
        echo "❌ Pull failed." >&2
        return 1
    }

    if $stashed; then
        git stash pop || { echo "⚠️  Conflict on stash pop — resolve manually." >&2; return 1; }
    fi

    # ── Stage & commit ────────────────────
    git add .

    local n s top
    n=$(git diff --cached --name-only | wc -l | tr -d ' ')
    (( n == 1 )) && s="" || s="s"

    if [[ "$n" -eq 0 ]]; then
        echo "ℹ️  Nothing to commit."
        return 0
    fi

    top=$(git diff --cached --numstat | awk '{print $1+$2, $3}' | sort -rn | head -1 | awk '{print $2}')

    git commit -m "change: ${n} file${s} changed, most changed ${top}"
    git push && echo "🚀 Pushed."
}

########################################
# gitroot — cd to repo root
########################################
gitroot() {
    local root
    root=$(git rev-parse --show-toplevel 2>/dev/null) || {
        echo "❌ Not inside a git repository." >&2; return 1
    }
    cd "$root"
}

########################################
# port [n] — show what is listening on a port
########################################
port() {
    lsof -nP -iTCP:"${1:-80}" | grep LISTEN
}

########################################
# json — pretty-print JSON from stdin or file
########################################
json() {
    if command -v jq &>/dev/null; then
        jq '.' "${1:--}"
    else
        uv run python -m json.tool "${1:--}"
    fi
}

########################################
# envdiff — show env changes after sourcing a file
########################################
envdiff() {
    local before after
    before=$(env | sort)
    source "$1"
    after=$(env | sort)
    diff <(echo "$before") <(echo "$after")
}
