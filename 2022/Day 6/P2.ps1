Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

for ($i = 0; $i -lt $Data.Length; $i++) {
  
  if (($Data[$i..($i+13)] | Sort-Object -Unique).Count -eq 14){
    $Marker = $i + 14
    $i = $Data.Length
  }
  
}

# Solution goes here

Write-Host "Answer: $Marker"
