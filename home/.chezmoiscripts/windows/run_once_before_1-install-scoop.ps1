if (!(Get-Command "scoop")) {
    Write-Error @"

Scoop must be installed to continue, but it errors currently when trying to install with chezmoi.
Install with the following commands:

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
"@
}
