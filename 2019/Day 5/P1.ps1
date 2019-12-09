Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt"),
  $InputInt = 1
)

$Data = Get-Content $InputFile
$Program = @()
$Data.Split(',') | ForEach-Object { $Program += [int]$_ }

# Valid opcodes, with required # of parameters
$OpCodes = @{
  1  = 3
  2  = 3
  3  = 1
  4  = 1
  99 = 0
}

function Get-Value {
  param (
    [int]$Position,
    [int]$ParameterMode
  )
  if ($ParameterMode -eq 0) {
    return $Program[$Program[$Position]]
  }
  elseif ($ParameterMode -eq 1) {
    return $Program[$Position]
  }
  else {
    Write-Host "Invalid Parameter Mode"
    return $null
  }
}

# Opcodes
# position 0: 1, 2, 3, 4, 99
#   1 adds values
#   2 multiplies values
#   3 takes an integer as input, and saves it to the position of its parameter
#   4 outputs the value of its only parameter
#   99 terminates
# position 1: position of first value to read
# position 2: position of second value to read
# position 3: position to store computed value
#
# after reading the first opcode (at position 0, step forward 4 positions, to 4)

# Parameter Modes
# 0: Position Mode - Parameters are interpreted as a position
# 1: Immediate Mode - Parameters are interpreted as values

$Position = 0
$Done = $false
while (!$Done) {
  Write-Host "Position $Position"
  $Instruction = $Program[$Position]
  $ParameterModes = @()

  if ($Instruction -gt 99) {
    $IntString = [string]$Instruction
    [int]$Opcode = $IntString[0 - 2] + $IntString[0 - 1]
    for ($i = $IntString.Length - 3; $i -gt -1; $i--) {
      $ParameterModes += [int][string]$IntString[$i]
    }
  }
  else { $Opcode = $Instruction }

  while ($ParameterModes.Count -lt $Opcodes.$Opcode) {
    $ParameterModes += 0
  }

  switch ($Opcode) {
    1 {
      $Value1 = Get-Value ($Position + 1) $ParameterModes[0]
      $Value2 = Get-Value ($Position + 2) $ParameterModes[1]

      $Program[$Program[$Position + 3]] = $Value1 + $Value2
      break
    }
    2 {
      $Value1 = Get-Value ($Position + 1) $ParameterModes[0]
      $Value2 = Get-Value ($Position + 2) $ParameterModes[1]

      $Program[$Program[$Position + 3]] = $Value1 * $Value2
      break
    }
    3 { $Program[$Program[$Position + 1]] = $InputInt; break }
    4 {
      $Output = Get-Value ($Position + 1) $ParameterModes[0]
      Write-Host "Output: $Output"
      break
    }
    99 { Write-Host "Terminating" }
    Default { $Done = $true }
  }

  $Position += $OpCodes.$Opcode + 1
}

Write-Host "last output is diagnostic code"