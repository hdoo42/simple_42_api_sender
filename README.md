# simple_api_wrapper_42

## Before use

- make .env with

```
FT_API_UID=
FT_API_SECRET=
```

- Install jq.

## Usage

1. execute login.sh
   This will grant your access token

2. send api call with send.sh

For example, GET /v2/users/:id, and id is hdoo,

```
bash send.sh users/hdoo
```

will do all the jobs.
