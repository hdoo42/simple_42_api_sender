#!/bin/bash
set -uex

DEFAULT_DIR="/Users/hdoo/works/42/project/api/results"

send() {
	curl -i -H "Authorization: Bearer $ACCESS_TOKEN" "https://api.intra.42.fr/v2/$TARGET?$FILTER&page\[size\]=100&page\[number\]=$1" > "$DEFAULT_DIR/$DIR/$FILENAME""_""$1.json"
	if [ $(wc -c <"$DEFAULT_DIR/$DIR/$FILENAME""_""$1.json") -gt 2 ]; then
		return 0
	else
		return 1
	fi
}

init_vars() {
	TARGET="$1"
	shift
	if [ -z "$TARGET" ]; then
		exit 1
	fi
	DIR=""
	FILTER=""

	while getopts "df:" opt; do
		case "$opt" in
		d)
			DIR="$OPTARG"
			;;
		f)
			FILTER="&filter$OPTARG$FILTER"
			;;
		\?) # Handle the case of an unknown option
			echo "Usage: get.sh URL [-d destination_dir] [-f filter]"
			exit 1
			;;
		:) # Handle the case of a missing option argument
			echo "Option -$OPTARG requires an argument." >&2
			exit 1
			;;
		esac
	done

	if [ -z "$DIR" ]; then
		DIR=$(echo "$TARGET" | tr '/' '_')
	fi

	ACCESS_TOKEN=$(jq -r '.["access_token"]' .token.json)
	if [ -n "$DEFAULT_DIR/$DIR" ]; then
		mkdir -p "$DEFAULT_DIR/$DIR"
	fi
	FILENAME=$(echo "$TARGET" | tr '/' '_')
	RETURN=3
}

_main() {
	init_vars "$@"

	RETURN=1
	i=1
	while [ $RETURN -ne 0 ]; do
		send $i
		i=$((i + 1))
		RETURN=$?
	done
}

_main "$@"
