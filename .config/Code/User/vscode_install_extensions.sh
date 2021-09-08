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
    cssho.vscode-svgviewer
    # 【汎用】開発・デバッガー関連
    ms-azuretools.vscode-docker
    msjsdiag.debugger-for-chrome
    formulahendry.code-runner
    # 言語別の拡張
    felixfbecker.php-debug
    felixfbecker.php-intellisense
    eg2.vscode-npm-script
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    octref.vetur
)

# 未使用だけどインストールしておくもの
VSCODE_EXTLIST_UNUSED=(
    Tyriar.sort-lines
    patrys.vscode-code-outline
    jebbs.plantuml
    ritwickdey.LiveServer
    bungcip.better-toml
    karunamurti.haml
    golang.go
    rust-lang.rust
    Dart-Code.dart-code
    Dart-Code.flutter
    JuanBlanco.solidity
)

for e in ${VSCODE_EXTLIST[@]}; do
    code --install-extension $e
done
for e in ${VSCODE_EXTLIST_UNUSED[@]}; do
    code --install-extension $e
    code --disable-extension $e
done
