#!/bin/bash

# Variables
ERR_MSG="\e[1;37;41m"
GOOD_MSG="\e[1;32m"
RST_MSG="\e[0m"

# Functions
function usage () {
    ERR_CODE="${1:-0}"
    echo -e "Usage: $(basename $0) [-q] [-c]" >&2
    echo -e "  -q\tQuiet mode" >&2
    echo -e "  -c\tClear old backups" >&2
    exit ${ERR_CODE}
}

## Customising settings
function no_newline_before_prompt () {
    TARGET_FILE="${HOME}/.zshrc"
    sed -ri '/^NEWLINE_BEFORE_PROMPT/s/yes/no/' ${TARGET_FILE}
}

# Backing up old files/directories
function backup_current_settings () {
    QUIET="${1:-false}"
    [[ -d ${HOME}/.vim ]] && (mv -f ${HOME}/.vim{,-bak} \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.vim backed up${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.vim could not be backed up${RST_MSG}"))
    [[ -f ${HOME}/.tmux.conf ]] && (mv -f ${HOME}/.tmux.conf{,.bak} \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.tmux.conf backed up${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.tmux.conf could not be backed up${RST_MSG}"))
    [[ -f ${HOME}/.inputrc ]] && (mv -f ${HOME}/.inputrc{,.bak} \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.inputrc backed up${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.inputrc could not be backed up${RST_MSG}"))
    [[ -f ${HOME}/.envrc ]] && (mv -f ${HOME}/.envrc{,.bak} \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.envrc backed up${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.envrc could not be backed up${RST_MSG}"))
}

# Setting up new dotfiles
function set_up_dotfiles () {
    QUIET="${1:-false}"
    cp -Rf $(realpath $(dirname $0)/vim) ${HOME}/.vim && mkdir -p ${HOME}/.vim/backups \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.vim set${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.vim could not be set${RST_MSG}")
    cp  -f $(realpath $(dirname $0)/inputrc) ${HOME}/.inputrc \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.inputrc set${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.inputrc could not be set${RST_MSG}")
    cp  -f $(realpath $(dirname $0)/tmux.conf) ${HOME}/.tmux.conf \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.tmux.conf set${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.tmux.conf could not be set${RST_MSG}")
    cp  -f $(realpath $(dirname $0)/envrc) ${HOME}/.envrc \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.envrc set${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.envrc could not be set${RST_MSG}")
}

# Clear backed up dotfiles
function clear_backups () {
    QUIET="${1:-false}"
    [[ -d ${HOME}/.vim-bak ]] && (rm -Rf ${HOME}/.vim-bak \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.vim-bak removed${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.vim-bak could not be removed${RST_MSG}"))
    [[ -f ${HOME}/.tmux.conf.bak ]] && (rm -Rf ${HOME}/.tmux.conf.bak \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.tmux.conf.bak removed${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.tmux.conf.bak could not be removed${RST_MSG}"))
    [[ -f ${HOME}/.inputrc.bak ]] && (rm -Rf ${HOME}/.inputrc.bak \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.inputrc.bak removed${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.inputrc.bak could not be removed${RST_MSG}"))
    [[ -f ${HOME}/.envrc.bak ]] && (rm -Rf ${HOME}/.envrc.bak \
        && ([[ "${QUIET}" = "false" ]] && echo -e "${GOOD_MSG}${HOME}/.inputrc.bak removed${RST_MSG}") \
        || ([[ "${QUIET}" = "false" ]] && echo -e "${ERR_MSG}${HOME}/.inputrc.bak could not be removed${RST_MSG}"))
}

# Detecting wether bash is used or zsh
function adding_envrc_to_shell_config () {
    if [ "${SHELL##*/}" = "zsh" ]; then
        SHELLRC="${HOME}/.zshrc"
        DETECTED="y"
        no_newline_before_prompt
    elif [ "${SHELL##*/}" = "bash" ]; then
        SHELLRC="${HOME}/.bashrc"
        DETECTED="y"
    fi

    if [ "x${DETECTED}" = "xy" ]; then
        cat << EOF >> ${SHELLRC}

# Custom environment
ENVRC=\${HOME}/.envrc
[[ -f \${ENVRC} && -r \${ENVRC} ]] && source \${ENVRC}
EOF
fi
}

# Run
while getopts ":hqc" option; do
    case "${option}" in
        h) usage;;
        q) QUIET=true;;
        c) CLEAR=true;;
        *) usage 2;;
    esac
done

if [[ "${CLEAR}" = "true" ]]; then
    set_up_dotfiles ${QUIET}
    clear_backups ${QUIET}
else
    backup_current_settings ${QUIET}
    set_up_dotfiles ${QUIET}
fi
