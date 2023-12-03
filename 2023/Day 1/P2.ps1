Param (
  $InputFile = (Join-Path $PSScriptRoot 'TestInput.txt')
)

$Data = Get-Content $InputFile

$Table = @{
  'one'   = '1'
  'two'   = '2'
  'three' = '3'
  'four'  = '4'
  'five'  = '5'
  'six'   = '6'
  'seven' = '7'
  'eight' = '8'
  'nine'  = '9'
  'eno'   = '1'
  'owt'   = '2'
  'eerht' = '3'
  'rouf'  = '4'
  'evif'  = '5'
  'xis'   = '6'
  'neves' = '7'
  'thgie' = '8'
  'enin'  = '9'
}

$sum = 0

for ($i = 0; $i -lt $Data.Count; $i++) {

  $Num1 = ($Data[$i] | Select-String '\d|one|two|three|four|five|six|seven|eight|nine').Matches.Value | ForEach-Object {
    if ($_ -match '\D') { $Table.$_ } else { $_ }
  }

  $Reversed = -join $Data[$i][-1.. - ($Data[$i].Length)]

  $Num2 = ($Reversed | Select-String '\d|eno|owt|eerht|rouf|evif|xis|neves|thgie|enin').Matches.Value | ForEach-Object {
    if ($_ -match '\D') { $Table.$_ } else { $_ }
  }

  [int]$Value = $Num1 + $Num2

  $sum = $sum + $Value

}

# Solution goes here
# Answer 1: 53066 too low
# Answer 2: 53518 too high
# Answer 3: 53427 incorrect
# Answer 4: 53471 incorrect
# Answer 5: 53568

Write-Host "Answer: $Sum"
