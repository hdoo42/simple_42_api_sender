#!/bin/bash

main() {
	login.sh
	TEAMS=$(rg -oP "(?<=team_id_1': )\d+" moulinette.log.1)

	for team_id in $TEAMS; do
		post.sh "teams/$team_id/reset_team_uploads"
	done

}
