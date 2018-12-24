param (
  $InputFile = ".\Input.txt"
)
$Data = Get-Content $InputFile
$Claims = @()
$Data | ForEach-Object {
  $_ -match '#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)' | Out-Null
  $ClaimData = @{
    "ID"     = [Int]$Matches[1]
    "X"      = [Int]$Matches[2]
    "Y"      = [Int]$Matches[3]
    "Width"  = [Int]$Matches[4]
    "Height" = [Int]$Matches[5]
  }
  $Claims += $ClaimData
}
$Coordinates = @{}
$Number = 1
$Claims | ForEach-Object {
  $Number
  $XCoord = $_.X + 1
  $YCoord = $_.Y + 1
  while ($YCoord -lt $_.Y + $_.Height + 1) {
    while ($XCoord -lt $_.X + $_.Width + 1) {
      $Coordinates."$XCoord,$YCoord" ++
      $XCoord ++
    }
    $YCoord ++
    $XCoord = $_.X + 1
  }
  $Number ++
}
$Result = $Coordinates | ForEach-Object {$_.values -gt 1} | Measure-Object
Write-Host "Number of overlapping square inches: $Result"