#! /usr/bin/env bash

# DEFAULT_ROOT_CHANGE_ME #

NOTES_ROOT=${DEFAULT_ROOT:-"$HOME/.notes"}
DIGIT_REGEX="^[0-9]+$"
HELP_TEXT=$(cat <<-EOM
Prompt: notes
Last:   notes last|l
Cat:    notes cat|c
EOM)

function notes_default(){
    last_note=$(cat $NOTES_ROOT/.last_note 2>/dev/null)

    if [[ -z $last_note ]] || [[ ! -f $NOTES_ROOT/$last_note ]]; then
        echo "notes.txt"
    else
        echo $last_note
    fi
}

function notes_prompt() {
    action=$1
    target=$2

    clear

    until [[ $action == "q" ]]; do
        index=0
        for fname in $NOTES_ROOT/*.txt; do
            let index+=1
            file_name=$(basename $fname)
            file_name=${file_name%.*}

            if [[ $action == "search" ]]; then
                regex=.*$(echo $target | fold -w1 | tr '\n' ' ' | sed 's| |.*|g')
                if [[ $file_name =~ $regex ]]; then
                    echo -e "$index. $file_name"
                fi
            else
                echo -e "$index. $file_name"
            fi
        done

        echo ""
        echo "To quit:   q"
        echo "To edit:   <number>"
        echo "To create: <name>"
        echo "To search: s <name> | hit <enter> to reset"
        echo "To remove: rm <number|name>"
        echo "To rename: mv <number|name> <new name>"
        echo ""
        read ANSWER

        action=$(echo $ANSWER | cut -d " " -f 1)
        target=$(echo $ANSWER | cut -d " " -f 2)
        new_name=$(echo $ANSWER | cut -d " " -f 3)

        # edit a note
        if [[ $action =~ $DIGIT_REGEX ]]; then
            notes_view "edit" $action

        # Rename a note
        elif [[ $action == "mv" ]]; then
            new_name=$3
            notes_rm_or_mv "mv" $target $new_name

        # Remove a note
        elif [[ $action == "rm" ]]; then
            notes_rm_or_mv "rm" $target

        # Search for a note
        elif [[ $action == "s" ]]; then
            notes_prompt "search" $target

        # create a note
        elif [[ $action != "q" && ! -z $action ]]; then
            notes_view "edit" $target

        # reset
        elif [[ -z $action ]]; then
            notes_prompt
        fi

        clear
    done

    notes-sync
}

function notes_rm_or_mv(){
    action=$1
    target=$2
    new_name=$3
    index=0

    if [[ ! -z $target ]]; then
        if [[ $target =~ $DIGIT_REGEX ]]; then
            for fname in $NOTES_ROOT/*.txt; do
                let index+=1
                if [[ $target == $index ]]; then
                    target=$fname
                fi
            done
        else
            target=$NOTES_ROOT/$target.txt
        fi

        if [[ $action == "rm" ]]; then
            echo "Remove this note? $target: [y]"
            read ANSWER
            if [[ $ANSWER == "y" ]]; then
                rm $target
            fi
        elif [[ $action == "mv" ]]; then
           mv $target $NOTES_ROOT/$new_name.txt
        fi
    else
        echo "Usage: notes rm <note name>"
        exit 1
    fi

    notes-sync
}

function notes_view(){
    action=$1
    target=$2
    index=0

    if [[ $target =~ $DIGIT_REGEX ]]; then
        for fname in $NOTES_ROOT/*.txt; do
            let index+=1
            if [[ $target == $index ]]; then
                target=$(basename $fname)
            fi
        done
    elif [[ ! -z $target ]]; then
        target=$target.txt
    else
        target=$(notes_default)
    fi

    if [[ $action == "view" ]]; then
        cat $NOTES_ROOT/$target
    else
        vim $NOTES_ROOT/$target || vi $NOTES_ROOT/$target
    fi

    echo $target > $NOTES_ROOT/.last_note
}

function notes_help(){
   echo "$HELP_TEXT" | less
}

function notes_cat() {
    for fname in $NOTES_ROOT/*.txt; do
        let index+=1
        file_name=$(basename $fname)
        file_name=${file_name%.*}
        contents+="==========\n"
        contents+="$index. $file_name"
        contents+="\n==========\n\n"

        contents+=`cat $fname`
        contents+="\n\n"
    done

    echo -e "$contents" | less
}

function main(){
    notes-sync

    action=$1
    target=$2


    # Last notes
    if [[ $action == "last" ]] || [[ $action == "l" ]]; then
        notes_view

    # Cat notes
    elif [[ $action == "cat" ]] || [[ $action == "c" ]]; then
        notes_cat

    # Help
    elif [[ $action == "help" ]] || [[ $action == "h" ]]; then
        notes_help

    # View a note
    elif [[ $action == "view" ]] || [[ $action == "v" ]]; then
        notes_view "view" $target
    else
        notes_prompt
    fi
}

main $1 $2 $3
