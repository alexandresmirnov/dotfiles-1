# Setup fzf
# ---------
export FZF_DEFAULT_OPTS='--exact' # prefer exact matches

# Set install dir
if [[ $OSTYPE == 'linux-gnu' ]]; then
  export FZF_PREFIX=/opt
elif [[ $OSTYPE == darwin* ]]; then
  export FZF_PREFIX=/usr/local/opt
else
  # FZF not available
  return 0
fi

if command -v ag > /dev/null; then
  export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || ag --hidden --ignore .git -g "") 2> /dev/null'
else
  export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
  echo "[FZF Module]: 'ag' not found, falling back to 'find' (no hidden files)"
fi

# Auto-completion
[[ $- == *i* ]] && source "$FZF_PREFIX/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
source "$FZF_PREFIX/fzf/shell/key-bindings.zsh"

# better zz from fasd
function zz() {
  local dir
  dir="$(fasd -Rdl "$1" | fzf --query="$1" -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

# does global file search, do zz -> ccat
function show() {
    local file
    if [[ -f "$1" ]]; then
        ccat --bg=dark "$1"
    else
        file=$(fzf --query="$*"\
          --select-1 --exit-0)
        [ -n "$file" ] && ccat --bg=dark "$file"
    fi
}

# Pick file to edit
function vf() {
  local file
  file=$(fzf --exact --height 40% --reverse --query="$*"  --select-1 --exit-0)
  [ -n "$file" ] && vim "$file"
}

# global file search -> vim
function vfg() {
  local file;
  file="$(fasd -Ral "$*" | fzf --query="$*" --select-1 --exit-0)";  
  [ -n "$file" ] && vim "$file";
}

