#! /bin/bash

# DEFAULT_ROOT_CHANGE_ME #
NOTES_ROOT=${DEFAULT_ROOT:-"$HOME/.notes"}
source $NOTES_ROOT/.config

if [[ -z $(git remote -vv) ]]; then
    git remote add origin $NOTES_GIT_URL 2>/dev/null
fi

git fetch 2>/dev/null
git add -A 2>/dev/null
git commit -m "installation commit" 2>/dev/null
git rebase origin/master 2>/dev/null
git push origin master 2>/dev/null
