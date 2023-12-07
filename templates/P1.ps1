Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

for ($i = 0; $i -lt $Data.Count; $i++) {
  $Data[$i]
}

# Solution goes here
# Answer 1: 

Write-Host "Answer: "
