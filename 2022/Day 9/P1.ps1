Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

$TailPositions = @{ '0,0' = $true }

$HX = 0
$HY = 0
$TX = 0
$TY = 0
$TailTable = @{
  '-1,2'  = @{ X = -1; Y = 1 }
  '-2,1'  = @{ X = -1; Y = 1 }
  '0,2'   = @{ X = 0; Y = 1 }
  '1,2'   = @{ X = 1; Y = 1 }
  '2,1'   = @{ X = 1; Y = 1 }
  '2,0'   = @{ X = 1; Y = 0 }
  '2,-1'  = @{ X = 1; Y = -1 }
  '1,-2'  = @{ X = 1; Y = -1 }
  '0,-2'  = @{ X = 0; Y = -1 }
  '-1,-2' = @{ X = -1; Y = -1 }
  '-2,-1' = @{ X = -1; Y = -1 }
  '-2,0'  = @{ X = -1; Y = 0 }
}

for ($i = 0; $i -lt $Data.Count; $i++) {
  $Instruction = $Data[$i] -split ' '

  $Steps = [int]$Instruction[1]

  for ($ii = 0; $ii -lt $Steps; $ii++) {

    # Move Head
    switch ($Instruction[0]) {
      'U' { $HY++; break }
      'D' { $HY--; break }
      'L' { $HX--; break }
      'R' { $HX++; break }
    }

    $DX = $HX - $TX
    $DY = $HY - $TY

    # Determine if tail needs to be moved
    # Mark tail position if moved
    if ( [Math]::Abs($DX) -eq 2 -or [Math]::Abs($DY) -eq 2) {
      $TX += $TailTable.("$DX,$DY").X
      $TY += $TailTable.("$DX,$DY").Y
      $TailPositions.("$TX,$TY") = $true
    }

  }

}

$Count = $TailPositions.Count

Write-Host "Answer: $Count"
