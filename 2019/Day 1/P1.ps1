Param (
  $InputFile = ".\TestInput.txt"
)

$Data = Get-Content $InputFile
$Sum = 0

$Data | ForEach-Object {
  $Sum += [System.Math]::Truncate(($_ / 3)) - 2
}

Write-Host "Sum of the fuel requirements: $Sum"