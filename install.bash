#! /bin/bash

install_path="/usr/local/bin/notes"

echo "Install notes to $install_path: [y] or enter path"
read answer

if [[ $answer != "y" ]]; then
    install_path=$answer
fi

if [[ ! -f $install_path ]]; then
    curl -m 10 -o $install_path https://github.com/wenn/
    if [[ -f $install_path ]]; then
        chmod a+x $install_path
    else
        echo "Fail to install"
    fi
fi
