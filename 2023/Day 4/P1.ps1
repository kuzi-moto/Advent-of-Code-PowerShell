Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile
$Sum = 0

for ($i = 0; $i -lt $Data.Count; $i++) {
  $Game = ($Data[$i] -split ':')[1]
  $Numbers = $Game -split '\|'
  $Points = 0

  [array]$WinningNums = ($Numbers[0] | Select-String '\d+' -AllMatches).Matches.Value | ForEach-Object { [int]$_ }
  [array]$MyNums = ($Numbers[1] | Select-String '\d+' -AllMatches).Matches.Value | ForEach-Object { [int]$_ }

  $MatchingNums = Compare-Object -ReferenceObject $WinningNums -DifferenceObject $MyNums -ExcludeDifferent | Select-Object -ExpandProperty InputObject

  for ($ii = 0; $ii -lt $MatchingNums.Count; $ii++) {
    if ($ii -eq 0) {
      $Points = 1
    }
    else {
      $Points *= 2
    }
  }

  $Sum += $Points

}

# Solution goes here
# Answer 1: 27059

Write-Host "Answer: $Sum"
