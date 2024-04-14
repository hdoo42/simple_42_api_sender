#!/bin/bash
# set -uex

DEFAULT_DIR="results"

post() {
	curl -X PATCH -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" "https://api.intra.42.fr/v2/$TARGET" -d "$BODY" >"$DEFAULT_DIR/$DIR/$FILENAME.json"
}

init_vars() {
	TARGET=${1:-}
	if [ -z "$TARGET" ]; then
		exit 1
	fi

	BODY=${3:-}

	while getopts "df:" opt; do
		case "$opt" in
		d)
			DIR="$OPTARG"
			;;
		b)
			BODY="$OPTARG"
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
	RETURN=3
}

_main() {
	init_vars "$@"

	post "$@"
}

_main "$@"
