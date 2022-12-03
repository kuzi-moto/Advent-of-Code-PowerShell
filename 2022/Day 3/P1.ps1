Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

function Get-LetterValue {
  param ($Char)

  if ($Char -le 90) { [int]$Char -38 }
  else { [int]$Char -96 } 
}

$Sum = 0

for ($i = 0; $i -lt $Data.Count; $i++) {
  $CompartmentSize = $Data[$i].Length / 2
  $C1 = $Data[$i].Substring(0, $CompartmentSize).ToCharArray()
  $C2 = $Data[$i].Substring($CompartmentSize).ToCharArray()
  $SameObject = (Compare-Object -ReferenceObject $C1 -DifferenceObject $C2 -IncludeEqual -ExcludeDifferent).InputObject | Select-Object -Unique
  $Sum += ($SameObject | ForEach-Object { Get-LetterValue $_ } | Measure-Object -Sum).Sum
}

Write-Host "Answer: $Sum"
