#!/bin/bash

sudo apt update

function package_exists {
    local package=$1
    if dpkg -s "$package" >/dev/null; then
        echo "$package is already installed."
        return
    fi
    false
}

function install_op {
    if package_exists 1password; then
        return
    fi

    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
        sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
        sudo tee /etc/apt/sources.list.d/1password.list

    sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
    curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
        sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
    sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
    curl -sS https://downloads.1password.com/linux/keys/1password.asc |
        sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

    sudo apt update && sudo apt install -y 1password-cli
}

function install_gh {
    if package_exists gh; then
        return
    fi

    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
        sudo apt install -y gh
}

function install_pwsh {
    if package_exists powershell; then
        return
    fi

    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" | sudo tee /etc/apt/sources.list.d/microsoft.list
    sudo apt update
    sudo apt install powershell
}

function install_neovim {
    mkdir -p ~/.local/bin
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    # curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage ~/.local/bin/nvim
}

function install_fish {
    if package_exists fish; then
        return
    fi

    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
    curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg >/dev/null
    sudo apt update && sudo apt install -y fish
}

install_op
install_gh
install_pwsh
install_neovim
install_fish

echo "Changing shell to fish."
chsh -s /usr/bin/fish

# install starship
curl -sS https://starship.rs/install.sh | sh -s -- -y
