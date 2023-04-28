# .bashrc
if [ -f ~/.profile ]; then
  source ~/.profile
fi

export PS1='\u@\h:\W\$ '

# GNU Screen のタイトル（キャプション）をカレントディレクトリ名にする
if [ "$TERM" = 'screen' -o "$TERM" = 'screen-256color' ]; then
  export PROMPT_COMMAND='echo -ne "\033k\033\0134\033k$(basename ${PWD/#${HOME}/\~})\033\\"'
fi

# Google Cloud SDK
if [ -d $GOOGLE_CLOUD_SDK ]; then
  source $GOOGLE_CLOUD_SDK/completion.bash.inc
fi

# Docker CLI
if [ -s "${DOCKER_DIR}/init-bash.sh" ]; then
  source "${DOCKER_DIR}/init-bash.sh" || true
fi

