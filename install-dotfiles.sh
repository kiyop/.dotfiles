#!/bin/bash
if [ "$__BASH__" != on ]; then __BASH__=on bash $0 "$@"; exit; fi
SRC=$(cd $(dirname $0)/$SRC;pwd)
DST=~
TRGS=(
    ".bashrc"
    ".gitconfig"
    ".gvimrc"
    ".inputrc"
    ".profile"
    ".screenrc"
    ".vim"
    ".vimrc"
    ".zshrc"
    "bin/battery-remain"
    "bin/psgrep"
)

install_dotfiles() {
    if [ -z "${FORCE}" ]; then
        for TRG in ${TRGS[@]}; do
            if [ -e "${TRG}" ]; then
                echo "File already exists. Use \``basename $0` -f\`"; exit 1
            fi
        done
    fi

    # start installation
    if [ ! -e "${DST}/bin" ]; then
        mkdir -p "${DST}/bin"
    fi
    for TRG in ${TRGS[@]}; do
        ln ${FORCE} -s ${SRC}/${TRG} ${DST}/${TRG}
    done
    echo "The Installation is complete. Please login again."
    exit
}

uninstall_dotfiles() {
    for TRG in ${TRGS[@]}; do
        rm -rf ${DST}/${TRG}
    done
    echo "The Uninstallation is complete."
    exit;
}

while getopts 'fu' OPTION; do
    case $OPTION in
        f) FORCE="-f" ;;
        u) uninstall_dotfiles ;;
        *) echo "Usage: `basename $0` [-f]"; exit 1;;
    esac
done
shift $(($OPTIND - 1))
install_dotfiles
