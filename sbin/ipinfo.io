#!/bin/bash

curl -s ipinfo.io/${1} -H "User-Agent: curl/7.54" | jq -r 'del(.readme)'