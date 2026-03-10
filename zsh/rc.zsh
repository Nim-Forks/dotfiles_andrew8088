source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}

autoload -Uz compinit && compinit
source_if_exists $HOME/.env.sh
source_if_exists $DOTFILES/zsh/history.zsh
source_if_exists $DOTFILES/zsh/git.zsh
source_if_exists ~/.fzf.zsh
source_if_exists $DOTFILES/zsh/aliases.zsh
source_if_exists /usr/local/etc/profile.d/z.sh
source_if_exists /opt/homebrew/etc/profile.d/z.sh

if type "direnv" > /dev/null; then
    eval "$(direnv hook zsh)"
fi

autoload -U zmv
autoload -U promptinit && promptinit
autoload -U colors && colors

if test -z ${ZSH_HIGHLIGHT_DIR+x}; then
else
    source $ZSH_HIGHLIGHT_DIR/zsh-syntax-highlighting.zsh
fi

export VISUAL=nvim
export EDITOR=nvim
export PATH="$PATH:/usr/local/sbin:$DOTFILES/bin:$HOME/.local/bin:$DOTFILES/scripts/"

source_if_exists $DOTFILES/zsh/prompt.zsh

# VIM MODE (http://dougblack.io/words/zsh-vi-mode.html) -----------------------
# bindkey -v
bindkey '^?' backward-delete-char

# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg[yellow]%}[% NORMAL]% %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
#     zle reset-prompt
# }

# zle -N zle-line-init
# zle -N zle-keymap-select
# export KEYTIMEOUT=1
# END VIM MODE ----------------------------------------------------------------

#eval "$(lua ~/bin/z.lua --init zsh)"

if test -d "$HOME/code/friday"; then
    export FRIDAY_HOME="$HOME/code/friday"
    export PATH="$FRIDAY_HOME/bin:$PATH"
fi

# bun completions
[ -s "/Users/andrew/.bun/_bun" ] && source "/Users/andrew/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by git-ai installer on Thu 12 Feb 2026 04:45:08 UTC
export PATH="/Users/andrew/.git-ai/bin:$PATH"
