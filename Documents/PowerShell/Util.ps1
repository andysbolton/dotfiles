function Set-Desktop {
  [Alias("dt")]
  param()
  Set-Location ~\Desktop
}

function Set-LocationToProfile {
  [Alias("pp")]
  param()
  code (Resolve-Path "$profile\..")
}

function Run-WithTimer([ScriptBlock]$Command) {
  $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()
  Invoke-Command -ScriptBlock $Command
  Write-Host "Completed in $($stopWatch.Elapsed.ToString())" -ForegroundColor Green;
}

function Get-PrettyJson([string]$JsonString) {
  $JsonString | ConvertFrom-Json | ConvertTo-Json 
}

function Get-PrettyJsonFromClipboard() {	
  Get-Clipboard | Get-PrettyJson
}

function Set-File {
  [Alias("touch")]
  param (
    [Parameter()]
    [string]
    $file
  )

  if ($null -eq $file) {
    throw "No filename supplied"
  }

  if (Test-Path $file) {
    (Get-ChildItem $file).LastWriteTime = Get-Date
  }
  else {
    Add-Content $file $null
  }
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
  gci $Dir -Recurse 
  | ? { (Get-Item $_) -is [System.IO.DirectoryInfo] } 
  | % { 
    [pscustomobject]@{ 
      Name  = $_.FullName; 
      Count = (Measure-Object -InputObject (gci $_.FullName)).Count 
    } } 
  | ? { $_.Count -eq 0 } 
  | Select -ExpandProperty Name
}

function List-Functions() {
  Get-ChildItem function: | Where-Object { (-Not $_.Source) -AND ($_.HelpFile -notmatch "System\.Management") }
}

function List-FileSizes() {
  Get-ChildItem -Recurse | ForEach-Object (Measure-Object -InputObject $_ -Property Length -Sum -ErrorAction Stop).Sum / 1MB
}

function Reload-Profile() {
  . $profile
}

function Stop-Chrome() {
  taskkill /im chrome.exe /f
}

function Get-ProcessId($fileName) {
  Get-Process -FileVersionInfo -ErrorAction SilentlyContinue | % {
    $process = $_ 
    if ($_.FileName -like $fileName) {
      $process.Name + " PID:" + $process.Id    
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
  $packages = Get-ChildItem C:\ProgramData\chocolatey\lib\ -Recurse *.nuspec | select fullname, name 
  foreach ($p in $packages) {
    [xml]$xml = Get-Content $p.fullname
    $dependencies = $xml.package.metadata.dependencies.dependency
    if ($null -eq $dependencies) {  
      $obj = New-Object -TypeName psobject
      $obj | Add-Member -MemberType NoteProperty -name package -Value $xml.package.metadata.id
      $obj | Add-Member -MemberType NoteProperty -name packageversion -Value $xml.package.metadata.version
      $obj | Add-Member -MemberType NoteProperty -name dependency -Value ""
      $obj | Add-Member -MemberType NoteProperty -name dependencyversion -Value ""
      $obj
      continue
    }
    foreach($d in $dependencies){
      $obj = New-Object -TypeName psobject
      $obj | Add-Member -MemberType NoteProperty -name package -Value $xml.package.metadata.id
      $obj | Add-Member -MemberType NoteProperty -name packageversion -Value $xml.package.metadata.version
      $obj | Add-Member -MemberType NoteProperty -name dependency -Value $d.id
      $obj | Add-Member -MemberType NoteProperty -name dependencyversion -Value $d.version
      $obj
    }
  }
}

function Get-LocalChocoPackagesWithNoDependecies() {
  $allPackages = Get-ChocoPackagesWithDependencies
  $dependencyNames = $allPackages | Select-Object -ExpandProperty dependency | sort | Get-Unique
  $allPackageNames = $allPackages | Select-Object -ExpandProperty package | sort | Get-Unique

  $allPackageNames | ? { -not ($dependencyNames -contains $_) } | sort
}
