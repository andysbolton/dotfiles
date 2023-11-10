#!/bin/bash

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

. "$HOME/.asdf/asdf.sh"

while read -r tool; do
    plugin=$(echo "$tool" | cut -d' ' -f1)
    version=$(echo "$tool" | cut -d' ' -f2)

    asdf plugin add "$plugin"
    asdf install "$plugin" "$version"
done <~/.tool-versions
