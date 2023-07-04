function Test-IsSymlink($Path) {
    $item = Get-Item $Path -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -eq "SymbolicLink") {
        return $true
    }
    return $false
}

$nvimLink = "~/AppData/Local/nvim"
if (-not (Test-IsSymlink $nvimLink)) {
    Start-Process pwsh -Verb "RunAs" -ArgumentList ("-NoExit", "-Command", "New-Item", "-ItemType", "symboliclink", "-Path", "$nvimLink", "-Value", "$(Resolve-Path "~/.config/nvim")")
}

Get-ChildItem "~/.config/powershell" |
    ForEach-Object {
	$scriptLink = "~/Documents/PowerShell/$($_.Name)"
        if (-not (Test-IsSymlink $scriptLink)) {
            Start-Process pwsh -Verb "RunAs" -ArgumentList ("-NoExit", "-Command", "New-Item", "-ItemType", "symboliclink", "-Path", "$scriptLink", "-Value", "$($_.FullName)")
        }
    }

