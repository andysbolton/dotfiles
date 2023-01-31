Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

function Invoke-Starship-TransientFunction {
    &starship module character
}

Invoke-Expression (&starship init powershell)

Enable-TransientPrompt

Set-Alias -Name cm -Value chezmoi
function cmad() {
    chezmoi apply --dry-run --verbose
}
function cma() {
    chezmoi apply --verbose
}

function Import-Scripts($Scripts) {
    $Scripts | ForEach-Object {
        $path = "$PSScriptRoot/$_"
        if (Test-Path $path) {
            Write-Host "Loading $path."
            . $path
        }
    }
}

. Import-Scripts ("Functions.ps1", "GitFunctions.ps1", "Smartwyre.ps1", "SmartwyreDb.ps1")
