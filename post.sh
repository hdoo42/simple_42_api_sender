#!/bin/bash
set -uex

DEFAULT_DIR="results"

post() {
	save_to="$DEFAULT_DIR/$DIR/$FILENAME.json"

	status_code=$(curl -X POST -o "$save_to" -w "%{http_code}" -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" "https://api.intra.42.fr/v2/$TARGET" -d "$BODY")

	echo "$status_code"
}

init_vars() {
	TARGET=${1:-}
	shift
	if [ -z "$TARGET" ]; then
		exit 1
	fi

	DIR=""
	BODY=""

	while getopts "d:b:" opt; do
		case "$opt" in
		d)
			DIR="$OPTARG"
			;;
		b)
			if [ ! -e "$OPTARG" ]; then
				echo "Error: file does not exist: $OPTARG"
				exit 1
			fi
			BODY=$(cat "$OPTARG")
			;;
		\?) # Handle the case of an unknown option
			echo "Usage: post.sh TARGET_URL [-d destination_dir] [-b FILE]"
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

	if [ -z "$BODY" ]; then
		BODY="$(cat ~/works/42/project/api/body.json)"
	fi

	ACCESS_TOKEN=$(jq -r '.["access_token"]' .token.json)
	if [ -n "$DIR" ]; then
		mkdir -p "results/$DIR"
	fi
	FILENAME=$(echo "$TARGET" | tr '/' '_')
}

_main() {
	init_vars "$@"

	post "$@"
}

_main "$@"
