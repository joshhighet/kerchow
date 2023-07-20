➜  labs cats cats
#!/bin/bash
# print the source code of any kerchow shortscripts

if [ -z "$1" ]; then
    echo "usage: cats <binfile>"
    exit 1
fi

shortscript=`which $1`

if [ -z "$shortscript" ]; then
  echo "unable to find $1"
  exit 1
fi

if ! command -v bat >/dev/null 2>&1
then
  cat $shortscript
else
  bat -pp $shortscript
fi