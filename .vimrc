" 文字コードの設定
"set encoding=utf-8 " 端末の文字コード
"set fileencoding=utf-8 " ファイルの文字コード
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
set fileformats=unix,dos,mac " 改行コードの自動認識
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif
" BOM使わない
set nobomb

" いろいろ基本設定
syntax on
filetype on
"set background=dark " 背景を黒と見なす
set number " 行番号
set notitle
"set autowrite " バッファ切り替え時などに自動的に上書き保存しちゃう
set noautowrite
set scrolloff=5 " スクロール時の余白確保
"set list
"set listchars=tab:\ \ ,extends:<,trail:\
set directory=/tmp
set laststatus=2 " ステータスラインを常に表示
" ステータスラインのカスタマイズ
"set statusline=[%L]\ %t\ %y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%r%m%=%c:%l/%L
set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']['.&ft.']'}\ %F%=%l,%c%V%8P
set statusline=[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']['.&ft.']'}\ %F%=%l,%c%V%8P

"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
    autocmd!
    autocmd InsertEnter * highlight StatusLine cterm=none ctermbg=Cyan ctermfg=Black guibg=Cyan guifg=Black
    autocmd InsertLeave * highlight StatusLine cterm=none ctermbg=White ctermfg=Black guibg=White guifg=Black
augroup END

" 補完候補のポップアップが見にくいので色変更
highlight Pmenu ctermfg=Black ctermbg=Gray guifg=Black guibg=Gray
highlight PmenuSel ctermfg=Black ctermbg=Magenta guifg=Black guibg=Magenta
highlight PMenuSbar ctermfg=Black ctermbg=Red guifg=Black guibg=Red

" 編集補助
"set paste
set pastetoggle=<F8> " ペーストモード切り替え: ペースト時に不都合なautoindentなどを無効に
set backspace=2  " バックスペースを強く
set backspace=indent,eol,start "BSでなんでも消せるようにする
set helpfile=$VIMRUNTIME/doc/help.txt " Help File
set hidden " バッファ切り替え時のundoの効果持続、バッファが編集中でも他ファイルを開ける等
set noundofile " undo ファイルは作らない
set autoread " 外部のエディタで編集中のファイルが変更されたら自動で読み直す
set formatoptions+=mM "整形オプションにマルチバイト系を追加
" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
"" カッコなどを挿入したら自動的に中へ
"inoremap {} {}<LEFT>
"inoremap () ()<LEFT>
"inoremap "" ""<LEFT>
"inoremap '' ''<LEFT>
"inoremap <> <><LEFT>
"inoremap %% %%<LEFT>
"inoremap [] []<LEFT>

" 操作補助
set history=100
" set wildmenu " コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmode=list:longest " コマンドライン補間をシェルっぽく
"set wildmode=full:list

" 検索関連
set ignorecase " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase " 検索文字列に大文字が含まれている場合は区別して検索する
"set wrapscan " 検索時に最後まで行ったら最初に戻る
set incsearch " インクリメンタルサーチを使う
set hlsearch " 検索にマッチした部分をハイライト
"if v:version < 700
if has("migemo")
  set migemo " 可能なら日本語をローマ字でインクリメンタル検索したい（migemoをつかう）
endif

" タブ・インデント周り
" tabstopはTab文字を画面上で何文字分に展開するか
" shiftwidthはcindentやautoindent時に挿入されるインデントの幅
" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=4 shiftwidth=4 softtabstop=0
set expandtab   " タブを空白文字に展開
set autoindent  " 自動インデント: 改行時に前行のインデントを引き継ぐ
"set smartindent " スマートインデント: 「{」「}」やプログラム構文などで自動的に１段下げる・上げる

" 文字装飾
set cursorline " カーソル行に下線を表示
if has("syntax")
    syntax on
    function! ActivateInvisibleIndicator()
        syntax match InvisibleJISX0208Space "　" display containedin=ALL
        highlight InvisibleJISX0208Space term=underline ctermbg=DarkBlue guibg=DarkBlue
        syntax match InvisibleTab "\t" display containedin=ALL
        highlight InvisibleTab term=underline ctermbg=DarkGrey guibg=DarkGrey
        syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
        highlight InvisibleTrailedSpace term=underline ctermbg=DarkRed guibg=DarkRed
    endf

    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif
set showmatch "括弧入力時の対応する括弧を強調

" 画面を分割してexploreを起動（あんまり使わないけど一応）
map <C-W><C-V> :Vexplore!<CR>
map <C-W><C-H> :Hexplore<CR>
map! <C-W><C-V> <Esc>:Vexplore!<CR>
map! <C-W><C-H> <Esc>:Hexplore<CR>
" ファイルの並び順
let g:netrw_sort_sequence="[\\/]$,*,\\.\\(mv\\|old\\|cp\\|bak\\|orig\\)[0-9]*[\\/]$,\\.\\(mv\\|old\\|cp\\|bak\\|orig\\)[0-9]*$,\\.o$,\\.info$,\\.swp$,\\.obj$ "

" 折りたたみ機能
set foldmethod=syntax
set foldlevel=100 " ファイルを開くとき全て開いた状態

" バックアップ・自動保存
"autocmd CursorHold * call NewUpdate()
set updatetime=500
let g:svbfre = '.\+'
set nobackup " バックアップファイルを作成しない

" Explore
let g:explHideFiles='^\.,\.gz$,\.exe$,\.zip$' " 非表示の設定(aでトグル)
let g:explDetailedHelp=0
let g:explWinSize=''
let g:explSplitBelow=1
let g:explUseSeparators=1 " ディレクトリとファイルの間くらいにセパレータ表示

" ディレクトリの自動移動
"autocmd BufEnter * execute ":lcd " . escape(expand("%:p:h"), " #\\")

" HTMLに変換する設定(TOhtml)
let html_number_lines = 0 " 行番号つけない
let html_use_css = 1 " Fontタグじゃなくて、span+cssで色付け
let use_xhtml = 1 " xhtmlに変換

" ヤンク/pでクリップボード操作
set clipboard+=unnamed

" ------------------------------
" ここから、よく使うキーバインド
nmap <Esc><Esc> :nohlsearch<CR><Esc> " <Esc>連打で検索ハイライトをさりげなく消す
nmap <Space>w :w<CR> " 保存
nmap <Space>q :q<CR> " 終了
nmap <Space><Right> :tabn<CR> " 次のタブへ移動
nmap <Space><Left> :tabp<CR> " 前のタブに移動
nmap <Space>n :bn<CR> " バッファ次へ
nmap <Space>p :bp<CR> " バッファ前へ
nmap <Space>l :ls<CR> " バッファ一覧
nmap <Space>d :bd<CR> " バッファ削除
" 前に1行挿入
nmap <C-S-O> <S-O><Esc>
imap <C-S-O> <Esc><S-O>
" 文字コード/改行コードの簡易変更
"nmap <Space><C-U> :e ++encoding=utf-8<CR>
"nmap <Space><C-E> :e ++encoding=euc-jp<CR>
"nmap <Space><C-J> :e ++encoding=cp932<CR>
"nmap <Space><C-S> :e ++encoding=cp932<CR>
nmap <Space><C-U> :set fileencoding=utf-8<CR>
nmap <Space><C-E> :set fileencoding=euc-jp<CR>
nmap <Space><C-J> :set fileencoding=cp932<CR>
nmap <Space><C-S> :set fileencoding=cp932<CR>
nmap <Space><S-D> :set fileformat=dos<CR>
nmap <Space><S-U> :set fileformat=unix<CR>
nmap <Space><S-M> :set fileformat=mac<CR>
" 表示行単位で行移動する
nmap j gj
nmap k gk
nmap <Down> gj
nmap <Up> gk
vmap j gj
vmap k gk
vmap <Down> gj
vmap <Up> gk
" makeテスト（主にパーサによる確認）
"nmap <Space>m :make<CR>
" insert mode時にc-jで抜け
"imap <C-j> <esc>
" アンドゥ
imap <C-Z> <Esc>ui
" ハードタブの入力
inoremap <C-Tab> <C-V><Tab>

" ------------------------------
" ここから、ファイルタイプ別の設定
filetype plugin indent on
autocmd FileType perl call PerlType()
autocmd! BufRead,BufNewFile *.inc set filetype=php
autocmd! BufRead,BufNewFile *.ctp set filetype=php "CakePHP template
autocmd! BufRead,BufNewFile *.cgi set filetype=perl
autocmd! BufRead,BufNewFile *.markdown set filetype=markdown
autocmd! BufRead,BufNewFile *.md set filetype=markdown
autocmd! BufRead,BufNewFile *.markdown.txt set filetype=markdown
autocmd FileType php set makeprg=php\ -l\ %
autocmd FileType php set errorformat=%m\ in\ %f\ on\ line\ %l
autocmd FileType javascript set tabstop=2 shiftwidth=2 softtabstop=0
autocmd FileType html set tabstop=2 shiftwidth=2 softtabstop=0
autocmd FileType markdown set tabstop=4 shiftwidth=4 softtabstop=0
" ファイルタイプ別の自動改行をしない
autocmd FileType * set textwidth=0

" PhpDoc用設定
source $HOME/.vim/php-doc.vim
set formatoptions=qroct
let g:date = strftime("%Y/%m/%d")
let g:author = "k2"
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>
map! =cls <ESC>:call InsertClassDoc()<CR>
map! =req <ESC>:call InsertRequireDoc(0, 0)<CR>
map! =reo <ESC>:call InsertRequireDoc(0, 1)<CR>
map! =inc <ESC>:call InsertRequireDoc(1, 0)<CR>
map! =ioc <ESC>:call InserRequireDoc(1, 1)<CR>
map! =pubf <ESC>:call InsertMethodDoc(0)<CR>
map! =prof <ESC>:call InsertMethodDoc(1)<CR>
map! =prif <ESC>:call InsertMethodDoc(2)<CR>
map! =pubp <ESC>:call InsertPropertyDoc(0)<CR>
map! =prop <ESC>:call InsertPropertyDoc(1)<CR>

" HTMLタグなどでも「%」ジャンプが効くように
source $VIMRUNTIME/macros/matchit.vim

" vimプロセス間でレジスタ（yank）を共有する
source $HOME/.vim/yanktmp.vim
map sy :call YanktmpYank()<CR>
map sp :call YanktmpPaste_p()<CR>
map sP :call YanktmpPaste_P()<CR>

let php_sql_query=1 " 文字列中のSQLをハイライトする
let php_htmlInStrings=1 " 文字列中のHTMLをハイライトする
let php_noShortTags = 1 " ショートタグ (<?を無効にする→ハイライト除外にする)
let php_folding = 1 " クラスと関数の折りたたみ(folding)を有効にする

let perl_fold=1 " Perlも折りたたみ

" for Go Programing Language
let g:gofmt_command = 'goimports' " :Fmt などで gofmt の代わりに goimports を使う
au BufWritePre *.go Fmt " 保存時に :Fmt する
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4
au FileType go compiler go

" ------------------------------
" OS 別の設定 (CUI / GUI 共通)
if has('win32')
    " Windows 向け
elseif has('mac')
    " Mac OSX 向け
    command! Marked :!open -a "Marked 2" "%"
else
    " それ以外 Linux / Unix 系
endif


" ------------------------------
" 以下、関数定義
" 自動更新
function! NewUpdate()
  let time = strftime("%H", localtime())
  exe "set backupext=.".time
  if expand('%') =~ g:svbfre && !&readonly && &buftype == ''
    silent! update
  endif
endfunction

"omni補完をタブで
function InsertTabWrapper()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k\|<\|/'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc == ''
        return "\<c-n>"
    else
        return "\<c-x>\<c-o>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" PhpDoc用関数
function! InsertClassDoc()
    execute "normal i/**\<CR>\<CR>@author " . g:author . "\<CR>@since " .  g:date . "\<CR>/\<CR>class  {\<CR>\<CR>}\<ESC>?/\*/*\<CR>/ \* \<CR>$i"
endfunction

function! InsertMethodDoc(access)
    let s:head = "/**\<CR>\<CR>@since " . g:date . "\<CR>"
    "pubf: public function
    if a:access == 0
        let s:body = "@access public\<CR>@param\<CR>@return void\<CR>/\<CR>public"
    endif
    "prof: protected function
    if a:access == 1
        let s:body = "@access protected\<CR>@param\<CR>@return void\<CR>/\<CR>protected"
    endif
    "prif: private function
    if a:access == 2
        let s:body = "@access private\<CR>@param\<CR>@return void\<CR>/\<CR>private"
    endif
    let s:foot = " function func () {\<CR>\<CR>}\<CR>\<ESC>?/\*/*\<CR> \* \<CR>$i"
    execute "normal i" . s:head . s:body . s:foot
endfunction

function! InsertPropertyDoc(access)
    let s:head = "/**\<CR>\<CR>@var \<CR>@since " . g:date . "\<CR>/\<CR>"
    "pubp: public property
    if a:access == 0
        let s:body = "public $ = ;"
    endif
    "prop: protected property
    if a:access == 1
        let s:body = "protected $ = ;"
    endif
    "prip: private property
    if a:access == 2
        let s:body = "private $ = ;"
    endif
    let s:foot = "\<ESC>?/\*/*\<CR>/ \* \<CR>$i"
    execute "normal i" . s:head . s:body . s:foot
endfunction

function! InsertRequireDoc(require, once)
    let s:head = "/**\<CR>\<CR>@since " . g:date . "\<CR>/\<CR>"
    if a:require == 0
        if a:once == 0
            let s:body = s:head . "require ''\;"
        else
            let s:body = s:head . "require_once '';"
        endif
    else
        if a:once == 0
            let s:body = s:head . "include '';"
        else
            let s:body = s:head . "include_once '';"
        endif
    endif
    execute "normal i" . s:body . "\<ESC>"
endfunction

function! Trim()
    %s///g
    %s/[ \t]\+$//g
endfunction
command! Trim :call Trim()
