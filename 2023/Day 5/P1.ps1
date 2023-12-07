Param (
  $InputFile = (Join-Path $PSScriptRoot 'Input.txt')
)

$Data = Get-Content $InputFile

$Seeds = ($Data[0] | Select-String '\d+' -AllMatches).Matches.Value | ForEach-Object { [int64]$_ }
$Maps = @{}

for ($i = 2; $i -lt $Data.Count; $i++) {

  if ($Data[$i] -match ':') {

    $Map = $Data[$i]

  }
  elseif ($Data[$i] -match '^\d') {

    $Values = ($Data[$i] | Select-String '\d+' -AllMatches).Matches.Value | ForEach-Object { [int64]$_ }

    if (!$Maps.$Map) { $Maps.$Map = @() }
    
    $Maps.$Map += @{
      'Destination Start' = $Values[0]
      'Destination End'   = $Values[0] + $Values[2] - 1
      'Source Start'      = $Values[1]
      'Source End'        = $Values[1] + $Values[2] - 1
    }

  }
  
}

$Locations = @()
$MapsList = @(
  'seed-to-soil map:'
  'soil-to-fertilizer map:'
  'fertilizer-to-water map:'
  'water-to-light map:'
  'light-to-temperature map:'
  'temperature-to-humidity map:'
  'humidity-to-location map:'
)

for ($i = 0; $i -lt $Seeds.Count; $i++) {

  $Source = $Seeds[$i]

  foreach ($Map in $MapsList) {

    $Range = $Maps.$Map | Where-Object { $_.'Source Start' -le $Source -and $_.'Source End' -ge $Source }

    if ($null -ne $Range) {
      $Offset = $Source - $Range.'Source Start'
      $Destination = $Range.'Destination Start' + $Offset
    }
    else {
      $Destination = $Source
    }
    
    if ($Map -eq 'humidity-to-location map:') {
      $Locations += $Destination
    }
    else {
      $Source = $Destination
    }
  }

}

$Lowest = $Locations | Sort-Object | Select-Object -First 1

# Solution goes here
# Answer 1: 535088217

Write-Host "Answer: $Lowest"
