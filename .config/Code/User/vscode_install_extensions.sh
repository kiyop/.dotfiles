#!/bin/sh

# 使用中の拡張
VSCODE_EXTLIST=(
  # 【汎用】スタイル・見栄え関連
  bceskavich.theme-dracula-at-night
  PKief.material-icon-theme
  # 【汎用】エディター関連
  eamodio.gitlens
  wmaurer.change-case
  shardulm94.trailing-spaces
  EditorConfig.EditorConfig
  mikestead.dotenv
  eriklynd.json-tools
  vitaliymaz.vscode-svg-previewer
  # 【汎用】開発・デバッガー関連
  ms-azuretools.vscode-docker
  # ms-vscode.remote-explorer
  # ms-vscode-remote.remote-containers
  # ms-vscode-remote.remote-ssh
  # ms-vscode-remote.remote-ssh-edit
  # ms-vscode-remote.remote-wsl
  # ms-vscode-remote.vscode-remote-extensionpack
  # 言語別の拡張
  xdebug.php-debug
  zobo.php-intellisense
  dbaeumer.vscode-eslint
  esbenp.prettier-vscode
  octref.vetur
  svelte.svelte-vscode
  JuanBlanco.solidity
)

# 未使用だけどインストールしておくもの
VSCODE_EXTLIST_UNUSED=(
  ms-vscode.live-server
)

for e in ${VSCODE_EXTLIST[@]}; do
  code --install-extension $e
done
for e in ${VSCODE_EXTLIST_UNUSED[@]}; do
  code --install-extension $e
  code --disable-extension $e
done
