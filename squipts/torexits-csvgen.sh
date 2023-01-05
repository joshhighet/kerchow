#!/bin/bash
echo "src,is_exit"
curl --silent \
https://check.torproject.org/exit-addresses \
| grep "ExitAddress" \
| cut -d " " -f2 \
| awk 'BEGIN { FS=OFS="," } { print $1,"True" }'