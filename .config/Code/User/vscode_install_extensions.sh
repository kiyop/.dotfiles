#!/bin/sh

# 使用中の拡張
VSCODE_EXTLIST=(
    # スタイル・見栄え関連
    bceskavich.theme-dracula-at-night
    PKief.material-icon-theme
    # エディター・言語共通
    CoenraadS.bracket-pair-colorizer-2
    shardulm94.trailing-spaces
    wmaurer.change-case
    EditorConfig.EditorConfig
    formulahendry.code-runner
    eriklynd.json-tools
    mikestead.dotenv
    cssho.vscode-svgviewer
    ms-azuretools.vscode-docker
    # 言語別の拡張
    felixfbecker.php-debug
    felixfbecker.php-intellisense
    eg2.vscode-npm-script
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    octref.vetur
    rebornix.ruby
)

# 未使用だけどインストールしておくもの
VSCODE_EXTLIST_UNUSED=(
    ritwickdey.LiveServer
    bungcip.better-toml
    karunamurti.haml
    mblode.twig-language
    ms-vscode.Go
    rust-lang.rust
    JuanBlanco.solidity
    marcostazi.VS-code-vagrantfile
)

for e in ${VSCODE_EXTLIST[@]}; do
    code --install-extension $e
done
for e in ${VSCODE_EXTLIST_UNUSED[@]}; do
    code --install-extension $e
    code --disable-extension $e
done
