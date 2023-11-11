#!/usr/bin/pwsh

$asdfPath = "$HOME/.asdf"

if (-not (Test-Path $asdfPath)) {
    git clone https://github.com/asdf-vm/asdf.git $asdfPath --branch v0.13.1
}

# . (Resolve-Path "$asdfPath/asdf.ps1")
#
# Get-Content ~/.tool-versions | ForEach-Object {
#     $line = $_.Split(" ")
#     $plugin = $line[0]
#     $version = $line[1]
#
#     asdf plugin add $plugin
#     asdf install $plugin $version
# }

