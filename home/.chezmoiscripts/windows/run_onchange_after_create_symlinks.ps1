Start-Process pwsh -Verb "RunAs" -ArgumentList ("-NoExit", "-Command", "New-Item", "-ItemType", "symboliclink", "-Path", "~/.config/nvim", "-Name", "nvim", "-Value", "~/AppData/Local/nvim")

Get-ChildItem "~/.config/powershell" |
    ForEach-Object {
        Start-Process pwsh -Verb "RunAs" -ArgumentList ("-NoExit", "-Command", "New-Item", "-ItemType", "symboliclink", "-Path", ($_.FullName), "-Name", "nvim", "-Value", "~/Documents/Powershell/$($_.Name)")
    }

