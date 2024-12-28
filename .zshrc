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
zinit light none9632/zsh-sudo
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

alias ..='cd ..'
alias ...='cd /home/rahul'
alias ....='cd /'
alias nv='nvim'
alias rr='ranger'
alias ls='exa --icons'
alias la='exa --icons --long -a'
alias cl='clear'
alias arch='pfetch'
alias gpt='tgpt --multiline'

export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

. "$HOME/.atuin/bin/env"
eval "$(fzf --zsh)"
eval "$(atuin init zsh)"

export PATH="$PATH:/home/rahul/.local/bin"
export PATH="$HOME/.cargo/bin:$PATH"
