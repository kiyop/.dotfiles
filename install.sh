#!/bin/sh -eu
SRC=$(cd $(dirname $0);pwd)
DST=$HOME
TRGS=($(find ${SRC} ${SRC}/bin -maxdepth 1 -mindepth 1 | grep -vE "$(basename ${0})|install.bat|.git|.gitignore|README.md|.config|bin$" | sed "s!^${SRC}/!!"))

install_dotfiles() {
    if [ -z "${FORCE}" ]; then
        for TRG in ${TRGS[@]}; do
            if [ -e "${DST}/${TRG}" ]; then
                echo "Some dot-files already exists. Try \``basename $0` -f\`"; exit 1
            fi
        done
    fi

    # start installation
    if [ ! -e "${DST}/bin" ]; then
        mkdir -p "${DST}/bin"
    fi
    for TRG in ${TRGS[@]}; do
        ln ${FORCE} -sn "${SRC}/${TRG}" "${DST}/${TRG}"
    done
}

setup_vscode() {
  if [ -e "$1" ]; then
      cd "$1"
      [ -e settings.json -a ! -e settings.json.original ] && mv settings.json{,.original}
      ln ${FORCE} -sn "${SRC}/.config/Code/User/settings.json"
      [ -e keybindings.json -a ! -e keybindings.json.original ] && mv keybindings.json{,.original}
      ln ${FORCE} -sn "${SRC}/.config/Code/User/keybindings.json"
  fi
}

uninstall_dotfiles() {
    for TRG in ${TRGS[@]}; do
        rm -rf "${DST}/${TRG}"
    done
    echo "The uninstallation is complete."
    exit;
}

FORCE=""
while getopts 'fu' OPTION; do
    case $OPTION in
        f) FORCE="-f" ;;
        u) uninstall_dotfiles ;;
        *) echo "Usage: `basename $0` [-fu]"; echo "  -f  Force installation"; echo "  -u  Uninstall"; exit 1;;
    esac
done

shift $(($OPTIND - 1))
install_dotfiles
setup_vscode "${DST}/.config/Code/User"
setup_vscode "${DST}/Library/Application Support/Code/User"
echo "The installation is complete. Please login again."
exit
