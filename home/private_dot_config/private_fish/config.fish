fish_add_path ~/smartwyre/infra-orchestrator/smartwyre-infra/scripts
fish_add_path ~/.local/bin
fish_add_path ~/bin
fish_add_path /usr/local/go/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.asdf/installs/lua/5.4.6/luarocks/bin
fish_add_path ~/.dotnet/tools
fish_add_path ~/go/bin

. ~/.asdf/asdf.fish
. ~/.asdf/plugins/dotnet-core/set-dotnet-home.fish

set -gx BROWSER wslview
set -gx EDITOR nvim
set -gx RIPGREP_CONFIG_PATH $HOME/.ripgreprc
set -gx MANPAGER "sh -c 'col -bx | batcat -l man -p'"

alias cm="chezmoi"
alias cma="chezmoi apply --verbose"
alias cmad="chezmoi apply --verbose --dry-run"
alias nvimconf='nvim --cmd ":cd ~/.config/nvim"'
alias nc="nvimconf"
alias fishconf="nvim ~/.config/fish/config.fish"
alias fc="fishconf"
alias bat="batcat"
alias lrepl="lein repl"

bind \cS 'history-pager'

function add -a message
    set branch (git branch --show-current)
    set match (string match --groups-only -r '(?i)(smart|cloud-\d+)' $branch)
    if [ -n "$match" ]
        set commit "$match: $message"
    else
        set commit "$message"
    end
    git add -A
    git commit -m "$commit"
    echo "Commited with message: $message"
end

function addp -a message
    add $message
    if ! git push
        git push --set-upstream origin (git branch --show-current)
    end
end

function starship_transient_prompt_func
    starship module character
end

function jit_and_conn
    vm_jit_request_access.sh $argv && ssh $argv
end

function set_mtu 
    sudo ip link set dev eth0 mtu 1420
end

function p
    pwsh -Command $argv
end

function ops
    eval $(op signin)
end

function exercism
    if [ $argv[1] = "download" ]
        set dir (~/bin/exercism $argv) && echo $dir && cd $dir 
    else
        ~/bin/exercism $argv
    end
end

function cdn 
    cd $argv[1] && nvim
end

function fsource 
  for line in (cat $argv | grep -v '^#')
    set item (string split -m 1 '=' $line)
    set -gx $item[1] $item[2]
    echo "Exported key $item[1]."
  end
end

if status is-login
    cd ~/
end

function install_neovim 
    mkdir -p ~/.local/bin
    if count $argv >/dev/null && [ $argv[1] = "nightly" ]
        curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    else
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    end 
    chmod u+x nvim.appimage
    mv nvim.appimage ~/.local/bin/nvim
end

if status is-interactive
    # Commands to run in interactive sessions can go here >
end

starship init fish | source
enable_transience

