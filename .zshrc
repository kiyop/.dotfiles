# .zshrc
if [ -f $HOME/.profile ]; then
    source $HOME/.profile
fi

setopt IGNOREEOF
setopt noflowcontrol
bindkey -e
bindkey "^?"    backward-delete-char
bindkey "^H"    backward-delete-char
bindkey "[3~" delete-char
bindkey "[1~" beginning-of-line
bindkey "[4~" end-of-line

# 補完機能
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors di=34 fi=0
# コマンドオプション等コマンド特有の補完を有効にする
autoload -U compinit
compinit

# コマンド履歴
HISTFILE=~/.zsh_history        # 履歴をファイル保存する
HISTSIZE=6000000               # メモリ上の履歴の数
SAVEHIST=6000000               # ファイル保存される履歴の数
history-all() { history -E 1 } # 全履歴の一覧を出力する
setopt hist_no_store           # historyコマンドは履歴に含めない
setopt hist_ignore_dups        # 直前の重複コマンドを削除
setopt hist_ignore_all_dups    # 重複コマンドは古い方を削除
setopt hist_ignore_space       # スペースで始まるコマンド行は履歴に残さない (パスワードを含む場合等に使う)
setopt hist_reduce_blanks      # 余分な空白は詰める
setopt share_history           # 履歴の共有
setopt extended_history        # 履歴ファイルに時刻を記録
setopt hist_verify             # 履歴を呼び出してから実行までに一旦編集可能
setopt hist_expand             # 補完時にヒストリを自動的に展開
setopt inc_append_history      # 履歴をインクリメンタルに追加
bindkey "^S" history-incremental-search-forward  # インクリメンタル検索 (前方検索)
bindkey "^R" history-incremental-search-backward # インクリメンタル検索 (後方検索)

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
SPROMPT=$'%{\e[33m%}(*\'~\'%)? .｡oO( もしかして%{\e[m%} %U%B%r%b%u %{\e[33m%}かも? [そう!(y),ちがう!(n),a,e]:%{\e[m%} '

# Google Cloud SDK
source $GOOGLE_CLOUD_SDK/completion.zsh.inc
