Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt"),
  $InputInt = 5
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
  5  = 2
  6  = 2
  7  = 3
  8  = 3
  99 = 0
}

function Get-Value {
  param (
    [int]$Pointer,
    [int]$ParameterMode
  )
  switch ($ParameterMode) {
    0 { return $Program[$Program[$Pointer]]; break }
    1 { return $Program[$Pointer]; break }
    Default {
      Write-Host "Invalid Parameter Mode"
      return $null
    }
  }
}

# Opcodes
#   1 adds values of first and second parmeter, store location of 3rd parameter
#   2 multiplies values of first and second parameter, store in 3rd parameter
#   3 takes an integer as input, and saves it to the position of its parameter
#   4 outputs the value of its only parameter
#   5 if first parameter is non-zero, jump to position of second parameter
#   6 if first parameter is zero, jump to position of second parameter
#   7 if first parameter is less than second parameter, store '1' in third parameter, otherwise '0'
#   8 if first parameter is equal to second parameter, store '1' in third parameter, otherwise '0'
#   99 terminates
# position 1: position of first value to read
# position 2: position of second value to read
# position 3: position to store computed value
#
# after reading the first opcode (at position 0, step forward 4 positions, to 4)

# Parameter Modes
# 0: Position Mode - Parameters are interpreted as a position
# 1: Immediate Mode - Parameters are interpreted as values

$Pointer = 0
$Done = $false
while (!$Done) {
  $Instruction = $Program[$Pointer]
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
      $Value1 = Get-Value ($Pointer + 1) $ParameterModes[0]
      $Value2 = Get-Value ($Pointer + 2) $ParameterModes[1]

      $Program[$Program[$Pointer + 3]] = $Value1 + $Value2
      break
    }
    2 {
      $Value1 = Get-Value ($Pointer + 1) $ParameterModes[0]
      $Value2 = Get-Value ($Pointer + 2) $ParameterModes[1]

      $Program[$Program[$Pointer + 3]] = $Value1 * $Value2
      break
    }
    3 { $Program[$Program[$Pointer + 1]] = $InputInt; break }
    4 {
      $Output = Get-Value ($Pointer + 1) $ParameterModes[0]
      Write-Host "Output: $Output"
      break
    }
    5 {
      $Value1 = Get-Value ($Pointer + 1) $ParameterModes[0]

      if ($Value1 -ne 0) {
        $NewPointer = Get-Value ($Pointer + 2) $ParameterModes[1]
      }
      break
    }
    6 {
      $Value1 = Get-Value ($Pointer + 1) $ParameterModes[0]

      if ($Value1 -eq 0) {
        $NewPointer = Get-Value ($Pointer + 2) $ParameterModes[1]
      }
      break
    }
    7 {
      $Value1 = Get-Value ($Pointer + 1) $ParameterModes[0]
      $Value2 = Get-Value ($Pointer + 2) $ParameterModes[1]

      if ($Value1 -lt $Value2) {
        $Program[$Program[$Pointer + 3]] = 1
      }
      else {
        $Program[$Program[$Pointer + 3]] = 0
      }
      break
    }
    8 {
      $Value1 = Get-Value ($Pointer + 1) $ParameterModes[0]
      $Value2 = Get-Value ($Pointer + 2) $ParameterModes[1]

      if ($Value1 -eq $Value2) {
        $Program[$Program[$Pointer + 3]] = 1
      }
      else {
        $Program[$Program[$Pointer + 3]] = 0
      }
      break
    }
    99 { Write-Host "Terminating"; $Done = $true; break }
    Default { $Done = $true }
  }

  if ($NewPointer) {
    $Pointer = $NewPointer
    $NewPointer = $null
  }
  else {
    $Pointer += $OpCodes.$Opcode + 1
  }
}

Write-Host "last output is diagnostic code"