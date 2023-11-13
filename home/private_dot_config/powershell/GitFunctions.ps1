function Set-RemoveBranchNoVerify {
  [Alias("pn")]
  param()
  Test-IsGitBranch
  git push --no-verify
}

function Show-Conflicts() {
  Test-IsGitBranch
  git diff --name-only --diff-filter=U
}

function Set-Branch {
  [Alias("gitc")]
  param($Param)
  Test-IsGitBranch
  git checkout $Param
}

function Update-Branch {
  [Alias("gitm")]
  param($Param)
  Test-IsGitBranch
  git merge $Param
}

function New-GitBranch {
  [Alias("pn")]
  param(
    [Switch]
    [Alias("n")]
    $NoVerify
  ) 
  Test-IsGitBranch
  "git push --set-upstream origin $(if ($NoVerify) { "--no-verify" }) $(git branch --show-current)" | Invoke-Expression 
}

function New-PullRequest {
  [Alias("npr")]
  param($Title, $Body)
  Test-IsGitBranch
  gh pr create --base main --title $Title --body $Body
}

function Get-MostRecentlyUpdatedGitBranches() {
  [Alias("mr")]
  param($Take = 5)

  Test-IsGitBranch

  $counter = 0;

  $results = git branch --sort=-committerdate
  $chunk = $results | Select-Object -first $Take
  $chunk.Split([Environment]::NewLine) | ForEach-Object { Write-Output "$counter $_"; $counter++ }
}

function Set-Branch {
  [Alias("sb")]
  param(
    [Parameter(Position = 0)]
    [Nullable[System.Int32]]
    [AllowNull()]
    $Index = $null
  )

  Test-IsGitBranch
  
  if ($null -eq $Index) {
    Write-Host "Please specify an index."
    return
  }
  
  git checkout (git branch --sort=-committerdate | Select-Object -index $Index).TrimStart()
}

function Remove-GitChanges {
  [Alias("grm")]
  param()

  Test-IsGitBranch
  
  git add -A
  git checkout -f
}

function Remove-OldGitBranches() {
  git branch | ForEach-Object {
    $branch = ($_ -replace "\*", "").TrimStart()
    if (!(git log -1 --since='16 weeks ago' -s $branch)) {
      git branch -D $branch
    }
  }
}

function New-GitCommit {
  <#
    .SYNOPSIS
      Add and commit changes to git and prepend SMART number.
    .DESCRIPTION
      When called with no paramaters will do a git -A. If called with a paramater
      it is the same as git commit -am but will use regex to get the SMART number
      from the name of the branch and prepend it to the commit message.
    .EXAMPLE
      add
      add "Fixing bug"
  #>
  [Alias("add")]
  param([String][AllowNull()]$Message)

  git add -A
  if ($null -ne $Message) {
    $found = (git branch --show-current) -match '(smart|ops)-\d+';
    if ($found) {
      $Message = $Matches[0].ToUpper() + ": " + $Message
    }

    git commit -m $Message
  }
}

function New-GitCommitAndPush {
  [Alias("addp")]
  param([String][AllowNull()]$Message)

  New-GitCommit -Message $Message
  git push
}

function Merge-Main {
  [Alias("mm")]
  param()

  function merge() {
    git checkout -f main
    git pull
    git checkout -
    git merge main
  }

  $status = git status

  if ((git status | Select-Object -Skip 1) -eq "nothing to commit, working tree clean") {
    merge
    return
  }

  $status
  Write-Host "Untracked files. Press enter to erase them and continue or any other key to cancel." -ForegroundColor Red
  $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  if ($key.VirtualKeyCode -eq 0x0D) {
    merge
  }
  else {
    Write-Host "Cancelled."
  }
}

function Test-IsGitBranch {
  if (git branch 2>&1 | Select-String "fatal: not a git repository") {
    throw [System.InvalidOperationException] "$PWD is not a git repository."
  }
}
