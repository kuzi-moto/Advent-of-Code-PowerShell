Param (
  $InputFile = ".\TestInput.txt"
)

$Data = Get-Content $InputFile

$Depends = @{}
$Data | ForEach-Object {
  $_ -match 'Step\s(?<parent>\w)\smust\sbe\sfinished\sbefore\sstep\s(?<child>\w)\scan\sbegin\.' | Out-Null
  if (!$Depends.$($Matches.child)) {$Depends.$($Matches.child) = @()}
  $Depends.$($Matches.child) += $Matches.parent
}

$NoChildren = @()
$NoChildren += $Depends.Values | ForEach-Object {$_} | Where-Object {$Depends.Keys -notcontains $_}
$NoChildren | ForEach-Object {$Depends.$_ = @()}

$StepsArr = @()
do {
  $Ready = $Depends.GetEnumerator() | Select-Object -Property Name,Value,@{Name="Count"; Expression={$_.Value.Count}} | Sort-Object -Property Name | Where-Object -Property Count -Value 0 -EQ | Select-Object -First 1
  $Ready | ForEach-Object {
    $Step = $_.Name
    $StepsArr += $Step
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
} while ($Depends.Count -gt 0)

Write-Host "Steps Order: $($StepsArr -join '')"