#!/bin/bash

if [ -z "$1" ]
then
  echo "enter github path (i.e joshhighet/kerchow)"
  read repo
else
  repo=$1
fi

if [ -z "$repo" ]; then
  echo "no repo location provided"
  exit 1
fi

# until we have empty runids loop the script
runids=$(gh api repos/${repo}/actions/runs \
| jq -r '.workflow_runs[] | select(.head_branch != "master") | "\(.id)"')

while read -r runid; do
  echo "deleting runid: $runid"
  gh api repos/${repo}/actions/runs/${runid} -X DELETE --silent &
done <<< "$runids"

sleep 7