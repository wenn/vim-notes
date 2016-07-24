NOTES_ROOT=~/.notes
ACTION=$1
TARGET=$2
DEFAULT_NOTE_TARGET=${DEFAULT_NOTE_TARGET:="notes"}
COUNTER=0
DIGIT_REGEX="^[0-9]+$"

function notes_list() {
    for fname in $NOTES_ROOT/*; do
        let COUNTER+=1
        echo -e "$COUNTER. $(basename $fname)"
    done
}

function notes_paths(){
    ls $NOTES_ROOT/*
}

function notes_rm(){
    TARGET=$1
    if [[ ! -z $TARGET ]]; then
        if [[ $TARGET =~ $DIGIT_REGEX ]]; then
            for fname in $NOTES_ROOT/*; do
                let COUNTER+=1
                if [[ $TARGET = $COUNTER ]]; then
                    rm $fname
                fi
            done
        else
            rm $NOTES_ROOT/$TARGET
        fi
    else
        echo "Usage: notes rm <note name>"
        exit 1
    fi
}

function notes_view(){
    TARGET=$1
    if [[ $ACTION =~ $DIGIT_REGEX ]]; then
        for fname in $NOTES_ROOT/*; do
            let COUNTER+=1
            if [[ $ACTION = $COUNTER ]]; then
                TARGET=$(basename $fname)
            fi
        done
    else
        TARGET=$DEFAULT_NOTE_TARGET
    fi

    vim $NOTES_ROOT/$TARGET || vi $NOTES_ROOT/$TARGET
    export DEFAULT_NOTE_TARGET=$TARGET
}

# List notes
if [[ $ACTION = "list" ]] || [[ $ACTION = "l" ]]; then
    notes_list

# List notes file paths
elif [[ $ACTION = "paths" ]]; then
    notes_paths

# Remove a note
elif [[ $ACTION = "rm" ]]; then
    notes_rm $TARGET

# View a note ( DEFAULT )
else
    notes_view $TARGET
fi
