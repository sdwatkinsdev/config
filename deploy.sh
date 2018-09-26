#! usr/bin/env bash

# TODO: this isn't accurate; the gitconfig is included rather than copied
# and I suspect a similar thing will happen with vimrc

# supposedly this reliably returns the location of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


echo "-----------------"
echo "Home files"
echo "-----------------"

HOME_FILES=(".gitconfig" ".vimrc" ".pryrc")
for file in "${HOME_FILES[@]}"
do
    source=$DIR/$file
    target=~/$file
    if [ -e "$target" ]
    then
        padded=$(printf '%-14s' $file)
        echo "$padded already exists at $target"
    else
        ln $source ~
        padded=$(printf '%-12s' $file)
        echo "$padded + link created at $target"
    fi
done

echo
echo "-----------------"
echo "VS Code files"
echo "-----------------"

VSCODE_SOURCE_DIR=$DIR/.vscode
VSCODE_SOURCES=($(ls $VSCODE_SOURCE_DIR))


%APPDATA%\Code\User\settings.json
case $(uname) in
    Linux*|Darwin*)  VSCODE_TARGET_DIR=~/Library/Application\ Support/Code/User;;
    MINGW*|CYGW*)    VSCODE_TARGET_DIR=$APPDATA/Code/User;;
    *) exit 1
esac


for file in "${VSCODE_SOURCES[@]}"
do
    source=$VSCODE_SOURCE_DIR/$file
    target=$VSCODE_TARGET_DIR/$file
    if [ -e "$target" ]
    then
        padded=$(printf '%-14s' $file)
        echo "$padded already exists at $target"
    else
        ln $source ~
        padded=$(printf '%-12s' $file)
        echo "$padded + link created at $target"
    fi
done
