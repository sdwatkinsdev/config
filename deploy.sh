#! usr/bin/env bash

# supposedly this reliably returns the location of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

find_or_link () {
    local filename="$1"
    local source_dir="$2"
    local target_dir="$3"

    local source="$source_dir/$filename"
    local target="$target_dir/$filename"
    if [ -e "$target" ]
    then
        padded=$(printf '%-20s' $filename)
        echo "$padded already exists at $target"
    else
        ln "$source" "$target_dir"
        padded=$(printf '%-18s' $filename)
        echo "$padded +++ link created at $target"
    fi
}


echo "-----------------"
echo "Home files"
echo "-----------------"

HOME_FILES=(".gitconfig" ".vimrc" ".pryrc")
for file in "${HOME_FILES[@]}"
do
    find_or_link $file $DIR ~
done

echo
echo "-----------------"
echo "VS Code files"
echo "-----------------"

VSCODE_SOURCE_DIR=$DIR/.vscode
VSCODE_SOURCES=($(ls $VSCODE_SOURCE_DIR))

case $(uname) in
    Linux*|Darwin*)  VSCODE_TARGET_DIR="$HOME/Library/Application Support/Code/User";;
    MINGW*|CYGW*)    VSCODE_TARGET_DIR=$APPDATA/Code/User;;
    *) echo "Failed to detect VS Code settings dir from uname '$(uname)'"; exit 1
esac

for file in "${VSCODE_SOURCES[@]}"
do
    find_or_link $file "$VSCODE_SOURCE_DIR" "$VSCODE_TARGET_DIR"
done
