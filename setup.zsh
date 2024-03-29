#!/bin/bash
# initialises paths to effectivley use scripts within joshhighet/kerchow

set -e #-x

location=`timeout .1 git rev-parse --show-toplevel`

if [[ ! "${SHELL}" =~ "zsh" ]] ; then
  echo "setup needs to be executed from within zsh"
  exit 1
fi

if [[ ! "${location}" =~ "kerchow" ]] ; then
  echo "setup needs to be executed from within joshhighet/kerchow"
  exit 1
fi

if ! grep "kerchow/sbin" ~/.zshrc &>/dev/null ; then
    cd "${location}/sbin"
    cp ~/.zshrc ~/.zshrc-backup-joshhighet-kerchow-sbin
    echo "kerchow/sbin not in path, adding"
    echo "" >> ~/.zshrc
    echo "# added by setup.zsh from joshhighet/kerchow" >> ~/.zshrc
    echo "export PATH=${location}/sbin:\$PATH" >> ~/.zshrc
    echo "added, reopen your terminal or introduce into current session with 'source ~/.zshrc'"
else
    echo "computer says no - have you already set this up?"
fi
