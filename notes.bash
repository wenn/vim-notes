#! /bin/bash

# DEFAULT_ROOT_CHANGE_ME #

NOTES_ROOT=${DEFAULT_ROOT:-"$HOME/.notes"}
DIGIT_REGEX="^[0-9]+$"
HELP_TEXT=$(cat <<-EOM
List:   notes list|l
Prompt: notes prompt|p
Cat:    notes cat|c
View:   notes <v|view> <name|number>; prints to stdout
Edit:   notes <name|number>; leave blank to edit last note.
Create: notes <name|number>
Remove: notes <rm> <name|number>
Rename: notes <mv> <name|number>
EOM)

function notes_default(){
    last_note=$(cat $NOTES_ROOT/.last_note 2>/dev/null)
    if [[ -z $last_note ]] || [[ ! -f $NOTES_ROOT/$last_note ]]; then
        echo "notes.note"
    else
        echo $last_note
    fi
}

function notes_list() {
    as_prompt=$1
    [[ $as_prompt == "prompt" ]] && clear

    until [[ $action == "q" ]]; do
        index=0
        for fname in $NOTES_ROOT/*.note; do
            let index+=1
            file_name=$(basename $fname)
            file_name=${file_name%.*}
            echo -e "$index. $file_name"
        done

        if [[ $as_prompt == "prompt" ]]; then
            echo ""
            echo "To quit:   q"
            echo "To edit:   <number>"
            echo "To create: <name>"
            echo "To remove: rm <number>"
            echo "To rename: mv <number>"
            echo ""
            read ANSWER

            action=$(echo $ANSWER | cut -d " " -f 1)
            target=$(echo $ANSWER | cut -d " " -f 2)

            main $action $target
            clear
        else
            action="q"
        fi
    done
}

function notes_rm_or_mv(){
    action=$1
    target=$2
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

        if [[ $action == "rm" ]]; then
            echo "Remove this note? $target: [y]"
            read ANSWER
            if [[ $ANSWER == "y" ]]; then
                rm $target
            fi
        elif [[ $action == "mv" ]]; then
            echo "Rename note $target to?: (x - cancel)"
            read ANSWER
            if [[ $ANSWER != "x" ]]; then
               mv $target $NOTES_ROOT/$ANSWER.note
            fi
        fi
    else
        echo "Usage: notes rm <note name>"
        exit 1
    fi
}

function notes_view(){
    action=$1
    target=$2
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
    for fname in $NOTES_ROOT/*.note; do
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
    action=$1
    target=$2

    # List notes
    if [[ $action == "list" ]] || [[ $action == "l" ]]; then
        notes_list

    # Interaction Prompt
    elif [[ $action == "prompt" ]] || [[ $action == "p" ]]; then
        notes_list "prompt"

    # Cat notes
    elif [[ $action == "cat" ]] || [[ $action == "c" ]]; then
        notes_cat

    # Rename a note
    elif [[ $action == "mv" ]]; then
        notes_rm_or_mv "mv" $target

    # Remove a note
    elif [[ $action == "rm" ]]; then
        notes_rm_or_mv "rm" $target

    # Help
    elif [[ $action == "help" ]] || [[ $action == "h" ]]; then
        notes_help

    # View a note
    elif [[ $action == "view" ]] || [[ $action == "v" ]]; then
        notes_view "view" $target

    # Edit a note ( DEFAULT )
    elif [[ $action != "q" ]]; then
        target=$action
        notes_view 'edit' $target
    fi
}

main $1 $2
