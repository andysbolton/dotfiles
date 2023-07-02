function sudo() {
    if ($args.Length -eq 1) {
        Start-Process $args[0] -Verb RunAs
    }
    if ($args.Length -gt 1) {
        Start-Process $args[0] -ArgumentList $args[1..$args.Length] -Verb RunAs
    }
}
  
function which($Name) { 
    Get-Command $Name -ErrorAction SilentlyContinue | Select-Object Definition
}
  
function touch($File) { 
    "" | Out-File $File -Encoding ASCII 
}

function ops() {
    Invoke-Expression $(op signin)
}

function nvimconf() {
    nvim (Resolve-Path ~\.config\nvim\init.lua) -c ":Neotree $(Resolve-Path ~\.config\nvim)"
}

function wezconf() {
    nvim (Resolve-Path ~\.wezterm.lua)
}

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
    param()
    nvim (Resolve-Path "$profile\..")
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

function Add-PathVariable([string]$addPath) {  
    if (-not (Test-Path $addPath)) {
        throw "'$addPath' is not a valid path."
    }
  
    $Environment = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
  
    foreach ($path in ($Environment).Split(";")) {
        if ($path -like "*SysWOW64\WIndowsPowerShell\v1.0*") {
            $Environment = $Environment.Replace($Path , "")
        }
        if ($path -like "c:\temp*") {
            $Environment = $Environment.Replace($Path , "")
        }
    }
  
    $Environment = $Environment.Insert($Environment.Length, $AddPathItems + ";")
  
    [System.Environment]::SetEnvironmentVariable("Path", $Environment, "Machine")
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

