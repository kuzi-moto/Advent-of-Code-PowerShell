Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

<# 
  First Column - Opponent:
  A - Rock
  B - Paper
  C - Scissors

  Second Column - Outcome:
  X - Lose
  Y - Tie
  Z - Win

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
}

$O = @{
  'X' = 0
  'Y' = 3
  'Z' = 6
}

$Map = @{
  1 = @{
    0 = 3
    3 = 1
    6 = 2
  }
  2 = @{
    0 = 1
    3 = 2
    6 = 3
  }
  3 = @{
    0 = 2
    3 = 3
    6 = 1
  }
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

 #>

for ($i = 0; $i -lt $Data.Count; $i++) {
  $Round = $Data[$i].Split(" ")
  $P1 = $T.($Round[0])
  $Outcome = $O.($Round[1])

  $P2 = $Map.$P1.$Outcome

  $ScoreTotal += $Outcome
  $ScoreTotal += $P2

}

Write-Host "Answer: $ScoreTotal"
