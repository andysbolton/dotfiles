Start-Process pwsh -Verb "RunAs" -ArgumentList ("-NoExit", "-Command", "New-Item", "-ItemType", "symboliclink", "-Path", "~/.config/nvim", "-Name", "nvim", "-Value", "~/AppData/Local/nvim")
