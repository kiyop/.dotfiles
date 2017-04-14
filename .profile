# .profile

# まずは GNU screen を立ち上げる
if [ "$TERM" != 'screen' -a "$TERM" != 'screen-256color' -a "$TERM" != 'dumb' ]; then
    [ `which screen 2>/dev/null` ] && screen -xRU || screen -D -RR -U
fi

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export LANG=ja_JP.UTF-8
export IGNOREEOF=10
if [ -f $HOME/.profile_local ]; then
    source $HOME/.profile_local
fi

alias beep='bash -c "echo -ne \"\\a\""'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias check-ip='curl ipcheck.ieserver.net' # グローバル IP を調べる (要 curl)
alias show-path='echo -e ${PATH//:/"\n"}' # path をリストアップ
# mkdir and cd
mkdircd() { mkdir -p "$@" && eval cd "\"\$$#\""; }
if [ `uname` = "Darwin" ]; then
    alias ll='ls -laG'
    alias o='open'
    alias ql='qlmanage -p "$1" >& /dev/null'
    alias imgsize='mdls -name kMDItemPixelWidth -name kMDItemPixelHeight' # 画像サイズ取得
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
    alias gvim='/Applications/MacVim.app/Contents/bin/mvim --remote-tab-silent'
    alias less='/Applications/MacVim.app/Contents/Resources/vim/runtime/macros/less.sh'
    alias eclipse='open /Applications/eclipse/Eclipse.app'
    [ -e "/Applications/CotEditor.app" ] && alias cot='open -a /Applications/CotEditor.app'
    [ -e "/Applications/Marked 2.app" ] && alias md='open -a "Marked 2"'
    [ -x "/Applications/Gyazo.app/Contents/MacOS/Gyazo" ] && alias gz='/Applications/Gyazo.app/Contents/MacOS/Gyazo'

    pbcopy-chomp() { local s; read -rd '' s; echo -n "$s" | pbcopy; }
    pbcopy-file() { cat "$1" | pbcopy-chomp; }
    # 時間のかかるコマンドが終了したらDockでバウンドさせる
    beep-at-finished() { "$@"; beep; }
    beep-on-error() { "$@" || beep; }
    alias phpunit='beep-at-finished phpunit'
    alias behat='beep-at-finished behat'
    # コマンド結果を通知センターに送る
    ntf() { if "$@"; then local t="(*'-') < Successful !!"; else t="( >_<)? < Failed..."; fi; echo "display notification \"$@\" with title \"$t\""|osascript; }
    # QuickTime でキャプチャした iPhone のスクリーン動画をアニメ GIF 化する（以下の中のパラメータで画質とかファイルサイズが調整可能）
    # `ffmpeg` と `gifsicle` は MacPorts/HomeBrew 等で予めインストールしておくこと
    capmov2gif() { ffmpeg -i "$1" -vf "scale=320:-1" -pix_fmt rgb24 -r 30 -f gif - | gifsicle --delay=3 --optimize=3; }

    # tar でリソースフォーク (`._`で始まるファイル) を含めないようにする
    export COPYFILE_DISABLE=1

    # MacPorts
    if [ -d "/opt/local" ]; then
        export PATH=/opt/local/bin:/opt/local/sbin:$PATH
        export MANPATH=/opt/local/share/man:$MANPATH
    fi
else
    alias ll='ls -la --color'
    alias less='/usr/share/vim/vim74/macros/less.sh'
fi

alias top='screen -t top top'
alias grep='grep --color=auto --exclude-dir=.git'
alias tailf='screen -t tailf tail -f'
alias redis-cli='screen -t redis redis-cli'
alias eq='screen -t earthquake earthquake'
if [ `uname` = "Darwin" ]; then
    alias vi='screen -t vim /Applications/MacVim.app/Contents/MacOS/Vim'
else
    alias vi='screen -t vim vim'
fi
ssh-on-screen() { eval SERVER=\${$#}; screen -t $SERVER ssh "$@"; }
#if [ "$TERM" = "screen" ]; then
  alias ssh=ssh-on-screen
#fi

if type -p colordiff &>/dev/null; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi
type -p tree &>/dev/null && alias tree='tree -aNC -I ".git"'

memcache-cli() {
    #bash -c "echo -e \"$1\\nquit\"" | curl -s -T - telnet://localhost:11211;
    case $# in
        1) local cmd=$1 host="localhost:11211" ;;
        2) local cmd=$2 host=$1 ;;
        *) echo "usage: $0 [<host>:<port>] <command>"; return 1 ;;
    esac
    bash -c "echo -e \"${cmd}\\nquit\"" | curl -s -T - telnet://${host};
}
alias memcache-stats='memcache-cli stats'
alias memcache-reset='memcache-cli flush_all'

hr() { local s l; if [ $# -ge 1 ]; then s="$1"; else s="-"; fi; for i in $(seq 1 $COLUMNS); do l="$s$l"; done; echo "$l"; }
git-checkout-all-branches() {
    case $# in
        1) local r=$1 ;;
        *) echo "usage: $0 <remote_repository>"; return 1 ;;
    esac
    if [ -z $(git remote|grep -e "^${r}$") ]; then echo "Cannot found remote repository: ${r}"; return 1; fi
    git fetch ${r}
    local i; for i in $(git branch -r|awk '{print $1}'|grep -e "^${r}"|grep -v "^${r}/HEAD$"|sed "s:${r}/::g"); do
        git checkout --track -b $i $r/$i
        git pull --rebase
    done
    git checkout master
}
git-status-all-directories() {
    case $# in
        1) local d cd=$(pwd); for d in $(find "$1" -follow -type d); do if [ -e $d/.git ]; then echo; echo "## $d"; cd $d; git status --branch --short; cd "$cd"; fi; done ;;
        *) echo "usage: $0 <directory>"; return 1 ;;
    esac
}
export PAGER=less
export MANPAGER='col -b -x|vim -R -c "set ft=man nolist nomod noma" -'
alias aws='env -u MANPAGER aws'
export GIT_PAGER=less
export GIT_EDITOR=vim
export SVN_EDITOR=vim
if type lv > /dev/null 2>&1; then
    export LV='-c -Ou8'
fi
#export CACA_DRIVER=x11
export CACA_DRIVER=ncurses

# Ruby (via rbenv)
export RBENV_DIR="${HOME}/.rbenv"
if [ -s "${RBENV_DIR}/bin/rbenv" ]; then
    export PATH="${HOME}/.rbenv/bin:${PATH}"
    eval "$(rbenv init -)"
fi
# Go Programing Language (via GVM)
export GVM_DIR="${HOME}/.gvm"
if [ -s "${GVM_DIR}/scripts/gvm" ]; then
    export GO_VERSION=go1.7.3
    export GVM_PKGSET=local
    source "${GVM_DIR}/scripts/gvm"
    gvm use "${GO_VERSION}"
    [ -z $(gvm pkgset list | grep "${GVM_PKGSET}") ] && gvm pkgset create "${GVM_PKGSET}"
    gvm pkgset use "${GVM_PKGSET}"
fi
# Node.js (via NVM)
export NVM_DIR="${HOME}/.nvm"
if [ -s "${NVM_DIR}/nvm.sh" ]; then
    source "${NVM_DIR}/nvm.sh"
    #if type -p ngrok &>/dev/null; then
    #    alias ngrok='screen -t ngrok ngrok'
    #fi
fi
# yarn (npm alternative)
export YARN_ROOT="${HOME}/.yarn"
if [ -s "${YARN_ROOT}/bin" ]; then
    export PATH="${YARN_ROOT}/bin:$PATH"
fi
# Python (via pyenv)
export PYENV_ROOT="${HOME}/.pyenv"
if [ -s "${PYENV_ROOT}/bin/pyenv" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
fi
# Erlang/OTP (via kerl)
# git clone git@github.com:kerl/kerl.git ~/.kerl/bin
export KERL_ROOT="${HOME}/.kerl"
if [ -s "${KERL_ROOT}/bin/kerl" ]; then
    export PATH="${KERL_ROOT}/bin:${PATH}"
    export ERLANG_VERSION=19.3
    [ -d "${KERL_ROOT}/installations/${ERLANG_VERSION}" ] && source "${KERL_ROOT}/installations/${ERLANG_VERSION}/activate"
fi
# Elixir (via kiex / need Erlanga)
export KIEX_ROOT="${HOME}/.kiex"
[[ -s "${KIEX_ROOT}/scripts/kiex" ]] && source "${KIEX_ROOT}/scripts/kiex"
# Google Cloud SDK
export GOOGLE_CLOUD_SDK=$HOME/google-cloud-sdk
if [ -d $GOOGLE_CLOUD_SDK ]; then
    export APPENGINE_SDK=$GOOGLE_CLOUD_SDK/platform/google_appengine
    export APPENGINE_APP_CFG=$GOOGLE_CLOUD_SDK/bin/appcfg.py
    export APPENGINE_DEV_APPSERVER=$GOOGLE_CLOUD_SDK/bin/dev_appserver.py
    export PATH=$GOOGLE_CLOUD_SDK/bin:$PATH
fi
# Docker (using docker-machine)
if type -p docker-machine &>/dev/null; then
    docker-machine-env() { eval "$(docker-machine env default)"; }
    if [ -n "$(docker-machine ls --quiet --filter 'state=Running' --filter 'name=default')" ]; then
        docker-machine-env
    fi

    # URL から Web サーバーの動作環境や利用ライブラリ、外部サービス等を調べる
    alias wappalyzer='docker run --rm wappalyzer/cli $1'
fi

