
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
alias wordpress="cd ~/bin/devBox/wp/ && source wordpress.sh"

# Install new symfony project Web
alias sy-web="cd ~/bin/devBox/symfony/ && source symfony-run.sh --new_projet-web"

# Install new symfony project Api
alias sy-api="cd ~/bin/devBox/symfony/ && source symfony-run.sh --new_projet-api"

# Run symfony project 
alias sy-run="cd ~/bin/devBox/symfony/ && source symfony-run.sh --server_run"

# vue new project 
alias vu-web="cd ~/bin/devBox/vue/ && source vue-run.sh --new-projet"

# vue run project 
alias vu-run="cd ~/bin/devBox/vue/ && source vue-run.sh --run-projet"

# ionic new project 
alias io-web="cd ~/bin/devBox/ionic/ && source ionic-run.sh --new-projet"

# ionic run project 
alias io-run="cd ~/bin/devBox/ionic/ && source ionic-run.sh --run-projet"

# neofetch
# neofetch --ascii_colors 2 7 --colors 2 7 2 2 7 7 2
echo "
ALIAS :                                         GIT :
---------------------------------------         ---------------------------------------------------------------------
[ youtube-dl ] => mp3                           > git config --global user.name "d3v-donkey" 
---------------------------------------         > git config --global user.email "d3v-donkey@outlook.com" 
[ wordpress and database ] => wordpress         ---------------------------------------------------------------------
---------------------------------------         > git init
[ symfony project Web ] => sy-web               ---------------------------------------------------------------------
---------------------------------------         > git pull https://github.com/username/projet_name.git
[ symfony project Api ] => sy-api               ---------------------------------------------------------------------
---------------------------------------         > git add nouveau_fichier
[ Run symfony project ] => sy-run               > git commit -m "d3v-donkey"
---------------------------------------         > git remote add origin https://github.com/d3v-donkey/d3v-donkey.git                                                                
[ Vue project new ] => vu-web                   > git remote -v                                                      
---------------------------------------         > git push --set-upstream origin master                              
[ Vue run project ] => vu-run                   ---------------------------------------------------------------------
--------------------------------------- 
[ Ionic new project ] => io-web 
--------------------------------------- 
[ Ionic run project ] => io-run 
--------------------------------------- 
"

export PATH="/usr/local/$(whoami)/bin:$PATH"



