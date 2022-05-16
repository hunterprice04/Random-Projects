#!/bin/bash

SHOULD_PUSH=false
if [[ "$1" == "--push" ]]; then
    SHOULD_PUSH=true
fi

echo '----------------------------------------------------------------------------------------------'
echo 'Updating README...'
echo "# Random Projects" > README.md
echo "This repository contains projects I have worked on in my free time for fun." >> README.md
echo "">> README.md
echo "The following are links to the individual projects:" >> README.md

echo '----------------------------------------------------------------------------------------------'
echo 'Updating submodules...'
git pull
git submodule update --init --recursive
path=$(pwd)
cat .gitmodules | grep "path" | awk '{print $3}' | while read line
do
    cd $line

    echo '----------------------------------------------------------------------------------------------'
    echo "Pulling newest commits for: $line"

    echo "Updating README.md"
    url=`git config --get remote.origin.url | sed 's/git@github\.com:/https:\/\/github\.com\//' | sed 's/\.git//'`
    echo "URL: $url"
    echo "- [$line]($url)" >> $path/README.md
    cd $path
done
echo '----------------------------------------------------------------------------------------------'

if [[ $SHOULD_PUSH == true ]]; then
    git add README.md
    git commit -m "Update README.md"
    git push
    echo '----------------------------------------------------------------------------------------------'
fi
