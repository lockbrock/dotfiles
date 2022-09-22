#!/bin/bash
# Get the directory in which this script lives.
script_dir=$(dirname "$(readlink -f "$0")")

create_symlinks() {

    # Get a list of all files in this directory that start with a dot.
    files=$(find -maxdepth 1 -type f -name ".*")

    # Create a symbolic link to each file in the home directory.
    for file in $files; do
        name=$(basename $file)
        echo "Creating symlink to $name in home directory."
        rm -rf ~/$name
        ln -s $script_dir/$name ~/$name
    done
}

setup_vs_code_settings() {
    if [ -d "$HOME/.vscode-server" ]
    then
        # Move our vscode-server settings.json
        echo "Copying vscode-settings.json to ~/.vscode-server/data/Machine/settings.json."
        rm -rf $HOME/.vscode-server/data/Machine/settings.json
        cp $script_dir/vscode-settings.json "$HOME/.vscode-server/data/Machine/"
        # Rename it
        mv "$HOME/.vscode-server/data/Machine/vscode-settings.json" "$HOME/.vscode-server/data/Machine/settings.json"
    fi
}

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

create_symlinks

# Add VS Code remote settings (if applicable)
setup_vs_code_settings