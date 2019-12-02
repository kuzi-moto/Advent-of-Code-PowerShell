param (
    $InputFile = ".\Input.txt"
  )
$Data = Get-Content $InputFile
while (!$Result) {
  $Primary = $Data[0].ToCharArray()
  foreach ($i in $Data) {
    $Secondary = $i.ToCharArray()
    $Index = 0
    $MatchedChars = $null
    $Max = $Primary.Length
    while ($Index -lt $Max) {
      if ($Primary[$Index] -eq $Secondary[$Index]) {
        $MatchedChars += $i[$Index]
      }
      $Index ++
    }
    if ($MatchedChars.Length -eq $Max - 1) {
      $Result = $MatchedChars
      break
    }
  }
  $Data = $Data[1..($Data.Length-1)]
}
Write-Host "letters in ID: $Result"