#! /bin/bash

install_path="/usr/local/bin/notes"
root_path="$HOME/.notes"

read -p "Install notes to $install_path: [y] or enter absolute path: " answer
if [[ $answer != "y" ]]; then
    install_path=$answer
fi

read -p "Notes will be store in $root_path: [y] or enter absolute path: " answer
if [[ $answer != "y" ]]; then
    root_path=$answer
fi

if [[ -z $root_path ]] || [[ -z $install_path ]]; then
    echo "Failure to install, paths need values"
    exit 1
fi

mkdir -p $root_path
touch $root_path/.last_note

# curl -m 10 -o /tmp/notes https://github.com/wenn/
cp ~/world/notes/notes.bash /tmp/notes
sed -i "" "s|# DEFAULT_ROOT_CHANGE_ME #|DEFAULT_ROOT=$root_path|g" /tmp/notes

mv /tmp/notes $install_path
if [[ -f $install_path ]]; then
    chmod a+x $install_path
else
    echo "Fail to install"
fi
