#!/bin/bash

source .env

curl -X POST --data "grant_type=client_credentials&client_id=$FT_API_UID&client_secret=$FT_API_SECRET" https://api.intra.42.fr/oauth/token > .token.json
