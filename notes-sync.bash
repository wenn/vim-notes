#! /bin/bash

# DEFAULT_ROOT_CHANGE_ME #
NOTES_ROOT=${DEFAULT_ROOT:-"$HOME/.notes"}
source $NOTES_ROOT/.config

cd $NOTES_ROOT
if [[ ! -z $NOTES_GIT_URL ]]; then
    if [[ -z $(git remote -vv) ]]; then
        git remote add origin $NOTES_GIT_URL 2>>$NOTES_ROOT/.error_log
        git fetch origin  2>>$NOTES_ROOT/.error_log
    fi

    (
        git fetch origin 2>>$NOTES_ROOT/.error_log
        git add -A 2>>$NOTES_ROOT/.error_log
        git commit -m "installation commit" 2>>$NOTES_ROOT/.error_log
        git rebase origin/master 2>>$NOTES_ROOT/.error_log
        git push origin master 2>>$NOTES_ROOT/.error_log
    )
fi
