#!/bin/bash

file_name="$*"
basename="${file_name%.*}"
key_file="$basename"_keys
example_file="$basename"_example

keys=$(jq -r '.[0] | keys[]' < "$file_name")
{ echo "$keys"; echo ""; } >> "$key_file"

echo "[Optional_keys]" >> "$key_file"

for key in $keys; do
  exp=".[] | select(.$key!=null) | .$key"
  printf '\n[%s]\n' "$key" >> "$example_file"
  jq "$exp" < "$file_name" >> "$example_file"
done

for key in $keys; do
  exp=".[] | select(.$key==null) | .$key"
  jq "$exp" < "$file_name" > "$key.json"
  if [ "$(wc -l < "$key.json")" -gt 0 ]; then 
    echo "$key" >> "$key_file"
  fi
  rm "$key.json"
done
