Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

function Invoke-Starship-TransientFunction {
    &starship module character
}

$komorebiPath = Resolve-Path "~\.config\komorebi"
if ($komorebiPath) {
    $env:KOMOREBI_CONFIG_HOME = $komorebiPath
}

Invoke-Expression (&starship init powershell)

Enable-TransientPrompt


$prompt = ""
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}

Set-Alias -Name cm -Value chezmoi
function cmad() {
    chezmoi apply --dry-run --verbose
}
function cma() {
    chezmoi apply --verbose
}

function Import-Scripts($Scripts) {
    $Scripts | ForEach-Object {
        $path = "~/.config/powershell/$_"
        if (Test-Path $path) {
            $prettyPath = Resolve-Path $path
            Write-Host "Loading $prettyPath."
            . $prettyPath
        }
    }
}

. Import-Scripts ("Functions.ps1", "GitFunctions.ps1", "Smartwyre.ps1", "SmartwyreDb.ps1")
