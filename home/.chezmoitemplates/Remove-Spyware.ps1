param([Switch]$DryRun)

function Remove-Package() {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String[]]
        $PackageNames
    )
    process {
        foreach ($packageName in $PackageNames) {
            if ($DryRun) {
                Write-Host "Will remove $packageName."
                continue
            }

            $appx = Get-AppxPackage $packageName -AllUsers 
            if ($null -eq $appx) {
                return
            }
            $appx | Remove-AppxPackage -AllUsers
            Get-AppXProvisionedPackage -Online 
            | Where-Object DisplayName -like $packageName
            | Remove-AppxProvisionedPackage -Online -AllUsers
        }
    }
}

$Excemptions = @(
    "Microsoft.OneDriveSync",
    "Microsoft.Windows.Photos",
    "Microsoft.WindowsTerminal",
    "Microsoft.Winget.Source",
    "Microsoft.YourPhone"
)
 
Get-AppxPackage -AllUsers 
| Where-Object { $_.NonRemovable -eq $false -and -not ($Excemptions -contains $_.Name) } 
| Select-Object -ExpandProperty Name 
| Get-Unique
| Sort-Object 
| Remove-Package
