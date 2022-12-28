Set-PSReadLineOption -PredictionSource History
Invoke-Expression (&starship init powershell)

. "$PSScriptRoot\Util.ps1"
. "$PSScriptRoot\Git.ps1"
. "$PSScriptRoot\Smartwyre.ps1"
. "$PSScriptRoot\SmartwyreDb.ps1"
