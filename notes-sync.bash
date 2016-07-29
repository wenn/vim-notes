#! /bin/bash

# DEFAULT_ROOT_CHANGE_ME #
NOTES_ROOT=${DEFAULT_ROOT:-"$HOME/.notes"}
source $NOTES_ROOT/.config

cd $NOTES_ROOT
if [[ ! -z $NOTES_GIT_URL ]]; then
    if [[ -z $(git remote -vv) ]]; then
        git remote add origin $NOTES_GIT_URL 2>>$NOTES_ROOT/.error_log 1>&2
        git fetch origin  2>>$NOTES_ROOT/.error_log 1>&2
    fi

    (
        git fetch origin 2>>$NOTES_ROOT/.error_log 1>&2 && \
        git add -A 2>>$NOTES_ROOT/.error_log 1>&2 && \
        git commit -m "Syncing..." 2>>$NOTES_ROOT/.error_log 1>&2 && \
        git rebase origin/master 2>>$NOTES_ROOT/.error_log 1>&2 && \
        git push origin master 2>>$NOTES_ROOT/.error_log 1>&2
    ) &
fi
