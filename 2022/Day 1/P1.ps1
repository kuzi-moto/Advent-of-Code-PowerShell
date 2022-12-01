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

Write-Host "Answer: $(($Elves | Measure-Object -Maximum).Maximum)"
