Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile
$Program = @()
$Data.Split(',') | ForEach-Object { $Program += [int]$_ }

$Program[1] = 12
$Program[2] = 2

# Opcode
# position 0: 1, 2, or 99
#   1 adds values
#   2 multiplies values
#   99 terminates
# position 1: position of first value to read
# position 2: position of second value to read
# position 3: position to store computed value
#
# after reading the first opcode (at position 0, step forward 4 positions, to 4)

for ($i = 0; $i -lt $Program.Count; $i += 4) {
  $Start = $Program[$i]

  if ($Start -eq 99) {
    break
  }
  if ($Start -ne 1 -and $Start -ne 2) {
    break
  }

  $Value1 = $Program[$Program[$i + 1]]
  $Value2 = $Program[$Program[$i + 2]]
  $StoreAt = $Program[$i + 3]

  if ($Start -eq 1) {
    $NewValue = $Value1 + $Value2
  }
  else {
    $NewValue = $Value1 * $Value2
  }

  $Program[$StoreAt] = $NewValue
}

Write-Host "Position 0 value:" $Program[0]