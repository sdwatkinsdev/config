# -n 1 == run the command once per input rather than passing multiple
# -a provides the file whose lines are the args
xargs -n 1 -a vscode-extensions.txt code --install-extension
