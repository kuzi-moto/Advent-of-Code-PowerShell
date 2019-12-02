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

for ($i = 0; $i -lt $PolymerArray.Count; $i++) {
  if ($PolymerArray[$i] + $PolymerArray[$i+1] -eq 0) {
    $PolymerArray.RemoveAt($i)
    $PolymerArray.RemoveAt($i)
    $i -= 2
  }
}

Write-Host "Answer: $($PolymerArray.Count) units remain"