#!/usr/bin/env bash

# supposedly this reliably returns the location of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

find_or_create_dir () {
    local dir="$1"

    if [ -d "$dir" ]
    then
        echo "$dir already exists"
    else
        mkdir -p "$dir"
        echo "$dir created"
    fi
}

find_or_copy () {
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
        find_or_create_dir $target_dir
        cp "$source" "$target_dir"
        padded=$(printf '%-18s' $filename)
        echo "$padded +++ copied to $target"
    fi
}

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
	find_or_create_dir $target_dir
        ln "$source" "$target_dir"
        padded=$(printf '%-18s' $filename)
        echo "$padded +++ link created at $target"
    fi
}

find_or_link_dir () {
    local source_dir="$1"
    local target_dir="$2"

    local source="$source_dir"
    local target="$target_dir"
    if [ -d "$target_dir" ]
    then
        padded=$(printf '%-25s' $source_dir)
        echo "$padded already exists at $target_dir"
    else
        ln -s "$source_dir" "$target_dir"
        padded=$(printf '%-25s' $filename)
        echo "$padded +++ link created at $target"
    fi
}

echo
echo "-----------------"
echo "Ensure directories exist"
echo "-----------------"

find_or_create_dir ~/.vim

echo
echo "-----------------"
echo "Home files"
echo "-----------------"

HOME_FILES=(".vimrc" ".pryrc" ".bashrc")
for file in "${HOME_FILES[@]}"
do
    find_or_link $file $DIR ~
done

find_or_copy .gitconfig $DIR ~

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

echo
echo "-----------------"
echo "Neovim setup"
echo "-----------------"

case $(uname) in
    Linux*|Darwin*)  NVIM_TARGET_DIR=~/.config/nvim;;
    MINGW*|CYGW*)    NVIM_TARGET_DIR=$LOCALAPPDATA/nvim;;
    *) echo "Failed to detect VS Code settings dir from uname '$(uname)'"; exit 1
esac

find_or_link_dir ~/.vim "$NVIM_TARGET_DIR"
find_or_link init.vim "$DIR" ~/.vim

echo
echo "Done!"
