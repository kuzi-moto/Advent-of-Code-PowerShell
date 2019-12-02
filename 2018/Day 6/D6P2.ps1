Param (
  $InputFile = ".\TestInput.txt"
)

$Data = Get-Content $InputFile

$CoordList = New-Object 'System.Collections.Generic.List[System.Management.Automation.Host.Coordinates]'
$Data | ForEach-Object {
  $_ -match '(?<x>\d+),\s(?<y>\d+)' | Out-Null
  $CoordList.Add([System.Management.Automation.Host.Coordinates]::new([int]$Matches.x, [int]$Matches.y))
}

$MaxWidth = $CoordList.X | Sort-Object -Descending | Select-Object -First 1
$MinWidth = $CoordList.X | Sort-Object | Select-Object -First 1
$MaxHeight = $CoordList.Y | Sort-Object -Descending | Select-Object -First 1
$MinHeight = $CoordList.Y | Sort-Object | Select-Object -First 1

$Count = 0
for ($y = $MinHeight; $y -le $MaxHeight; $y++) {
  for ($x = $MinWidth; $x -le $MaxWidth; $x++) {
    $Distance = @{}
    for ($i = 0; $i -lt $CoordList.Count; $i++) {
      $Distance.$i = [Math]::Abs($x - $CoordList[$i].X) + [Math]::Abs($y - $CoordList[$i].Y)
    }
    if (($Distance.Values | Measure-Object -Sum).Sum -lt 10000) {$Count++}
  }
}

Write-Host "Region size: $Count"