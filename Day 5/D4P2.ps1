Param (
  $InputFile = ".\TestInput.txt"
)

$Data = Get-Content $InputFile

[System.Collections.ArrayList]$PolymerArray = $Data.ToCharArray() | ForEach-Object {
  $AsciiCode = [int][char]$_
  if ($AsciiCode -ge 65 -and $AsciiCode -le 90) {
    $AsciiCode
  }
  else {
    - ($AsciiCode - 32)
  }
}

$Results = @()
for ($i = 65; $i -le 90; $i++) {
  [System.Collections.ArrayList]$WorkingArray = $PolymerArray.Clone()
  while ($WorkingArray -contains $i -or $WorkingArray -contains -$i) {
    $WorkingArray.Remove($i)
    $WorkingArray.Remove(-$i)
  }
  for ($ii = 0; $ii -lt $WorkingArray.Count; $ii++) {
    if ($WorkingArray[$ii] + $WorkingArray[$ii+1] -eq 0) {
      $WorkingArray.RemoveRange($ii, 2)
      $ii -= 2
      if ($ii -eq -2) { $ii = -1}
    }
  }
  $Results += $WorkingArray.Count
}

$Answer = $Results | Sort-Object | Select-Object -First 1

Write-Host "Answer: The shortest polymer is $Answer units long"