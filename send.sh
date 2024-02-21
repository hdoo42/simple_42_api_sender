#!/bin/bash
set -uex

DEFAULT_DIR="results"

send()
{
    curl  -H "Authorization: Bearer $ACCESS_TOKEN" "https://api.intra.42.fr/v2/$TARGET?page\[size\]=100&page\[number\]=$1" > "$DEFAULT_DIR/$DIR/$FILENAME""_""$1.json"
    if [ $(wc -c < "$DIR/$FILENAME""_""$1.json") -gt 2 ]; then
        return 0
    else
        return 1
    fi
}


init_vars() {
    TARGET="$1"
    if [ -z "$TARGET" ]; then
        exit 1
    fi
    DIR=${2:-}
    if [ -z "$DIR" ]; then
        DIR=$(echo "$TARGET" | tr '/' '_')
    fi
    ACCESS_TOKEN=$(jq -r '.["access_token"]' .token.json)
    if [ -n "$DIR" ]; then
        mkdir -p "$DIR"
    fi
    FILENAME=$(echo "$TARGET" | tr '/' '_')
    RETURN=3
}

_main()
{
    init_vars "$@";

    RETURN=0
    i=1
    while [ $RETURN -eq 0 ]; do
        send $i
        i=$((i+1))
        RETURN=$?
    done
}

_main "$@"
