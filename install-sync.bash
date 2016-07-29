#! /bin/bash

config_content=$(cat <<-EOF
# With https - https://username:password@github.com/user/repo_name.git
# With ssh - git@github.com:user/repo_name.git
# NOTES_GIT_URL=<change me>
EOF)

touch $root_path/.config


