# .profile
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export LANG=ja_JP.UTF-8
export IGNOREEOF=10

alias beep='bash -c "echo -ne \"\\a\""'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
# mkdir and cd
mkdircd() { mkdir -p "$@" && eval cd "\"\$$#\""; }
if [ `uname` = "Darwin" ]; then
    alias o='open'
    alias ll='ls -laG'
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
    alias gvim='/Applications/MacVim.app/Contents/MacOS/mvim --remote-tab-silent'
    alias less='/Applications/MacVim.app/Contents/Resources/vim/runtime/macros/less.sh'
    # QuickLook
    alias ql='qlmanage -p "$1" >& /dev/null'
    # 画像サイズ取得
    alias imgsize="mdls -name kMDItemPixelWidth -name kMDItemPixelHeight"
    # Macでは時間のかかるコマンドが終了したらDockでバウンドさせる
    beep-at-finished() { "$@"; beep; }
    beep-on-error() { "$@" || beep; }
    alias phpunit='beep-at-finished phpunit'
    alias behat='beep-at-finished behat'
    # tar でリソースフォーク (`._`で始まるファイル) を含めないようにする
    export COPYFILE_DISABLE=1
else
    alias ll='ls -la --color'
    alias less='/usr/share/vim/vim73/macros/less.sh'
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

memcache-cli() {
    #bash -c "echo -e \"$1\\nquit\"" | curl -s -T - telnet://localhost:11211;
    case $# in
        1) CMD=$1; HOST="localhost:11211" ;;
        2) CMD=$2; HOST=$1 ;;
        *) echo "usage: $0 [<host>[:<port>]] <command>"; return 1 ;;
    esac
    bash -c "echo -e \"${CMD}\\nquit\"" | curl -s -T - telnet://${HOST};
}
alias memcache-stats='memcache-cli stats'
alias memcache-reset='memcache-cli flush_all'

hr() { local s l; if [ $# -ge 1 ]; then s="$1"; else s="-"; fi; for i in $(seq 1 $COLUMNS); do l="$s$l"; done; echo "$l"; }
git-checkout-all-branches() {
    case $# in
        1) REPO=$1 ;;
        *) echo "usage: $0 <repository>"; return 1 ;;
    esac
    if [ -z $(git remote|grep -e "^${REPO}$") ]; then echo "Cannot found repository: ${REPO}"; return 1; fi
    git fetch ${REPO}
    for i in $(git branch -r|awk '{print $1}'|grep -e "^${REPO}"|grep -v "^${REPO}/HEAD$"|sed "s:${REPO}/::g"); do
        git checkout --track -b $i $REPO/$i
        git pull --rebase
    done
    git checkout master
}
git-status-all-directories() {
    case $# in
        1) CD=$(pwd); for d in $(find "$1" -follow -type d); do if [ -e $d/.git ]; then echo; echo "# $d"; cd $d; git status; cd $CD; fi; done ;;
        *) echo "usage: $0 <directory>"; return 1 ;;
    esac
}
export PAGER=less
export GIT_PAGER=less
export GIT_EDITOR=vim
export SVN_EDITOR=vim
if type lv > /dev/null 2>&1; then
    export LV='-c -Ou8'
fi
#export CACA_DRIVER=x11
export CACA_DRIVER=ncurses
