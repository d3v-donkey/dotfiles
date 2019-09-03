
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


alias d="git --no-pager diff"
alias w="git status -s"
alias l='git lol'
alias r='git recent -20'
alias i='git in'
alias o='git out'

export LANG=fr_FR.UTF-8
export EDITOR='vim'
export ARCHFLAGS="-arch x86_64"

#setopt autocd

alias la='sudo ls -A --color'
alias lf='sudo ls -A'
alias vim="vim --servername VIM"

# youtube-dl command
alias mp3="cd ~/Musics && youtube-dl -t -x --audio-format mp3 --audio-quality 0 --no-playlist"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# VMAIL
#export VMAIL_VIM='/usr/bin/nvim'
#export VMAIL_BROWSER='/usr/bin/chromium'
#export VMAIL_BROWSER='/usr/bin/opera'
#export VMAIL_HTML_PART_READER='elinks -dump'
#export VMAIL_HTML_PART_READER='w3m -dump -T text/html -I utf-8 -O utf-8'
#alias vmail-main="VMAIL_HOME=/home/raihan/Private/.vmail/main vmail"
#alias vmail-work="VMAIL_HOME=/home/raihan/Private/.vmail/work vmail"

# GRIVE
#alias grive="./.scripts/grive.sh"

# WIFI
#alias wifi="sudo netctl start"
#alias wifid="sudo netctl stop"
#alias wifi0="./.scripts/wifi0.sh"
#alias wifi1="./.scripts/wifi1.sh"
#alias wifi2="./.scripts/wifi2.sh"
#alias wifid="sudo ip link set dev wlp2s0 down"
#alias wifir="sudo ip link set dev wlp2s0 up"

# ETHERNET
#alias eth="./.scripts/eth.sh"
#alias ethd="sudo ip link set dev enp1s0 down"
#alias ethr="sudo ip link set dev enp1s0 up"

# QEMU
#alias qemuc="qemu-img create -f qcow2"
#alias qemubsd="qemu-system-x86_64 -enable-kvm -m 1024M -soundhw hda -net nic -net tap,ifname=tap0,script=no,downscript=no -drive file=/home/raihan/qemu/bsd/bsd.img"
#alias qemulinux="qemu-system-x86_64 -enable-kvm -m 1024M -soundhw hda -drive file=/home/raihan/qemu/linux/linux.img,if=virtio"
#alias qemulinux-share="qemu-system-x86_64 -enable-kvm -m 1024M -soundhw hda -drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/ovmf_code_x64.bin -drive if=pflash,format=raw,file=/home/raihan/qemu/linux/my_uefi_vars.bin -drive file=/home/raihan/qemu/linux/linux.img,if=virtio -fsdev local,security_model=passthrough,id=fsdev0,path=qemu/share -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare"

# eCryptfs
#alias mount-crypt="ecryptfs-mount-private"
#alias umount-crypt="ecryptfs-umount-private"

# Hugo
#alias hugo-build="hugo server --buildDrafts --navigateToChanged"
#alias hugo-server="hugo server --navigateToChanged"



