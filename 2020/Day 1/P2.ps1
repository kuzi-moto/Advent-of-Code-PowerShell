Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile | ForEach-Object { [int]$_ }

for ($i = 0; $i -lt $Data.Count - 2; $i++) {
  for ($ii = $i + 1; $ii -lt $Data.Count - 1; $ii++) {
    for ($iii = $ii + 1; $iii -lt $Data.Count; $iii++) {
      $Sum = $Data[$i] + $Data[$ii] + $Data[$iii]
      if ($Sum -eq 2020) {
        $Ans = $Data[$i] * $Data[$ii] * $Data[$iii]
      }
    }
  }
}

# Solution goes here

Write-Host "Answer: $Ans"
