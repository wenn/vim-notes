#! /bin/bash

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
    script_url=$2
    tmp_path="/tmp/$script_name"
    script_path="$install_path/$script_name"

    curl -m 10 -o $tmp_path  $script_url

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

install_script "notes" "https://raw.githubusercontent.com/wenn/vim-notes/master/notes.bash"

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
.config
.last_note
.error_log
)

touch $root_path/.config
echo -e "$config_content" > $root_path/.config
echo -e "$gitignore" > $root_path/.gitignore

install_script "notes-sync" "https://raw.githubusercontent.com/wenn/vim-notes/master/notes-sync.bash"

cd $root_path
git init 2>>$root_path/.error_log
