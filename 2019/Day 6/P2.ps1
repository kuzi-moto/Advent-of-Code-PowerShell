Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

$Objects = @()
$Map = @{ }
# https://stackoverflow.com/a/43083644
$Orbits = @($null) * ($Data.Length + 1)

# Get a list of all orbits, and create a map using the index of the objects position in array
$Data | ForEach-Object {
  $_ -match '(\w+)\)(\w+)' | Out-Null
  $one = $Matches[1]
  $two = $Matches[2]
  if ($Objects.IndexOf($one) -lt 0) { $Objects += $one }
  if ($Objects.IndexOf($two) -lt 0) { $Objects += $two }
  $IndexOne = $Objects.IndexOf($one)
  $IndexTwo = $Objects.IndexOf($two)
  if (!$Map.$IndexOne) { $Map.$IndexOne = @($IndexTwo) }
  else { $Map.$IndexOne += $IndexTwo }
  $Orbits[$IndexTwo] = $IndexOne
}

$StartIndex = $Objects.IndexOf("YOU")
$EndIndex = $Objects.IndexOf("SAN")
$StartPos = $Orbits[$StartIndex]
$EndPos = $Orbits[$EndIndex]

$Count = 0
$Traversed = @()
$Queue = @($StartPos)

do {
  $NewQueue = @()

  for ($i = 0; $i -lt $Queue.Count; $i++) {
    $Traversed += $Queue[$i]
    # Get satellites of object
    $Map.($Queue[$i]) | Where-Object { $null -ne $_ } | ForEach-Object {
      $NewQueue += $_
    }

    # Get planet that the object is orbiting
    $NewQueue += $Orbits[$Queue[$i]] | Where-Object { $null -ne $_ }
  }

  $Queue = $NewQueue.Clone() | Where-Object { $Traversed -notcontains $_ }
  $Count++
} until ($Queue -contains $EndPos)

Write-Host "Shortest # of orbital transfers: $Count"
