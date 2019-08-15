# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/$(whoami)/.config/oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes


case $(tty) in
    (/dev/tty[1-9]) ZSH_THEME="gentoo";;
                (*) ZSH_THEME="bullet-train";;
esac

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

export BULLETTRAIN_PROMPT_ORDER=(time virtualenv status custom dir git cmd_exec_time)
export BULLETTRAIN_PROMPT_CHAR=


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# some git shortcuts
alias d="git --no-pager diff"
alias w="git status -s"
alias l='git lol'
alias r='git recent -20'
alias i='git in'
alias o='git out'

# raw control char for less
alias less="less -r"

# keep making the mistake...
alias abd="adb"
alias wabd="wadb"

# one history per shell
unsetopt share_history

bindkey '^H' backward-kill-word

# ctrl+p natigate directories with fzf
export FZF_DEFAULT_OPTS='--height 15% --reverse'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^P' fzf-cd-widget

# disable control flow (ctrl+s, ctrl+q)
stty -ixon ixoff

# make caps lock act as esc
setxkbmap -option caps:escape


# using ctrl+z to switch back background app to foreground
# when the current line is empty.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg
