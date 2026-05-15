# --- zinit bootstrap ---
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# --- OMZ plugins via zinit ---
zinit snippet OMZP::aws
zinit snippet OMZP::common-aliases
zinit snippet OMZP::dotenv
# zinit snippet OMZP::macos
zinit snippet OMZP::npm
zinit snippet OMZP::direnv
zinit snippet OMZP::uv
zinit snippet OMZP::pip
zinit snippet OMZP::python
zinit snippet OMZP::brew

# --- Standalone plugins ---
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# --- Keybindings (oh-my-zsh defaults + macOS Alt+arrows) ---
zinit snippet OMZL::key-bindings.zsh
bindkey '^[[1;3D' backward-word     # Alt+Left
bindkey '^[[1;3C' forward-word      # Alt+Right

# Stop at /, -, . so Alt+arrows navigate path segments, not whole strings
WORDCHARS='*?_[]~=&;!#$%^(){}'

# --- Editor ---
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export MANPAGER='nvim +Man!'

# --- Aliases ---
alias grep='grep -i --color'
alias ls=lsd

alias pull="git pull -v"
alias stash="git stash push"
alias pop="git stash pop"
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'

alias lg='lazygit --use-config-dir ~/.config/lazygit'
alias ldk=lazydocker

alias vim=nvim

export git_main_branch=main

# --- fzf ---
source <(fzf --zsh)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,.venv,.ruff_cache,.pytest_cache,__pycache__
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# --- Cargo ---
. "$HOME/.cargo/env"

# --- yazi ---
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

. "$HOME/.local/bin/env"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# --- nvm (lazy) ---
# Node
# source: https://blog.mitsunee.com/post/n-xdg-setup
export NVM_DIR="$XDG_DATA_HOME/nvm"
export N_PREFIX="$XDG_DATA_HOME/node"
export N_CACHE_PREFIX="$XDG_CACHE_HOME"
export N_PRESERVE_NPM=1
export N_PRESERVE_COREPACK=1
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export COREPACK_HOME="$XDG_CACHE_HOME/node/corepack"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl/history"
lazy_load_nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() { lazy_load_nvm; nvm "$@"; }
node() { lazy_load_nvm; node "$@"; }
npm() { lazy_load_nvm; npm "$@"; }
npx() { lazy_load_nvm; npx "$@"; }

export PATH="$PATH:/Users/$(whoami)/.local/bin"

# --- Functions ---
# source ~/.zsh_functions

# --- Completions ---
fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select

# --- Starship ---
eval "$(starship init zsh)"
