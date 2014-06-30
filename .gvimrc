"set ts=4 sts=4 sw=4 tw=0 : (この行に関しては:help modelineを参照)
set modeline

" ウィンドウ関連の設定
set termencoding=japan
set columns=142 " ウィンドウ幅
set lines=76 " ウィンドウ高
set cmdheight=2 " コマンドラインの高さ(GUI使用時)
colorscheme desert " カラースキーム
winpos 8 30 " 起動時のWindowの位置(:winposで現在の位置が取得できる)
set shortmess+=I " 起動時のメッセージを消す(ウガンダに寄付しないフトドキモノ用)
"autocmd GUIEnter * simalt ~x " 起動時に最大化する
set guioptions-=T " ツールバー表示しない

" 環境別設定
if has('win32')
    " Windows用
    set encoding=utf-8 " 端末の文字コード
    set guifont=MS_Gothic:h8:cSHIFTJIS
    set linespace=1 " 行間隔
    if has('kaoriya')
        set ambiwidth=auto " 一部のUCS文字の幅を自動計測して決める
    endif
    set showtabline=0 " タブを表示しない
    set linespace=2 " 行間隔
    set directory=$TEMP
    set clipboard=unnamed "ヤンクしたらクリップボードにも送る
elseif has('gui_macvim')
    winpos 10 25
    "set guifont=Osaka-Mono:h9
    "set guifont=Monaco:h10
    "set guifont=Monaco:h10
    "set guifontwide=Osaka-Mono:h9
    set guifont=Ricty:h12
    set guifontwide=Ricty:h12
    set linespace=1 " 行間隔
    set showtabline=0   " タブを表示しない
    set imdisable       " IMを無効化
    "set iminsert=0 imsearch=0 noimdisable
    set transparency=10 " 透明度を指定
    map <silent> gw :macaction selectNextWindow:
    map <silent> gW :macaction selectPreviousWindow:
    "set macatsui " for antialias
    set guicursor=a:blinkon0
    " 挿入モード終了時に IME 状態を保存しない
    inoremap <silent> <Esc> <Esc>
    inoremap <silent> <C-[> <Esc>
elseif has('gui_mac')
    set gfn=Osaka-Mono:h12
    set gfw=Osaka-Mono:h9
    "set gfn=DFHSGothic-W7-WIN-RKSJ-H:h14
    "set gfw=DFHSGothic-W7-WIN-RKSJ-H:h12
    set linespace=1 " 行間隔
    "set antialias
    "set antialias enc=utf-8 tenc=macroman gfn=Monaco:h12
    "set transparency=192 " 透明度を指定(0:完全透明?255:不透明)
    "set showtabline=2 " タブを常に表示
    set imdisable " IMを無効化
    set transparency=224
elseif has('xfontset')
    " UNIX用 (xfontsetを使用)
    set guifontset=a12,r12,k12
endif

set ch=1 " Make command line two lines high
set mousehide " Hide the mouse when typing text

" for menu mojibake
source $VIMRUNTIME/delmenu.vim
set langmenu=menu_ja_jp.utf-8.vim
source $VIMRUNTIME/menu.vim

" for nowrap scan
set nowrapscan
autocmd BufRead *.as set filetype=actionscript
autocmd BufRead *.thtml set filetype=php

" for use javasyntax highlight
:let java_highlight_all=1

" for transparency
"set transparency=200
" for Insert with changint to Japanese off
set iminsert=0 imsearch=0

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
