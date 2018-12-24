param (
  $InputFile = ".\Input.txt"
)
$InputData = Get-Content $InputFile
$Values = @()
$Values += $InputData | ForEach-Object {[Int]$_}
$Frequency = 0
$Count = @{}
while (!$Result) {
  foreach ($i in $Values) {
    $Frequency += $i
    if ($Count.ContainsKey($Frequency)) {
      $Result = $Frequency
      break
    }
    else {
      $Count.$Frequency = $null
    }
  }
}
Write-Host "Resulting frequency: $Result"