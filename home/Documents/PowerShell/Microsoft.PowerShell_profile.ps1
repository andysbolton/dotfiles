Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
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

. "$PSScriptRoot\Functions.ps1"
. "$PSScriptRoot\GitFunctions.ps1"
. "$PSScriptRoot\Smartwyre.ps1"
. "$PSScriptRoot\SmartwyreDb.ps1"
