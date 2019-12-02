param (
    $InputFile = ".\Input.txt"
  )
$Data = Get-Content $InputFile
$Frequency = 0
foreach ($i in $Data) {
  $Frequency += [int]$i
}
Write-Host "Resulting frequency: $Frequency"