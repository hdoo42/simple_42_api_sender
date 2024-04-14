#!/bin/bash
# set -uex

DEFAULT_DIR="results"

post() {
	curl -X DELETE -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" "https://api.intra.42.fr/v2/$TARGET" -d "$BODY" >"$DEFAULT_DIR/$DIR/$FILENAME.json"
}

init_vars() {
	TARGET=${1:-}
	if [ -z "$TARGET" ]; then
		exit 1
	fi
	DIR=${2:-}
	if [ -z "$DIR" ]; then
		DIR=$(echo "$TARGET" | tr '/' '_')
	fi
	BODY=${3:-}
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
