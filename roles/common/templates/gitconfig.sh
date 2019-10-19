#!/usr/bin/env bash

git config --global user.name "ymmmtum"
git config --global user.email "hoge@gmail.com"
git config --global core.editor 'vim -c "set fenc=utf-8"'
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global alias.cm "commit -m"
git config --global alias.pom "push origin master"
git config --global alias.su "submodule update"
git config --global alias.rh "reset --hard HEAD^"
