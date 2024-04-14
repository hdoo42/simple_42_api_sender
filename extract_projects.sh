#!/bin/sh


FILE_NAME="$@_teams.jhon"

jq -r '.["projects_users"].[] | {current_team_id, project_name: .project.name}' "$@" > $FILE_NAME

TEAM_NUMBERS=$(jq -r '.["current_team_id"]' $FILE_NAME | tr '\n' ' ');

