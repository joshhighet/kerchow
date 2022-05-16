#!/bin/zsh
# creates drivers/sbin/README.md based upon directory contents

set -e

scriptsdir=`git rev-parse --show-toplevel`/sbin
cd ${scriptsdir}

echo '''# doco
''' > README.md

for file in *
do
  if [ "${file}" != "README.md" ] && [ "${file}" != "matrix" ]
  then
    filetype=`file ${file}`
    if [[ "${filetype}" == *"script text executable"* ]]; then
      definition=`cat $file | sed -n '2p'`
      echo "## ${file}" >> README.md
      echo "" >> README.md
      description=`echo ${definition} | sed 's/# //g'` >> README.md
      echo "_${description}_" >> README.md
      echo "" >> README.md
    fi
  fi
done
