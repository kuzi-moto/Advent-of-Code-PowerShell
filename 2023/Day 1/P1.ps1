Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile
$Values = @()

for ($i = 0; $i -lt $Data.Count; $i++) {
  $Digits = $Data[$i].ToCharArray() -match '\d'
  $Values += [int]($Digits[0] + $Digits[-1])
}

$Sum = $Values | Measure-Object -Sum | Select-Object -ExpandProperty Sum

# Solution goes here

Write-Host "Answer: $Sum"
