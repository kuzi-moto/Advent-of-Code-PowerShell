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

  $red = $GamesList[$i].red | Sort-Object | Select-Object -Last 1
  $green = $GamesList[$i].green | Sort-Object | Select-Object -Last 1
  $blue = $GamesList[$i].blue | Sort-Object | Select-Object -Last 1

  $sum += $red * $green * $blue

}

# Solution goes here

Write-Host "Answer: $Sum"
