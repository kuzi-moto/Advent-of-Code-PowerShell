Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

$GamesList = @()

for ($i = 0; $i -lt $Data.Count; $i++) {

  $DataSplit = $Data[$i] -split ':'

  $RoundsSplit = $DataSplit[1] -split ';'

  $Rounds = @()

  for ($ii = 0; $ii -lt $RoundsSplit.Count; $ii++) {

    $Round = @{}
    
    $RoundsSplit[$ii] -split ',' | ForEach-Object {

      $null = $_ -match '(\d+)\s(\w+)'
      $Round[$Matches[2]] = [int]$Matches[1]
    }

    $Rounds += $Round

  }

  $GamesList += , $Rounds

}

$Sum = 0

for ($i = 0; $i -lt $GamesList.Count; $i++) {

  if ($null -eq ($GamesList[$i] | Where-Object { $_.red -gt 12 -or $_.green -gt 13 -or $_.blue -gt 14 })) {
    $Sum += $i + 1
  }

}

# Solution goes here

Write-Host "Answer: $Sum"
