#!/bin/bash
set -exu

DEFAULT_DIR="/Users/hdoo/works/42/project/api/results"

parse_header() {
   "$DEFAULT_DIR/$DIR/$FILENAME""_""$1.json"
}

send() {
	save_to="$DEFAULT_DIR/$DIR/$FILENAME""_""$1.json"

	status_code=$(curl -o "$save_to" -w "%{http_code}" -H "Authorization: Bearer $ACCESS_TOKEN" "https://api.intra.42.fr/v2/$TARGET?$FILTER&page\[size\]=100&page\[number\]=$1")

	if [[ $status_code == 2* ]] && (( "$(wc -c < "$save_to")" > 1000 )); then
			npx prettier -w "$save_to" > /dev/null &
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
			IFS='=' read -r FIELD VALUE <<< "$OPTARG"

			FILTER="&filter\[$FIELD\]=$VALUE$FILTER"
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
	if [ ! -d "$DEFAULT_DIR/$DIR" ]; then
		mkdir -p "$DEFAULT_DIR/$DIR"
	fi
	FILENAME=$(echo "$TARGET" | tr '/' '_')
}

_main() {
	init_vars "$@"

	RETURN=0
	i=1
	while [ $RETURN -eq 0 ]; do
		send $i
		i=$((i + 1))
		RETURN=$?
	done
}

_main "$@"
