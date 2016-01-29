# .profile
if [ -f $HOME/.profile_local ]; then
    source $HOME/.profile_local
fi

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export LANG=ja_JP.UTF-8
export IGNOREEOF=10

alias beep='bash -c "echo -ne \"\\a\""'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias gip='curl ipcheck.ieserver.net' # グローバル IP を調べる (要 curl)
# mkdir and cd
mkdircd() { mkdir -p "$@" && eval cd "\"\$$#\""; }
if [ `uname` = "Darwin" ]; then
    alias o='open'
    alias ll='ls -laG'
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
    alias gvim='/Applications/MacVim.app/Contents/MacOS/mvim --remote-tab-silent'
    alias less='/Applications/MacVim.app/Contents/Resources/vim/runtime/macros/less.sh'
    alias eclipse='open /Applications/eclipse/Eclipse.app'
    alias md='open -a "Marked 2"'
    pbcopy-chomp() { local s; read -rd '' s; echo -n "$s" | pbcopy; }
    pbcopy-file() { cat "$1" | pbcopy-chomp; }
    # QuickLook
    alias ql='qlmanage -p "$1" >& /dev/null'
    # 画像サイズ取得
    alias imgsize="mdls -name kMDItemPixelWidth -name kMDItemPixelHeight"
    # 時間のかかるコマンドが終了したらDockでバウンドさせる
    beep-at-finished() { "$@"; beep; }
    beep-on-error() { "$@" || beep; }
    alias phpunit='beep-at-finished phpunit'
    alias behat='beep-at-finished behat'
    # コマンド結果を通知センターに送る
    ntf() { if "$@"; then local t="(*'-') < Successful !!"; else t="( >_<)? < Failed..."; fi; echo "display notification \"$@\" with title \"$t\""|osascript; }
    # tar でリソースフォーク (`._`で始まるファイル) を含めないようにする
    export COPYFILE_DISABLE=1
else
    alias ll='ls -la --color'
    alias less='/usr/share/vim/vim74/macros/less.sh'
fi

alias top='screen -t top top'
alias grep='grep --color=auto'
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

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

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
export GIT_PAGER=less
export GIT_EDITOR=vim
export SVN_EDITOR=vim
if type lv > /dev/null 2>&1; then
    export LV='-c -Ou8'
fi
#export CACA_DRIVER=x11
export CACA_DRIVER=ncurses

# Go Programing Language (via GVM)
if [ -s $HOME/.gvm/scripts/gvm ]; then
    export GO_VERSION=go1.3
    export GVM_PKGSET=local
    source $HOME/.gvm/scripts/gvm
    gvm use $GO_VERSION
    gvm pkgset create $GVM_PKGSET
    gvm pkgset use $GVM_PKGSET
fi
# Google Cloud SDK
export GOOGLE_CLOUD_SDK=$HOME/google-cloud-sdk
if [ -d $GOOGLE_CLOUD_SDK ]; then
    export APPENGINE_SDK=$GOOGLE_CLOUD_SDK/platform/google_appengine
    export APPENGINE_APP_CFG=$GOOGLE_CLOUD_SDK/bin/appcfg.py
    export APPENGINE_DEV_APPSERVER=$GOOGLE_CLOUD_SDK/bin/dev_appserver.py
    export PATH=$GOOGLE_CLOUD_SDK/bin:$PATH
fi
