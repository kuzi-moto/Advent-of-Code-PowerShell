Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

<# 
  First Column - Opponent:
  A - Rock
  B - Paper
  C - Scissors

  Second Column - Response:
  X - Rock
  Y - Paper
  Z - Scissors

  Score caclulated on shape + outcome:
  1 - Rock
  2 - Paper
  3 - Scissors

  0 - Loss
  3 - Draw
  6 - Win

  Possible Outcomes:
  R -> S -> P -> R
  1 -> 3 -> 2 -> 1
#>

$T = @{
  'A' = 1
  'B' = 2
  'C' = 3
  'X' = 1
  'Y' = 2
  'Z' = 3
}

$Outcome = @{
  -3 = 6
  -2 = 6
  -1 = 0
  0 = 3
  1 = 6
  2 = 0
}

$ScoreTotal = 0

<#
1 - 1 =  0 = tie
1 - 2 = -1 = lose
1 - 3 = -2 = win
2 - 1 =  1 = win
2 - 2 =  0 = tie
2 - 3 = -1 = lose
3 - 1 =  2 = lose
3 - 2 =  1 = win
3 - 3 =  0 = tie

-3 = win
-2 = lose
-1 = lose
 0 = tie
 1 = win
 2 = lose
#>

for ($i = 0; $i -lt $Data.Count; $i++) {
  $Round = $Data[$i].Split(" ")
  $P1 = $T.($Round[0])
  $P2 = $T.($Round[1])

  $ScoreTotal += $Outcome.($P2-$P1)
  $ScoreTotal += $P2

}

Write-Host "Answer: $ScoreTotal"