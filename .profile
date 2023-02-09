# .profile

# ----------------------------------------
# 基礎的な初期化
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export LANG=ja_JP.UTF-8
export IGNOREEOF=10

# 2017/11/13 一旦、GNU screen の起動をターミナルソフト側で行うようにして様子見。もし問題があれば戻すかも
## まずは GNU screen を立ち上げる
#if [ "$TERM" != 'screen' -a "$TERM" != 'screen-256color' -a "$TERM" != 'dumb' ]; then
#    type -p screen &>/dev/null && screen -xRU || screen -D -RR -U
#fi

# ----------------------------------------
# 環境に依存しない全般的な初期化
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

# よく使うコマンド群
alias beep='bash -c "echo -ne \"\\a\""'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias remove-blanks='sed "s/^[[:blank:]]*//;s/[[:blank:]]*$//"'
alias remove-blank-lines='sed "s/^[[:blank:]]*//;s/[[:blank:]]*$//;/^$/d"'
alias trim=remove-blank-lines
type -p tree &>/dev/null && alias tree='tree -aNC -I ".git"'
mkdircd() { mkdir -p "$@" && eval cd "\"\$$#\""; } # mkdir and cd
hr() { local s l; if [ $# -ge 1 ]; then s="$1"; else s="-"; fi; for i in $(seq 1 $COLUMNS); do l="$s$l"; done; echo "$l"; }
printenv+() { for e in $(printenv|grep -v "^\t\|^_"|cut -d= -f1|([ $# -ge 1 ] && grep "$@" || cat)|sort); do echo "$e=$(printenv $e)"; done; }
if type -p colordiff &>/dev/null; then
    alias diff='colordiff -u'
else
    alias diff='diff -u'
fi
if type -p nkf &>/dev/null; then
    alias conv-csv='nkf --overwrite --oc=UTF-8-BOM -Lw'
    alias conv-csv-win='nkf --overwrite -sLw'
fi

# ----------------------------------------
# 環境依存の初期化（先行読み込み用）
if [ -f $HOME/.profile_local_preprofile ]; then
    source $HOME/.profile_local_preprofile
fi
if [ -f $HOME/.profile_local ]; then
    source $HOME/.profile_local
fi

if [ `uname` = "Darwin" ]; then
    # macOS
    alias ll='ls -laG'
    alias lll='ls -laGh'
    alias o='open'
    alias imgsize='mdls -name kMDItemPixelWidth -name kMDItemPixelHeight' # 画像サイズ取得
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
    alias gvim='/Applications/MacVim.app/Contents/bin/mvim --remote-tab-silent'
    alias less='/Applications/MacVim.app/Contents/Resources/vim/runtime/macros/less.sh'
    alias eclipse='open /Applications/eclipse/Eclipse.app'
    [ -e "/Applications/CotEditor.app" ] && alias cot='open -a /Applications/CotEditor.app'
    [ -e "/Applications/Marked 2.app" ] && alias md='open -a "Marked 2"'
    [ -x "/Applications/Gyazo.app/Contents/MacOS/Gyazo" ] && alias gz='/Applications/Gyazo.app/Contents/MacOS/Gyazo'

    data-uri() { echo -n "data:$(file -b --mime-type $1);base64,$(base64 < $1)"; } # Data URI Scheme
    ql() { qlmanage -p "$1" >& /dev/null; }
    pbcopy-chomp() { local s; read -rd '' s; echo -n "$s" | pbcopy; }
    pbcopy-file() { pbcopy < "$1"; }
    unixtime-now() { date +%s; }
    unixtime-to-iso8601-utc() { [ -z "$1" ] && t=$(unixtime-now) || t="$1"; date -u -r "$t" +%FT%TZ; }
    unixtime-to-iso8601-tz() { [ -z "$1" ] && t=$(unixtime-now) || t="$1"; date -r "$t" +%FT%T%z; }
    iso8601-utc-to-unixtime() { date -u -jf %FT%TZ "$1" +%s; }
    iso8601-tz-to-unixtime() { date -jf %FT%T%z "$1" +%s; }
    # 時間のかかるコマンドが終了したらDockでバウンドさせる
    beep-at-finished() { "$@"; beep; }
    beep-on-error() { "$@" || beep; }
    alias phpunit='beep-at-finished phpunit'
    alias behat='beep-at-finished behat'
    ntf() {
        case $# in
            1) osascript -e "display notification \"$1\"" ;;
            2) osascript -e "display notification \"$2\" with title \"$1\"" ;;
            3) osascript -e "display notification \"$3\" with title \"$1\" subtitle \"$2\"" ;;
            *) echo "usage: $0 [<title> [<subtitle>]] <message>"; return 1 ;;
        esac
    }
    # コマンド結果を通知センターに送る
    ntf-cmd() {
        local r=$("$@" 2>&1) t=$([ $? = 0 ] && echo "(*'-') < Successful !!" || echo "( >_<)? < Failed...")
        echo "display notification \"$r\" with title \"$t\" subtitle \"$@\"" | osascript;
    }
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

# ----------------------------------------
# GNU screen 環境下でのエイリアスコマンド
# ※SSH 接続先などでは無効
if [ -z "$SSH_CLIENT" -a -z "$SSH_CONNECTION" ]; then
    ssh-on-screen() { eval SERVER=\${$#}; screen -t $SERVER ssh "$@"; }
    alias ssh=ssh-on-screen
    alias top='screen -t top top'
    alias grep='grep --color=auto --exclude-dir=.git'
    alias tailf='screen -t tailf tail -f'
    alias redis-cli='screen -t redis redis-cli'
    alias eq='screen -t earthquake earthquake'
    if [ `uname` = "Darwin" ]; then
        alias vi='screen -t vim /Applications/MacVim.app/Contents/MacOS/Vim'
        alias http-serv='screen -t http php -S 0.0.0.0:8000 && open http://localhost:8000/'
    else
        alias vi='screen -t vim vim'
        alias http-serv='screen -t http php -S 0.0.0.0:8000'
    fi
fi

# ----------------------------------------
# 開発関連のコマンド群
alias check-ip='curl inet-ip.info' # グローバル IP を調べる (要 curl)
alias show-path='echo -e ${PATH//:/"\n"}' # path をリストアップ
alias aws='env -u MANPAGER aws'
alias alt-pwgen="</dev/urandom LANG=C tr -dc A-Za-z0-9 | head -c$1"
alias alt-pwgen-strict="</dev/urandom LANG=C tr -dc [:graph:] | head -c$1"
teetime() { while IFS= read l; do d=$(echo "$l" | sed "s/^/[$(date +'%F %T')] /"); echo "$d"; [ -n "$1" ] && echo "$d" >> "$1"; done; }
teetime+() { [ -n "$1" ] && teetime "$1-$(date +%Y%m%d_%H%M%S)" || teetime; }
outcome() {
    t=$(date +%s); "$@"; e=$?; t=$(($(date +%s) - $t)); printf '\nExited with code %d\n' $e;
    printf 'Done in %d days %02d:%02d:%02d (%d sec.)\n' $(($t/86400)) $(($t%86400/3600)) $(($t%3600/60)) $(($t%60)) $t;
}
logging() { [ $# -ge 2 ] && { outcome "${@:2}" 2>&1 | teetime+ "$1"; } || { echo "usage: $0 <log_file> <command>..."; return 1; } }

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

# ----------------------------------------
# 以下、外部スクリプト系の読み込み

# Homebrew
export HOMEBREW_BIN="/opt/homebrew/bin/brew"
[[ -s "${HOMEBREW_BIN}" ]] && eval "$(${HOMEBREW_BIN} shellenv)"
# direnv
type -p direnv &>/dev/null && eval "$(direnv hook $(basename ${SHELL}))"
# emscripten (via emsdk-portable)
export EMSDK_PORTABLE_ROOT="${HOME}/.emsdk-portable"
[[ -s "${EMSDK_PORTABLE_ROOT}/emsdk_env.sh" ]] && source "${EMSDK_PORTABLE_ROOT}/emsdk_env.sh" &>/dev/null
# Rust toolchain (including rustc, cargo, and rustup)
# https://www.rust-lang.org/
export CARGO_ROOT="${HOME}/.cargo"
[[ -s "${CARGO_ROOT}/bin/cargo" ]] && export PATH="${CARGO_ROOT}/bin:${PATH}"
# PHP (via phpbrew)
export PHPBREW_DIR="${HOME}/.phpbrew"
if [ -s "${PHPBREW_DIR}/bashrc" ]; then
    source "${PHPBREW_DIR}/bashrc"
fi
# Ruby (via rbenv)
export RBENV_DIR_="${HOME}/.rbenv"
if type -p rbenv &>/dev/null && [ -d "${RBENV_DIR_}" ]; then
    eval "$(rbenv init -)"
fi
# Go Programing Language (via GVM)
export GVM_DIR="${HOME}/.gvm"
if [ -s "${GVM_DIR}/scripts/gvm" ]; then
    source "${GVM_DIR}/scripts/gvm"
fi
# Node.js (via NVM)
export NVM_DIR="${HOME}/.nvm"
if [ -s "${NVM_DIR}/nvm.sh" ]; then
    source "${NVM_DIR}/nvm.sh"
    #if type -p ngrok &>/dev/null; then
    #    alias ngrok='screen -t ngrok ngrok'
    #fi
fi
export NVM_BIN_DIR="/opt/homebrew/opt/nvm"
[ -s "${NVM_BIN_DIR}/nvm.sh" ] && . "${NVM_BIN_DIR}/nvm.sh"
[ -s "${NVM_BIN_DIR}/etc/bash_completion.d/nvm" ] && . "${NVM_BIN_DIR}/etc/bash_completion.d/nvm"
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
# Elixir (via kiex, need Erlang/OTP)
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

    # Docker コンテナ用モニタリングツール
    alias ctop='screen -t ctop docker run --rm -ti --name=ctop -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest'
    # URL から Web サーバーの動作環境や利用ライブラリ、外部サービス等を調べる
    wappalyzer() {
        case $# in
            1) docker run --rm wappalyzer/cli "$1" ;;
            *) echo "usage: $0 <url>"; return 1 ;;
        esac
    }
fi
# Android SDK
export ANDROID_SDK=$HOME/Library/Android/sdk
if [ -d "${ANDROID_SDK}" ]; then
    export PATH=${PATH}:${ANDROID_SDK}/emulator:${ANDROID_SDK}/platform-tools:${ANDROID_SDK}/tools
    type -p exp &>/dev/null && exp path &>/dev/null # for expo
fi
# Flutter SDK
export FLUTTER_SDK=$HOME/.flutter
if [ -d "${FLUTTER_SDK}" ]; then
    export PATH=${PATH}:${FLUTTER_SDK}/bin
fi


# ----------------------------------------
# 環境依存の初期化（後付け用）
if [ -f $HOME/.profile_local_postprofile ]; then
    source $HOME/.profile_local_postprofile
fi

