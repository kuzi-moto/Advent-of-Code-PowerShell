Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile


$Objects = @()
# https://stackoverflow.com/a/43083644
#$Map = @($null) * ($Data.Length + 1)
$Map = @{ }

# Get a list of all orbits, and create a map using the index of the objects position in array
$Data | ForEach-Object {
  $_ -match '(\w+)\)(\w+)' | Out-Null
  $one = $Matches[1]
  $two = $Matches[2]
  if ($Objects.IndexOf($one) -lt 0) { $Objects += $one }
  if ($Objects.IndexOf($two) -lt 0) { $Objects += $two }
  $IndexOne = $Objects.IndexOf($one)
  $IndexTwo = $Objects.IndexOf($two)
  #$Map[$IndexTwo] = $IndexOne
  if (!$Map.$IndexOne) { $Map.$IndexOne = @($IndexTwo) }
  else { $Map.$IndexOne += $IndexTwo }
}

$Queue = @()
$AllSatellites = @()
$Map.Values | ForEach-Object { $AllSatellites += $_ }

# Get the index for the object that doesn't orbit any other object
for ($i = 0; $i -lt $Objects.Count; $i++) {
  if ($AllSatellites -notcontains $i) { $Queue += $i }
}

$Counts = @{ }
$Count = 1

do {
  $NewQueue = @()

  for ($i = 0; $i -lt $Queue.Count; $i++) {
    $Map.($Queue[$i]) | Where-Object { $null -ne $_ } | ForEach-Object {
      $Counts.$_ = $Count
      $NewQueue += $_
    }
  }

  <#   $Map.Clone().GetEnumerator() | Where-Object { $Queue -contains $_.Value } | ForEach-Object {
    $Satellite = $_.Name
    $Counts.$Satellite = $Count
    $NewQueue += $Satellite
    $Map.Remove($_.Name)
  } #>

  $Queue = $NewQueue.Clone()
  $Count++
} until ($Queue.Count -eq 0)

$Ans = 0
$Counts.Values | ForEach-Object { $Ans += $_ }

Write-Host "Total # of orbits: $Ans"
