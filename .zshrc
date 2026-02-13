if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p11k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions
zinit light softmoth/zsh-vim-mode
zinit light Aloxaf/fzf-tab
zinit light ael-code/zsh-colored-man-pages
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

autoload -Uz compinit && compinit

zinit cdreplay -q

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey '^r' atuin-search

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

alias cd=z
alias ..='cd ..'
alias ...='cd /home/rahul'
alias ....='cd /'
alias nv='nvim'
alias arch='pfetch'
alias agent='opencode'
alias vim='nvim'
alias rr='ranger'
alias ls='eza'
alias l='ls -l'
alias la='ls -a'
alias lt='ls --tree'
alias l2='lt -a -L 2'
alias l3='lt -a -L 3'
alias cl='clear'
alias fv='fzf -m --reverse --preview="bat --number --color=always {}" | xargs -r nvim'

. "$HOME/.atuin/bin/env"
eval "$(fzf --zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

export FZF_DEFAULT_OPTS='
--color=fg:#c1c1c1,fg+:#c1c1c1
--color=hl:#5f8787,hl+:#e78a53
--color=prompt:#e78a53
--color=pointer:#5f8787
--color=marker:#fbcb97
--color=spinner:#aaaaaa
--color=info:#888888
--color=header:#999999
--color=border:#333333
'


export PATH="$PATH:/home/rahul/.local/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=~/.npm-global/bin:$PATH
export PF_INFO="ascii title os host kernel pkgs memory disk palette"

export PATH=/home/rahul/.opencode/bin:$PATH
