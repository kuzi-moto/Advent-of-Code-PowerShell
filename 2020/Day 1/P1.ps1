Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile | ForEach-Object { [int]$_ }

for ($i = 0; $i -lt $Data.Count; $i++) {
  for ($ii = $i+1; $ii -lt $Data.Count; $ii++) {
    $Sum = $Data[$i] + $Data[$ii]
    if ($Sum -eq 2020) {
      $Ans = $Data[$i] * $Data[$ii]
    }
  }
}

# Solution goes here

Write-Host "Answer: $Ans"
