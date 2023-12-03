Param (
  $InputFile = (Join-Path $PSScriptRoot "TestInput.txt")
)

$Data = Get-Content $InputFile

<#
addx V - two cycles, 'x' register increated by value 'v'
noop takes one cycle
#>

$X = 1
$Cycle = 0
$SignalStrengths = @()
$SignalCycle = 20

for ($i = 0; $i -lt $Data.Count; $i++) {
  
  $Null = $Data[$i] -match '^(addx|noop)\s?(-?\d+)?$'

  if ($Matches[1] -eq 'noop') {
    $AddCycles = 1
    $V = 0
  }
  else {
    $AddCycles = 2
    $V = [int]$Matches[2]
  }

  for ($c = 0; $c -lt $AddCycles; $c++) {
    
    $Cycle++

    if ($c -eq 1) { $X += $V; Write-Host "V: $V" }

    if ($Cycle -eq $SignalCycle) {

      Write-Host "Cycle: $Cycle | X: $X | Value: $($Cycle * $X)"
      $SignalStrengths += ($Cycle * $X)
      $SignalCycle += 40
      
    }
  
  }

}

$Sum = ($SignalStrengths | Measure-Object -Sum).Sum

# 14320 too high

Write-Host "Answer: $Sum"
