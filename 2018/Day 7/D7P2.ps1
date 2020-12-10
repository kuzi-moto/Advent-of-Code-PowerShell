Param (
  $InputFile = ".\TestInput.txt"
)

$Data = Get-Content $InputFile

$Depends = @{}
$Data | ForEach-Object {
  $_ -match 'Step\s(?<parent>\w)\smust\sbe\sfinished\sbefore\sstep\s(?<child>\w)\scan\sbegin\.' | Out-Null
  if (!$Depends.$($Matches.child)) {$Depends.$($Matches.child) = @()}
  if (!$Depends.$($Matches.parent)) {$Depends.$($Matches.parent) = @()}
  $Depends.$($Matches.child) += $Matches.parent
}

$Workers = @()
1..2 | ForEach-Object {
  $Workers += @{
    Step = $null
    Ends = $null
  }
}
$Time = 0
do {
  $FreeWorkers = $Workers | Where-Object {!$_.Step}
    if ($FreeWorkers -gt 0) {
      $Ready = $Depends.GetEnumerator() | Select-Object -Property Name,Value,@{Name="Count"; Expression={$_.Value.Count}},@{Name="Time"; Expression={[int][char]$_.Name -64}} | Where-Object -Property Count -Value 0 -EQ | Sort-Object -Property Time
      $Ready | ForEach-Object {
        $Step = $_.Name
        for ($i = 0; $i -lt $FreeWorkers.Count; $i++){
          
        }
      }
    }


  $Ready | ForEach-Object {
    $Step = $_.Name

    $Depends.Remove($Step)
    $Changes = @{}
    $Depends.GetEnumerator() | ForEach-Object {
      if ($_.Value -contains $Step){
        $Child = $_.Name
        $Changes.$Child = @()
        $Changes.$Child += $_.Value | Where-Object {$_ -ne $Step}
      }
    }
    $Changes.GetEnumerator() | ForEach-Object {$Depends.$($_.Name) = $_.Value}
  }
  $Time++
} while ($Depends.Count -gt 0)

Write-Host "Steps Order: $($StepsArr -join '')"