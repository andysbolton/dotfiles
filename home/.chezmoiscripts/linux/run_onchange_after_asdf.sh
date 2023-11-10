#!/bin/bash

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

while read tool; do
    plugin=(echo $tool | cut -d' ' -f1)
    version=(echo $tool | cut -d' ' -f2)

    asdf plugin install $plugin
    asdf install $plugin $version
end < ~/.tool-versions
