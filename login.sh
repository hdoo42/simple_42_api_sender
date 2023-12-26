#!/bin/bash
MY_UID=u-s4t2af-ae4c841927546d450a8707e490f227ede384988a7f5cd55afa3917c9cab01c11
MY_SECRET=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

curl -X POST --data "grant_type=client_credentials&client_id=$MY_UID&client_secret=$MY_SECRET" https://api.intra.42.fr/oauth/token > .token.json
