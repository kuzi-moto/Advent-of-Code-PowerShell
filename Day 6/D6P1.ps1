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

$Infinite = @{}
$Count = @{}
#$Line = @()
for ($y = $MinHeight; $y -le $MaxHeight; $y++) {
  for ($x = $MinWidth; $x -le $MaxWidth; $x++) {
    $Distance = @{}
    for ($i = 0; $i -lt $CoordList.Count; $i++) {
      $Distance.$i = [Math]::Abs($x - $CoordList[$i].X) + [Math]::Abs($y - $CoordList[$i].Y)
    }
    $Sorted = $Distance.GetEnumerator() | Sort-Object -Property Value
    if ($Sorted[0].Value -lt $Sorted[1].Value) {
      $ID = $Sorted[0].Key
      $Count.$ID++
      if ($y -eq $MinHeight -or $y -eq $MaxHeight -or $x -eq $MinWidth -or $x -eq $MaxWidth) {
        $Infinite.$ID = $true
      }
      #$Line += $ID
    }
    #else {$Line += -1}
  }
  #$Line -join "," | Out-File -FilePath ".\output.csv" -Append
  #$Line = @()
}

$Ans = ($Count.GetEnumerator() | Where-Object {$Infinite.Keys -notcontains $_.Name} | Sort-Object -Property Value -Descending | Select-Object -First 1).Value
Write-Host "The largest finite area is $Ans"