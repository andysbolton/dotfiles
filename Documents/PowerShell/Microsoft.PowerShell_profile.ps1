Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

function Invoke-Starship-TransientFunction {
    &starship module character
}

Invoke-Expression (&starship init powershell)
  
Enable-TransientPrompt

Set-Alias -Name cm -Value chezmoi

. "$PSScriptRoot\Util.ps1"
. "$PSScriptRoot\Git.ps1"
. "$PSScriptRoot\Smartwyre.ps1"
. "$PSScriptRoot\SmartwyreDb.ps1"
