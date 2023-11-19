function which($Name) { 
    Get-Command $Name -ErrorAction SilentlyContinue | Select-Object Definition
}
  
function touch($File) { 
    "" | Out-File $File -Encoding ASCII 
}

function ops() {
    Invoke-Expression $(op signin)
}

function Start-NvimConfig {
    [Alias("nvimconf")]
    [Alias("nc")]
    param()
    nvim --cmd ":cd ~/.config/nvim"
}

function wezconf {
    [Alias("wc")]
    param()
    nvim (Resolve-Path ~\.wezterm.lua)
}

function ahk { autohotkey.exe $args }

function chown($Object, $User) {
    $acl = Get-Acl $Object
    $user = New-Object System.Security.Principal.Ntaccount($User)
    $acl.SetOwner($user)
    Set-Acl -AclObject $acl -Path $Object
}

function Set-Desktop {
    [Alias("dt")]
    param()
    Set-Location ~\Desktop
}
  
function Set-LocationToProfile {
    [Alias("pwshconf")]
    [Alias("pc")]
    param()
    nvim --cmd ":cd $(Resolve-Path "$profile\..")"
}
  
function Get-PrettyJson([string]$JsonString) {
    $JsonString | ConvertFrom-Json | ConvertTo-Json 
}
  
function Get-PrettyJsonFromClipboard() {	
    Get-Clipboard | Get-PrettyJson
}
  
function Format-Bytes {
    param
    (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [float]$number
    )
    begin {
        $sizes = 'KB', 'MB', 'GB', 'TB', 'PB'
    }
    process {
        for ($x = 0; $x -lt $sizes.count; $x++) {
            if ($number -lt [int64]"1$($sizes[$x])") {
                if ($x -eq 0) {
                    return "$number B"
                }
                else {
                    $num = $number / [int64]"1$($sizes[$x-1])"
                    $num = "{0:N3}" -f $num
                    return "$num $($sizes[$x-1])"
                }
            }
        }
    }
}
  
function Compare-Files($path1, $path2) {
    Compare-Object (Get-Content $path1) (Get-Content $path2)
}
  
function Get-AllEmptyDirectories($Dir = ".") {
    Get-ChildItem $Dir -Recurse 
    | Where-Object { (Get-Item $_) -is [System.IO.DirectoryInfo] } 
    | ForEach-Object { 
        [pscustomobject]@{ 
            Name  = $_.FullName; 
            Count = Measure-Object -InputObject (Get-ChildItem $_.FullName) | Select-Object -ExpandProperty Count
        } } 
    | Where-Object { $_.Count -eq 0 } 
    | Select-Object -ExpandProperty Name
}

function Show-Functions() {
    Get-ChildItem function: | Where-Object { (-not $_.Source) -and ($_.HelpFile -notmatch "System\.Management") }
}

function Show-FileSizes() {
    Get-ChildItem -Recurse | ForEach-Object (Measure-Object -InputObject $_ -Property Length -Sum -ErrorAction Stop).Sum / 1MB
}

function Reload-Profile {
    . $profile
}

function Stop-Chrome() {
    taskkill /im chrome.exe /f
}

function Get-ProcessId($fileName) {
    Get-Process -FileVersionInfo -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.FileName -like $fileName) {
            $_.Name + " PID:" + $_.Id
        }
    }
}

function Stay-Awake {
    [alias("awake")]
    param()

    $wsh = New-Object -ComObject WScript.Shell
    while (1) {
      # Send Shift+F15 - this is the least intrusive key combination I can think of and is also used as default by:
      # http://www.zhornsoftware.co.uk/caffeine/
      # Unfortunately the above triggers a malware alert on Sophos so I needed to find a native solution - hence this script...
      $wsh.SendKeys('+{F15}')
      Start-Sleep -seconds 59
    }
}

function Add-PathVariable([string]$path) {  
    if (-not (Test-Path $path)) {
        throw "'$path' is not a valid path."
    }

    [System.Environment]::SetEnvironmentVariable("Path", $env:PATH + ";$path", "Machine")
}
  
function Get-ChocoPackagesWithDependencies() {
    $packages = Get-ChildItem C:\ProgramData\chocolatey\lib\ -Recurse *.nuspec | Select-Object fullname, name 
    foreach ($p in $packages) {
        [xml]$xml = Get-Content $p.fullname
        $dependencies = $xml.package.metadata.dependencies.dependency
        if ($null -eq $dependencies) {  
            [pscustomobject] {
                package = $xml.package.metadata.id;
                packageversion = $xml.package.metadata.version;
                dependency = "";
                dependencyversion = ""
            }
            continue
        }
        foreach ($d in $dependencies) {
            [pscustomobject] {
                package = $xml.package.metadata.id;
                packageversion = $xml.package.metadata.version;
                dependency = $d.id;
                dependencyversion = $d.version;
            }
        }
    }
}
  
function Get-LocalChocoPackagesWithNoDependecies() {
    $allPackages = Get-ChocoPackagesWithDependencies
    $dependencyNames = $allPackages | Select-Object -ExpandProperty dependency | Sort-Object | Get-Unique
    $allPackageNames = $allPackages | Select-Object -ExpandProperty package | Sort-Object | Get-Unique
  
    $allPackageNames | Where-Object { -not ($dependencyNames -contains $_) } | Sort-Object
}

