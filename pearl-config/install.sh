# The following variables can be used inside the hook functions:
# - *PEARL_HOME*        - Pearl location
# - *PEARL_ROOT*        - Pearl script location
# - *PEARL_PKGNAME*     - Pearl package name
# - *PEARL_PKGREPONAME* - Pearl pacakge repository name
# - *PEARL_PKGDIR*      - Pearl package location
# - *PEARL_PKGVARDIR*   - Pearl package var location
#
# Furthermore, the hook functions can use all the utility functions contained
# in the utils.sh files on both Buava and Pearl:
# https://github.com/fsquillace/buava/blob/master/lib/utils.sh
# https://github.com/pearl-core/pearl/blob/master/lib/utils/utils.sh

function post_install() {
    # To link an executable file inside the package to the PATH variable:
    # link_to_path "${PEARL_PKGDIR}/bin/mybinfile"

    # To link a config (aka dotfile) in the package to a specific program (ex: tmux).
    # (this works with bash, emacs, git, vim, zsh, fish, and more)
    # (see Buava utils.sh for complete list of recognized programs):
    # link tmux "${PEARL_PKGDIR}/lib/tmux.conf"
    sudo apt-get install -y git rsync tmux vim zsh

    sudo chsh -s "$(command -v zsh)" "${USER}"

    link "tmux" $PEARL_PKGDIR/tmux.conf
    link "vim" $PEARL_PKGDIR/vimrc
    link "zsh" $PEARL_PKGDIR/zshrc
    return 0
}

function pre_update() {
    # This hook function should be idempotent to avoid unexpected
    # results if invoked multiple times.
    return 0
}

function post_update() {
    # This hook function should be idempotent to avoid unexpected
    # results if invoked multiple times.
    #
    # Generally, this hook should act similarly to the post_install,
    # and could just be the following line:
    post_install
    return 0
}

function pre_remove() {
    unlink "tmux" $PEARL_PKGDIR/tmux.conf
    unlink "vim" $PEARL_PKGDIR/vimrc
    unlink "zsh" $PEARL_PKGDIR/zshrc

    if ask "Do you want to remove standard packages?" "N";
    then
        sudo apt-get remove -y git rsync tmux vim zsh
    fi
    return 0
}

function post_remove() {
    # To unlink an executable file inside the package from the PATH variable:
    # unlink_from_path "${PEARL_PKGDIR}/bin/mybinfile"

    # To unlink an already linked config (aka dotfile):
    # unlink tmux "${PEARL_PKGDIR}/lib/tmux.conf"
    return 0
}

# vim: ft=sh
