#!/bin/zsh
# initialises sbin for kerchow/sbin

set -e #-x

location=`timeout .1 git rev-parse --show-toplevel`

if [[ ! "${location}" =~ "kerchow" ]] ; then
  echo "paths.sh needs to be executed from within joshhighet/kerchow"
  exit 1
fi

if ! grep "kerchow/sbin" ~/.zshrc &>/dev/null ; then
    cd "${location}/sbin"
    cp ~/.zshrc ~/.zshrc-backup-joshhighet-kerchow-sbin
    echo "kerchow/sbin not in path, adding"
    echo "" >> ~/.zshrc
    echo "# added by sbin/paths.sh from joshhighet/kerchow" >> ~/.zshrc
    echo "export PATH=${location}/sbin:\$PATH" >> ~/.zshrc
    echo "added, reopen your terminal or introduce into current session with 'source ~/.zshrc'"
else
    echo "computer says no - have you already setup?"
fi
