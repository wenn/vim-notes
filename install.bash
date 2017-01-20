#! /usr/bin/env bash

if [[ $1 == "local" ]]; then
    local_flag=true
    notes_script="./notes.bash"
    notes_sync_script="./notes-sync.bash"
else
    notes_script="https://raw.githubusercontent.com/wenn/vim-notes/master/notes.bash"
    notes_sync_script="https://raw.githubusercontent.com/wenn/vim-notes/master/notes-sync.bash"
fi

install_path="/usr/local/bin/"
root_path="$HOME/.notes"

read -p "Install scripts to $install_path: [y] or enter absolute path: " answer
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

function install_script() {
    script_name=$1
    script_uri=$2
    tmp_path="/tmp/$script_name"
    script_path="$install_path/$script_name"

    if $local_flag; then
        echo "Installing from project $script_uri $tmp_path"
        cp $script_uri $tmp_path
    else
        curl -m 10 -o $tmp_path  $script_uri
    fi

    [[ ! -f $tmp_path ]] && echo "Fail to download script" && kill -INT $$
    sed -i "" "s|# DEFAULT_ROOT_CHANGE_ME #|DEFAULT_ROOT=$root_path|g" $tmp_path

    mv $tmp_path $script_path
    if [[ -f $script_path ]]; then
        chmod a+x $script_path
    else
        echo "Fail to install"
    fi
}

#################
# Install Notes #
#################

mkdir -p $root_path
touch $root_path/.last_note
touch $root_path/.error_log

install_script "notes" $notes_script

################
# Install Sync #
################

which git || kill -INT $$

config_content=$(cat <<-EOF
# With https - https://username:password@github.com/user/repo_name.git
# With ssh - git@github.com:user/repo_name.git
NOTES_GIT_URL=
EOF)

gitignore=$(cat <<-EOF
.swp
.config
.last_note
.error_log
)

[[ ! -f $root_path/.config ]] && echo -e "$config_content" > $root_path/.config
[[ ! -f $root_path/.gitignore ]] && echo -e "$gitignore" > $root_path/.gitignore

install_script "notes-sync" $notes_sync_script

cd $root_path
git init 2>>$root_path/.error_log
