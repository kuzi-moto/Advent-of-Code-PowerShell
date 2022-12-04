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

for ($i = 0; $i -lt $Data.Count; $i=$i+3) {
  $Sack1 = $Data[$i].ToCharArray()
  $Sack2 = $Data[$i+1].ToCharArray()
  $Sack3 = $Data[$i+2].ToCharArray()
  $Compare = (Compare-Object -ReferenceObject $Sack1 -DifferenceObject $Sack2 -IncludeEqual -ExcludeDifferent).InputObject
  $SameObject = (Compare-Object -ReferenceObject $Compare -DifferenceObject $Sack3 -IncludeEqual -ExcludeDifferent).InputObject

  $Sum += Get-LetterValue $SameObject[0]
}

Write-Host "Answer: $Sum"
