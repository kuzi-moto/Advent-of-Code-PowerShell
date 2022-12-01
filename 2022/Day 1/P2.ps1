Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

$Elves = @()

$Sum = 0
for ($i = 0; $i -lt $Data.Count; $i++) {
  
  if ($Data[$i]) {
    $Sum += $Data[$i]
  }
  else {
    $Elves += $Sum
    $Sum = 0
  }
}

$Elves += $Sum

Write-Host "Answer: $(($Elves | Sort-Object -Descending | Select-Object -First 3 | Measure-Object -Sum).Sum)"