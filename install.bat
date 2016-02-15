@echo off
:RUNAS
whoami /PRIV | FIND "SeLoadDriverPrivilege" > NUL
IF not errorlevel 1 GOTO START
echo Please run as administrator for installing.
echo インストールするには管理者として実行してください。
pause

:START
cd /D %1\%2
set home=%USERPROFILE%
set src=%~dp0
if exist "%home%"\.gitconfig (
    rename "%home%"\.gitconfig .gitconfig_local
)
mklink "%home%"\.gitconfig "%src%".gitconfig
mklink "%home%"\.gitignore_global "%src%".gitignore_global
mklink "%home%"\_vimrc "%src%".vimrc
mklink "%home%"\_gvimrc "%src%".gvimrc
mklink /D "%home%"\_vim "%src%".vim
exit
