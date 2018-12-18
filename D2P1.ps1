$InputFile = Get-Content $Args[0]
foreach ($i in $InputFile) {
  $Count = @{}
  foreach ($letter in $i.GetEnumerator()) {
    $Count.$letter += 1
  }
  if ($Count.ContainsValue(2)) {$TwoCount += 1}
  if ($Count.ContainsValue(3)) {$ThreeCount += 1}
}
Write-Host "Checksum:" ($TwoCount * $ThreeCount)