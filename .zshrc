# .zshrc
if [ -f $HOME/.profile ]; then
    source $HOME/.profile
fi

setopt ignore_eof    # Ctrl+Dでログアウトしないようにする
setopt IGNOREEOF
setopt noflowcontrol # Ctrl+S, Ctrl+Q でのフロー制御を無効
#bindkey -v
bindkey "^?"    backward-delete-char
bindkey "^H"    backward-delete-char
bindkey "[3~" delete-char
bindkey "[1~" beginning-of-line
bindkey "[4~" end-of-line
export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>' # 単語の区切り（スラッシュでも区切る）

#setopt auto_cd                 # ディレクトリ名だけで cd する
setopt auto_pushd              # cd で pushd する
setopt pushd_ignore_dups       # pushd で同じディレクトリを push しない
setopt rmstar_wait             # rm * を実行する前に確認

# コマンド履歴
HISTFILE=~/.zsh_history        # 履歴をファイル保存する
HISTSIZE=6000000               # メモリ上の履歴の数
SAVEHIST=6000000               # ファイル保存される履歴の数
setopt hist_no_store           # historyコマンドは履歴に含めない
setopt hist_ignore_dups        # 直前の重複コマンドを削除
setopt hist_ignore_all_dups    # 重複コマンドは古い方を削除
setopt hist_ignore_space       # スペースで始まるコマンド行は履歴に残さない (パスワードを含む場合等に使う)
setopt hist_reduce_blanks      # 余分な空白は詰める
setopt share_history           # 履歴の共有
setopt extended_history        # 履歴ファイルに時刻を記録
setopt hist_verify             # 履歴を呼び出してから実行までに一旦編集可能
setopt hist_expand             # 補完時にヒストリを自動的に展開
history-all() { history -E 1 } # 全履歴の一覧を出力する
alias history-list='history-all|sed -e "s/^ *//"|awk -F"  " '\''{print $3}'\'''
alias history-grep='history-all|sed -e "s/^ *//"|awk -F"  " '\''BEGIN{OFS="  "}{print $2,$3}'\''|grep --color=auto -i'

# 補完機能
# zstyle ':completion:*:default' menu select=1
# zstyle ':completion:*' list-colors di=34 fi=0
# コマンドオプション等コマンド特有の補完を有効にする
autoload -U compinit
compinit
setopt complete_aliases        # エイリアスコマンドでも補完
setopt list_types              # 補完候補一覧でファイル種別マークを表示
setopt auto_list               # 補完候補が複数ある時に、一覧表示
setopt auto_menu               # 補完キー (Tab, Ctrl+I) 連打で候補を自動補完
setopt list_packed             # 補完結果をできるだけ詰める
setopt auto_param_slash        # ディレクトリ名補完で末尾に / を付加
setopt mark_dirs               # ファイル名展開でディレクトリにマッチしたら末尾に / を付加
setopt nolistbeep              # 補完候補表示時にビープ音を鳴らさない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完の時に大文字小文字を区別しない
# 補完したら、カーソルを文末に移動
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
# コマンド補完キー設定
bindkey "^P" history-beginning-search-backward-end
bindkey "^[p" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^[n" history-beginning-search-forward-end
# ssh ホスト名補完のカスタマイズ
_ssh() {
  compadd `grep -v '^#' ~/.ssh/config | fgrep 'Host ' | awk '{ for(i=2;i<=NF;++i) { print $i }}' | sort`
}
_ssh_hosts() {
  compadd `grep -v '^#' ~/.ssh/config | fgrep 'Host ' | awk '{ for(i=2;i<=NF;++i) { print $i }}' | sort`
}

# 左プロンプト
setopt prompt_subst
#PROMPT=$'%{\e[$[32+RANDOM%5]m%}%U%B[%!]%b%u%{\e[m%}%c %0(?|(*\'-\'%)|%18(?|Zz.( -_-%)|%{\e[31m%}( ;_;%)?)) <%{\e[m%} '
PROMPT=$'%{\e[$[32+RANDOM%5]m%}%U%B[%!]%b%u%{\e[m%}%~ %0(?|(*\'-\'%)|%18(?|Zz.( -_-%)|%{\e[31m%}( ;_;%)?)) <%{\e[m%} '
# カレントディレクトリフルパスで表示するように変更↑

# Gitとかバージョン管理の情報を右プロンプトに表示
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"

# もしかして機能
setopt correct
SPROMPT=$'%{\e[33m%}(*\'o\'%)? .｡oO( もしかして%{\e[m%} %U%B%r%b%u %{\e[33m%}かも? [そう!(y),そのまま(n),なおす(e),やめる(a)]:%{\e[m%} '

# GNU Screen のタイトル（キャプション）をカレントディレクトリ名にする
_gnu_screen_title() {
  if [ "$TERM" = 'screen' -o "$TERM" = 'screen-256color' ]; then
    echo -ne "\ek$(basename ${PWD/#${HOME}/\~})\e\\"
  fi
}
_gnu_screen_title
chpwd() {
  _gnu_screen_title
}

# Google Cloud SDK
if [ -f "${GOOGLE_CLOUD_SDK}/path.zsh.inc" ]; then
  source "${GOOGLE_CLOUD_SDK}/path.zsh.inc"
fi
if [ -f "${GOOGLE_CLOUD_SDK}/completion.zsh.inc" ]; then
  source "${GOOGLE_CLOUD_SDK}/completion.zsh.inc"
fi

# kerl
if [ -d "${KERL_ROOT}/bin/zsh_completion" ]; then
  fpath=($fpath "${KERL_ROOT}/bin/zsh_completion")
fi
## Chef DK
#if type -p chef &>/dev/null; then
#    eval "$(chef shell-init zsh)"
#fi

# Docker CLI
if [ -s "${DOCKER_DIR}/init-zsh.sh" ]; then
  source "${DOCKER_DIR}/init-zsh.sh" || true
fi

if [ -x "${HOMEBREW_DIR}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "${HOMEBREW_DIR}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" || true
fi
