Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

$SlidingWindow = @()

for ($i = 0; $i -lt $Data.Count-2; $i++) {

  $SlidingWindow += [int]$Data[$i] + [int]$Data[$i+1] + [int]$Data[$i+2]

}

$Count = 0

for ($i = 0; $i -lt $SlidingWindow.Count; $i++) {
  
  if ($SlidingWindow[$i] -gt $SlidingWindow[$i-1]) { $Count++ }

}

Write-Host "Answer: $Count"
