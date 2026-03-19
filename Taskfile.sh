#!/bin/bash

YEST=$(date -d "yesterday" +"%Y/%m/%d")
YUMAN=$(date -d "yesterday" +"%m/%d/%Y")
TODAY=$(date +"%Y/%m/%d")

function commit {
    # Walk back until we find the last day that has notes
    until [[ -d "daily/$YEST" ]]; do
        YUMAN=$(date -d "$YEST - 1 days" +"%m/%d/%Y")
        YEST=$(date -d "$YEST - 1 days" +"%Y/%m/%d")
    done

    git add daily
    git add Taskfile.sh
    # Add other note sections here, e.g.:
    # git add projects
    # git add work
    git commit -m "Add $YUMAN notes"
    git push origin main
}

# Create today's note pre-filled with incomplete todos from the most recent day, then open it
function notes {
    local HUMAN=$(date -d "$TODAY" +"%B %-d, %Y")
    local DAY_BEFORE="$TODAY"
    local FILE=""
    local MAX_LOOKBACK=365
    local i=0

    # Walk back iteratively to find the most recent existing notes file
    while [[ $i -lt $MAX_LOOKBACK ]]; do
        DAY_BEFORE=$(date -d "$DAY_BEFORE - 1 days" +%Y/%m/%d)
        FILE="daily/$DAY_BEFORE/main.md"
        [[ -f "$FILE" ]] && break
        (( i++ ))
    done

    mkdir -p daily/$TODAY
    if [[ -f "$FILE" ]]; then
        TODOS=$(cat $FILE | grep -zoP '## Todo\W+[^#]+' | tail -n +2 | grep -a '\- x')
        echo -e "# $HUMAN\n\n## Todo ✓\n\n$TODOS\n\n" > daily/$TODAY/main.md
    else
        echo -e "# $HUMAN\n\n## Todo ✓\n\n\n\n" > daily/$TODAY/main.md
    fi

    code daily/$TODAY/main.md
}

# Commit yesterday's notes and open today's
function next {
    commit
    notes
}

# Open notes from N weeks ago (default: 1)
function open-last-week {
    local MULTIPLIER=$(expr ${1:-1} \* 7)
    local LAST_WEEK=$(date -d "- $MULTIPLIER days" +%Y/%m/%d)
    code daily/$LAST_WEEK/main.md
}

# Add shortcuts for other note sections here, e.g.:
# function project { code projects/$1/$1.md; }
# function work    { code work/$1.md; }

function help {
    echo "$0 <task> <args>"
    echo "Tasks:"
    compgen -A function | cat -n
}

TIMEFORMAT="Task completed in %3lR"
time ${@:-help}