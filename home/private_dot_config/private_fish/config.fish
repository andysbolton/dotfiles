fish_add_path ~/smartwyre/infra-orchestrator/smartwyre-infra/scripts
fish_add_path ~/.local/bin
fish_add_path ~/bin
fish_add_path /usr/local/go/bin
fish_add_path ~/.cargo/bin

set -Ux BROWSER wslview
set -Ux EDITOR nvim
set -Ux RIPGREP_CONFIG_PATH $HOME/.ripgreprc

alias cm="chezmoi"
alias cma="chezmoi apply --verbose"
alias cmad="chezmoi apply --verbose --dry-run"
alias nvimconf='nvim -c ":cd ~/.config/nvim"'
alias nc="nvimconf"
alias fishconf="nvim ~/.config/fish/config.fish"
alias fc="fishconf"

function add -a message
    set branch (git branch --show-current)
    set match (string match --groups-only -r '(?i)(smart|ops-\d+)' $branch)
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

if status is-login
    cd ~/
end

if status is-interactive
    # Commands to run in interactive sessions can go here >
end

starship init fish | source
enable_transience

nvm use 18 --silent
