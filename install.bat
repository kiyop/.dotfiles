@echo off

whoami /PRIV | FIND "SeLoadDriverPrivilege" > NUL
if not errorlevel 1 goto INSTALL
echo Please run as administrator for installing.
pause
exit

:INSTALL
set src=%~dp0
set dst=%USERPROFILE%
if exist "%dst%"\.gitconfig if not exist "%dst%"\.gitconfig_local (
    rename "%dst%"\.gitconfig .gitconfig_local
)
call :MAKE_SYMLINK "%dst%"\.gitconfig "%src%".gitconfig
call :MAKE_SYMLINK "%dst%"\.gitignore_global "%src%".gitignore_global
call :MAKE_SYMLINK /D "%dst%"\.git_template "%src%".git_template
call :MAKE_SYMLINK "%dst%"\_vimrc "%src%".vimrc
call :MAKE_SYMLINK "%dst%"\_gvimrc "%src%".gvimrc
call :MAKE_SYMLINK /D "%dst%"\_vim "%src%".vim
call :MAKE_SYMLINK "%dst%"\.editorconfig "%src%".editorconfig
echo The installation is complete.
pause
exit

:MAKE_SYMLINK
if "%3" == "" (
    set opt=
    set ln=%1
    set trg=%2
) else (
    set opt=%1
    set ln=%2
    set trg=%3
)
if not exist "%ln%" (
    mklink %opt% "%ln%" "%trg%"
)
exit /B
