#!/bin/bash
# creates drivers/sbin/README.md based upon directory contents

set -e

echo '''# kerchow

kerchow is a collection of shortcuts/binfiles/scripts to speed up common tasks

these are intended to be added to your `PATH` to shorthand various workflows - _see `setup.zsh` for an example_

each script is noted below alongside a brief description of what it does. where applicable, example outputs are shown

---
''' > README.md

scriptsdir=$(git rev-parse --show-toplevel)/sbin
cd "${scriptsdir}"
for file in *
do
  if [ "${file}" != "README.md" ] && [ "${file}" != "matrix" ]
  then
    filetype=$(file "${file}")
    if [[ "${filetype}" == *"script text executable"* ]]; then
      definition=$(cat "$file" | sed -n '2p')
      description=$(echo "${definition}" | sed 's/# //g')
      echo "## ${file}" >> ../README.md
      echo "" >> ../README.md
      echo "[:link:](sbin/${file}) _${description}_" >> ../README.md
      echo "" >> ../README.md
      example_file="${file}.md"
      if [ -f "${example_file}" ]; then
        echo "<details><summary>example:</summary>" >> ../README.md
        echo "" >> ../README.md
        example_content=$(cat "${example_file}")
        echo "\`\`\`" >> ../README.md
        echo "${example_content}" >> ../README.md
        echo "\`\`\`" >> ../README.md
        echo "</details>" >> ../README.md
        echo "" >> ../README.md
      fi
    fi
  fi
done