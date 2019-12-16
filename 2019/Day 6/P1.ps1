Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

$Map = @{ }

$Data | ForEach-Object {
  $_ -match '(\w+)\)(\w+)' | Out-Null
  $one = $Matches[1]
  $two = $Matches[2]
  if (!$Map.$One) { $Map.$one = $null }
  $Map.$two = $one
}

$Queue = @()

$Map.Clone().GetEnumerator() | Where-Object { !$_.Value } | ForEach-Object {
  $Queue += $_.Name
  $Map.Remove($_.Name)
}

$Counts = @{}
$Count = 1

do {
  $Map.Count
  $NewQueue = @()

  $Map.Clone().GetEnumerator() | Where-Object { $Queue -contains $_.Value } | ForEach-Object {
    $Satellite = $_.Name
    $Counts.$Satellite = $Count
    $NewQueue += $Satellite
    $Map.Remove($_.Name)
  }

  $Queue = $NewQueue.Clone()
  $Count++
} until ($Queue.Count -eq 0)

$Sum = 0
$Counts.Values | ForEach-Object {$Sum += $_ }

$Ans = $Sum

Write-Host "Total # of orbits: $Ans"
