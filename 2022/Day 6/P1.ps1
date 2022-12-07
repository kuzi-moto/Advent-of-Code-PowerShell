Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

for ($i = 0; $i -lt $Data.Length; $i++) {
  
  if (($Data[$i..($i+3)] | Sort-Object -Unique).Count -eq 4){
    $Marker = $i + 4
    $i = $Data.Length
  }
  
}

# Solution goes here

Write-Host "Answer: $Marker"
