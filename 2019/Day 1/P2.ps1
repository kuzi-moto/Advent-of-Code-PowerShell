Param (
  $InputFile = ".\TestInput.txt"
)

$Data = Get-Content $InputFile
$TotalFuel = 0

$Data | ForEach-Object {
  $AdditionalFuel = [System.Math]::Truncate(($_ / 3)) - 2
  while ($AdditionalFuel -gt 0) {
    $TotalFuel += $AdditionalFuel
    $AdditionalFuel = [System.Math]::Truncate(($AdditionalFuel / 3)) - 2
  }
}

Write-Host "Sum of the fuel requirements: $TotalFuel"