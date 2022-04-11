#!/bin/bash

cp -Rf $(realpath $(dirname $0)/vim) ${HOME}/.vim
cp -f $(realpath $(dirname $0)/inputrc) ${HOME}/.inputrc
cp -f $(realpath $(dirname $0)/tmux.conf) ${HOME}/.tmux.conf
cp -f $(realpath $(dirname $0)/envrc) ${HOME}/.envrc

if [ "${SHELL##*/}" = "zsh" ]; then
    SHELLRC="${HOME}/.zshrc"
    DETECTED="y"
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
