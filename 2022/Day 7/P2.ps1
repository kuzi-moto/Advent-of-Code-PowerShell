Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

function Write-Status {
  param ($Message, $Level)

  ' ' * ($Level * 2) + "- $Message" | Out-Host
  
}

function Get-DirSize {
    param ($Dir = '/')

    #Write-Status "Current directory: $Dir" $Level
  
    $DirSum = 0

    $FileTable | Where-Object { $_.Path -eq $Dir } | ForEach-Object {
      if ($_.size -gt 0) {
        #Write-Status "File: $($_.Name)" $Level
        $DirSum += $_.size
      }
      else {
        #Write-Status "Dir: $($_.Name)" $Level
        $Path = ($_.Path + '/' + $_.Name) -replace '//','/'
        $ChildDir = Get-DirSize $Path
        $DirSum += $ChildDir[-1].Size 
        $ChildDir
      }
    }

    [PSCustomObject]@{
      Dir = $Dir
      Size = $DirSum
    }

}

$Data = Get-Content $InputFile

$FileTable = @()
$Dir = ''
$ParentDir = [System.Collections.ArrayList]::new()

<#
1. Iterate through each line and determine if command or output
2. If command determine what command and action to take
3. if output make note of filename and size.
#>

for ($i = 0; $i -lt $Data.Count; $i++) {
  # iterate through each line

  if ($Data[$i] -match '\$ (\w+) ?(\S+)?') {
    # Line is a command

    $Parameter = $Matches[2]

    switch ($Matches[1]) {
      # Commands

      'cd' {
        if ($Parameter -match '\.\.') {
          $Dir = $ParentDir[-1]
          $ParentDir.RemoveAt($ParentDir.Count - 1)
        }
        else {
          $null = $ParentDir.Add($Parameter)
          $Dir = $Parameter
        }
      }
      'ls' {
        # Do nothing.
      }
    
    }

  }
  else {
    # Line is output

    $null = $Data[$i] -match '(\S+) (\S+)'

    $Match2 = $Matches[2]

    # First match signifies dir or filesize
    # Second match signifies dir name or file name

    switch -regex ($Matches[1]) {
      # Identify first part of output

      'dir' {
        # Is a directory
        $FileTable += [PSCustomObject]@{
          Name = $Match2
          ParentDir = $Dir
          Size = 0
          Path = $ParentDir -join '/' -replace '//','/'
        }
      }
      '\d+' {
        # Is a file
        $FileTable += [PSCustomObject]@{
          Name = $Match2
          ParentDir = $Dir
          Size = [int]$_
          Path = $ParentDir -join '/' -replace '//','/'
        }
      }
    
    }

  }

}

Write-Progress -Activity 'Reading input' -Completed

$DirectorySizes = Get-DirSize

$SpaceFree = (70000000 - ($DirectorySizes | Where-Object { $_.Dir -eq '/' }).Size)

$SpaceNeeded = 30000000 - $SpaceFree

for ($i = 0; $i -lt $array.Count; $i++) {
  <# Action that will repeat until the condition is met #>
}

$Ans = ($DirectorySizes | Sort-Object -Property Size | Where-Object { $_.Size -ge $SpaceNeeded })[0].Size

Write-Host "Answer: $Ans"

function Write-Message {
  param ($Message, $Level)

  ' ' * ($Level * 2) + "- $Message" | Out-Host
  
}

function Show-FileSystem {
  param ($Dir = '/', $Level = 1)

  Write-Message "Dir: $Dir" $Level

  $FileTable | Where-Object { $_.Path -eq $Dir } | Sort-Object -Property Size -Descending | ForEach-Object {
    if ($_.Size -gt 0) {
      Write-Message "File: $($_.Name)" ($Level + 1)
    }
    else {
      $Path = ($_.Path + '/' + $_.Name) -replace '//','/'
      Show-FileSystem $Path ($Level + 1)
    }
  }
  
}