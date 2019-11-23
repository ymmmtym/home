#!/bin/bash

if [ $# -ne 1 ]; then
  echo -e "usage: bash $0 [ pull | push | status]"
  exit 1
fi

function Push() {
    git checkout master
    git add .
    git commit -m "update by $0"
    git push
}

root_dir=`pwd`

for dir in $(find . -maxdepth 1 -type d|grep [^.]); do
  cd $dir
  if [ ! -d ".git" ]; then
    echo -e "\n# $dir is no git repository"
  else
    echo -e "\n# git $1 at $dir"
    case $1 in
      push )
        Push;;
      * )
        git $1;;
    esac
  fi
  cd $root_dir
done
