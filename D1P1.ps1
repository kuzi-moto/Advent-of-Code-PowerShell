$InputFile = Get-Content $Args[0]
$Frequency = 0
foreach ($i in $InputFile) {
  $Frequency += [int]$i
}
Write-Host "Resulting frequency: $Frequency"