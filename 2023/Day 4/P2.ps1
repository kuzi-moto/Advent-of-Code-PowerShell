Param (
  $InputFile = (Join-Path $PSScriptRoot 'Input.txt')
)

$Data = Get-Content $InputFile
$CardTable = @{}

for ($i = 0; $i -lt $Data.Count; $i++) {
  $CardTable.$i = 1
}

for ($i = 0; $i -lt $Data.Count; $i++) {

    $Game = ($Data[$i] -split ':')[1]
    $Numbers = $Game -split '\|'

    [array]$WinningNums = ($Numbers[0] | Select-String '\d+' -AllMatches).Matches.Value | ForEach-Object { [int]$_ }
    [array]$MyNums = ($Numbers[1] | Select-String '\d+' -AllMatches).Matches.Value | ForEach-Object { [int]$_ }

    $MatchCount = (Compare-Object -ReferenceObject $WinningNums -DifferenceObject $MyNums -ExcludeDifferent).Count

    for ($iii = 1; $iii -le $MatchCount; $iii++) {
      $Card = $i + $iii 
      $CardTable.$Card += $CardTable.$i
    }

  }

  $Sum = $CardTable.GetEnumerator() | ForEach-Object { $_.Value } | Measure-Object -Sum | Select-Object -ExpandProperty Sum

  # Solution goes here
  # Answer 1: 5744979

  Write-Host "Answer: $Sum"
