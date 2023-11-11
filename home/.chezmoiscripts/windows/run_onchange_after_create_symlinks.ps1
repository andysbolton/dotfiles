function Test-IsSymlink($Path) {
    $item = Get-Item $Path -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -eq "SymbolicLink") {
        return $true
    }
    return $false
}

$nvimLink = Resolve-Path "~/AppData/Local/nvim/"
if (-not (Test-IsSymlink $nvimLink)) {
    Start-Process pwsh -Verb "RunAs" -ArgumentList ("-NoExit", "-Command", "New-Item", "-ItemType", "symboliclink", "-Path", "$nvimLink", "-Value", "$(Resolve-Path "~/.config/nvim")")
}

# Here, the link target is reversed from above.
# ~/AppData/Local/nvim-data/ is created by nvim, whereas ~/.config/nvim is created by chezmoi.
$nvimDataLink = Resolve-Path "~/AppData/Local/nvim-data/"
if (-not (Test-IsSymlink $nvimDataLink)) {
    Start-Process pwsh -Verb "RunAs" -ArgumentList ("-NoExit", "-Command", "New-Item", "-ItemType", "symboliclink", "-Path", ("$(Resolve-Path ~)" + "\.local\share\nvim\"), "-Value", $nvimDataLink)
}

Get-ChildItem "~/.config/powershell" |
    ForEach-Object {
	$scriptLink = "~/Documents/PowerShell/$($_.Name)"
        if (-not (Test-IsSymlink $scriptLink)) {
            Start-Process pwsh -Verb "RunAs" -ArgumentList ("-NoExit", "-Command", "New-Item", "-ItemType", "symboliclink", "-Path", "$scriptLink", "-Value", "$($_.FullName)")
        }
    }

