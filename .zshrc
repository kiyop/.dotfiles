# .zshrc
export LANG=ja_JP.UTF-8

if [ -f $HOME/.profile ]; then
    source $HOME/.profile
fi

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
setopt hist_ignore_dups        # 重複コマンドは履歴に残さない
setopt share_history           # 履歴の共有
setopt extended_history        # 履歴ファイルに時刻を記録
history-all() { history -E 1 } # 全履歴の一覧を出力する

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
