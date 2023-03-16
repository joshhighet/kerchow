#!/bin/bash
# creates drivers/sbin/README.md based upon directory contents

set -e

echo '''# kerchow

this is a collection of shortcuts that I use to do things faster in a schelle

they are intended to be added to your `PATH` to shorthand things.
> the `setup.sh` script will automate the addition of these to your `.zshrc` file

each script is noted below along with a brief description of what it does

---
''' > README.md

scriptsdir=`git rev-parse --show-toplevel`/sbin
cd ${scriptsdir}
for file in *
do
  if [ "${file}" != "README.md" ] && [ "${file}" != "matrix" ]
  then
    filetype=`file ${file}`
    if [[ "${filetype}" == *"script text executable"* ]]; then
      definition=`cat $file | sed -n '2p'`
      echo "## ${file}" >> ../README.md
      echo "" >> ../README.md
      description=`echo ${definition} | sed 's/# //g'` >> ../README.md
      echo "_${description}_" >> ../README.md
      echo "" >> ../README.md
    fi
  fi
done
