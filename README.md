# github.com/andysbolton/dotfiles

My dotfiles for Windows, Mac, Debian, and NixOS, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

# Setup

## Debian

```
# Install dependencies
curl -sS https://downloads.1password.com | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com stable main" | sudo tee /etc/apt/sources.list.d/1password.list

sudo apt update
sudo apt install -y git curl 1password-cli

sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply andysbolton
```
