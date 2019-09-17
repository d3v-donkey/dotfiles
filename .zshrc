
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin"
export BROWSER="/usr/bin/firefox"
export GOPATH="$HOME/go"
export ZSH="/home/$(whoami)/.config/oh-my-zsh"


ZSH_THEME="xiong-chiamiov-plus"
#ZSH_THEME="bullet-train"



DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
HIST_STAMPS="dd.mm.yyyy"


plugins=(battery git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export BULLETTRAIN_PROMPT_ORDER=(time virtualenv status custom dir git cmd_exec_time)
export BULLETTRAIN_PROMPT_CHAR=

# ctrl+p natigate directories with fzf
export FZF_DEFAULT_OPTS='--height 15% --reverse'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^P' fzf-cd-widget


export LANG=fr_FR.UTF-8
export EDITOR='vim'
export ARCHFLAGS="-arch x86_64"

# youtube-dl command
alias mp3="cd ~/Musics && youtube-dl -t -x --audio-format mp3 --audio-quality 0 --no-playlist"

# Install new wordpress and database
alias wordpress="cd ~/bin/devBox/wp/wordpress.sh"

# Install new symfony project Web
alias sy-web="cd ~/bin/devBox/symfony/symfony-run.sh --new_projet-web"

# Install new symfony project Api
alias sy-api="cd ~/bin/devBox/symfony/symfony-run.sh --new_projet-api"

# Run symfony project 
alias sy-run="cd ~/bin/devBox/symfony/symfony-run.sh --server_run"

# neofetch
neofetch --ascii_colors 2 7 --colors 2 7 2 2 7 7 2

export PATH="/usr/local/$(whoami)/bin:$PATH"



