#!/bin/zsh

titles=$(curl -s https://www.beehive.govt.nz/releases \
| grep '<a href="/release/' \
| cut -d '>' -f 2 | cut -d '<' -f 1)
echo "$titles" > /tmp/beehive-releases.txt

echo "latest post: $(head -n 1 /tmp/beehive-releases.txt)"
echo "🐝 🍯 watching for new releases..."

while true; do
  new_titles=$(curl -s https://www.beehive.govt.nz/releases \
  | grep '<a href="/release/' \
  | cut -d '>' -f 2 | cut -d '<' -f 1)
  if [[ "$new_titles" != "$titles" ]]; then
    echo "$new_titles" > /tmp/beehive-releases.txt
    new_post=$(echo $new_titles | head -n 1)
    echo "new release 🚨 $(date)"
    echo "===================="
    echo "$new_post"
    echo "===================="
    osascript -e 'display notification "'"$new_post"'" with title "New Beehive Release" sound name "Basso"'
    exit
  fi
  sleep 45
done
