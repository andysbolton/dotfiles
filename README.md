# github.com/andysbolton/dotfiles

My dotfiles for Windows and Linux (Debian at the moment), managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

# Setup

## Debian (WSL)

```
# Don't generate the default resolv.conf, and create a resolv.conf
# pointing to Google's nameservers.
# I have always had to do this in order to get internet connectivity
# from WSL.
# https://github.com/microsoft/WSL/issues/5336#issuecomment-653881695

rm /etc/resolv.conf

cat <<EOF > /etc/wsl.conf
[network]
generateResolvConf = false

[automount]
enabled = true
options = "metadata"
mountFsTab = false
EOF

cat <<EOF > /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# Install dotfiles.

sudo apt update
sudo apt install -y git curl

sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply andysbolton
```
