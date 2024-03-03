function Test-IsSymlink($Path) {
    $item = Get-Item $Path -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -eq "SymbolicLink") {
        return $true
    }
    return $false
}

function New-SymLink($Source, $Target) {
    if (Test-IsSymlink $Target) {
        Write-Host "Symlink from $Source to $Target already exists."
        return
    }
    Write-Host "Creating symlink from $Source to $Target."
    Start-Process pwsh -Verb "RunAs" -ArgumentList ("-NoExit", "-Command", "New-Item", "-ItemType", "symboliclink", "-Path", "'$Target'", "-Value", "'$(Resolve-Path $Source)'")
}

New-SymLink -Source "~/.config/nvim/" -Target "~/AppData/Local/nvim/"
New-SymLink -Source "~/AppData/Local/nvim-data/" -Target "~/.local/share/nvim/"
New-SymLink -Source "~/autohotkey/init.ahk" -Target "~/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/init.ahk"

if (-not (Test-Path "~/Documents/Powershell")) {
    mkdir "~/Documents/Powershell"
}

Get-ChildItem "~/.config/powershell" |
    ForEach-Object {
        New-SymLink -Source $_.FullName -Target "~/Documents/PowerShell/$($_.Name)"
    }
