Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

$Count = 0

for ($i = 0; $i -lt $Data.Count; $i++) {
  if ($Data[$i] -gt $Data[$i-1]) {
    $Count++
  }
}

Write-Host "Answer: $Count"
