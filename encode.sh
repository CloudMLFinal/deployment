#!/bin/bash

while IFS='=' read -r key value || [ -n "$key" ]; do
  [[ $key =~ ^#.*$ || -z $key ]] && continue
  value=$(echo $value | sed 's/^"\(.*\)"$/\1/' | sed "s/^'\(.*\)'$/\1/")
  encoded=$(echo -n "$value" | base64)
  echo "$key: $encoded"
done < .env