param (
    $InputFile = ".\Input.txt"
  )
$Data = Get-Content $InputFile
foreach ($i in $Data) {
  $Count = @{}
  foreach ($letter in $i.GetEnumerator()) {
    $Count.$letter += 1
  }
  if ($Count.ContainsValue(2)) {$TwoCount += 1}
  if ($Count.ContainsValue(3)) {$ThreeCount += 1}
}
Write-Host "Checksum:" ($TwoCount * $ThreeCount)