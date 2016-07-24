#! /bin/bash

NOTES_ROOT=~/.notes
ACTION=$1
TARGET=$2
DIGIT_REGEX="^[0-9]+$"

function notes_default(){
    last_note=$(cat $NOTES_ROOT/.last_note 2>/dev/null)
    if [[ -z $last_note ]] || [[ ! -f $NOTES_ROOT/$last_note ]]; then
        echo "notes.note"
    else
        echo $last_note
    fi
}

function notes_list() {
    until [[ $action == "q" ]]; do
        echo ""
        index=0
        for fname in $NOTES_ROOT/*.note; do
            let index+=1
            file_name=$(basename $fname)
            file_name=${file_name%.*}
            echo -e "$index. $file_name"
        done

        echo ""
        echo "To quit: q"
        echo "To view: <number>"
        echo "To delete: rm <number>"
        echo "To create: <name>"
        echo ""
        read ANSWER

        action=$(echo $ANSWER | cut -d " " -f 1)
        target=$(echo $ANSWER | cut -d " " -f 2)

        main $action $target
    done
}

function notes_paths(){
    ls $NOTES_ROOT/*
}

function notes_rm(){
    target=$1
    index=0

    if [[ ! -z $target ]]; then
        if [[ $target =~ $DIGIT_REGEX ]]; then
            for fname in $NOTES_ROOT/*.note; do
                let index+=1
                if [[ $target == $index ]]; then
                    target=$fname
                fi
            done
        else
            target=$NOTES_ROOT/$target.note
        fi

        echo "Remove this note? $target: [y]"
        read ANSWER
        if [[ $ANSWER == "y" ]]; then
            rm $target
        fi
    else
        echo "Usage: notes rm <note name>"
        exit 1
    fi
}

function notes_view(){
    target=$1
    index=0

    if [[ $target =~ $DIGIT_REGEX ]]; then
        for fname in $NOTES_ROOT/*.note; do
            let index+=1
            if [[ $target == $index ]]; then
                target=$(basename $fname)
            fi
        done
    elif [[ ! -z $target ]]; then
        target=$target.note
    else
        target=$(notes_default)
    fi

    vim $NOTES_ROOT/$target || vi $NOTES_ROOT/$target
    echo $target > $NOTES_ROOT/.last_note
}

function main(){
    action=$1
    target=$2

    # List notes
    if [[ $action == "list" ]] || [[ $action == "l" ]]; then
        notes_list

    # List notes file paths
    elif [[ $action == "paths" ]]; then
        notes_paths

    # Remove a note
    elif [[ $action == "rm" ]]; then
        notes_rm $target

    # View a note ( DEFAULT )
    elif [[ $action != "q" ]]; then
        target=$action
        notes_view $target
    fi
}

main $ACTION $TARGET
