NOTES_ROOT=~/.notes
ACTION=$1
TARGET=$2
DIGIT_REGEX="^[0-9]+$"

function notes_default(){
    LAST_NOTE=$(cat $NOTES_ROOT/.last_note 2>/dev/null)
    if [[ -z $LAST_NOTE ]]; then
        echo "notes.note"
    else
        echo $LAST_NOTE
    fi
}

function notes_list() {
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
    echo ""
    read ACTION
}

function notes_paths(){
    ls $NOTES_ROOT/*
}

function notes_rm(){
    index=0
    TARGET=$1
    if [[ ! -z $TARGET ]]; then
        if [[ $TARGET =~ $DIGIT_REGEX ]]; then
            for fname in $NOTES_ROOT/*.note; do
                let index+=1
                if [[ $TARGET == $index ]]; then
                    TARGET=$fname
                fi
            done
        else
            TARGET=$NOTES_ROOT/$TARGET.note
        fi

        echo "Remove this note? $TARGET: [y]"
        read ANSWER
        if [[ $ANSWER == "y" ]]; then
            rm $TARGET
        fi
    else
        echo "Usage: notes rm <note name>"
        exit 1
    fi
}

function notes_view(){
    index=0
    TARGET=$1
    if [[ $TARGET =~ $DIGIT_REGEX ]]; then
        for fname in $NOTES_ROOT/*.note; do
            let index+=1
            if [[ $TARGET == $index ]]; then
                TARGET=$(basename $fname)
            fi
        done
    elif [[ ! -z $TARGET ]]; then
        TARGET=$TARGET.note
    else
        TARGET=$(notes_default)
    fi

    vim $NOTES_ROOT/$TARGET || vi $NOTES_ROOT/$TARGET
    echo $TARGET > $NOTES_ROOT/.last_note
}

# List notes
if [[ $ACTION == "list" ]] || [[ $ACTION == "l" ]]; then
    notes_list
fi

# List notes file paths
if [[ $ACTION == "paths" ]]; then
    notes_paths

# Remove a note
elif [[ $ACTION == "rm" ]]; then
    notes_rm $TARGET

# View a note ( DEFAULT )
else
    TARGET=$ACTION
    notes_view $TARGET
fi
