Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

function Write-Positions {

  $XRange = $Knots | ForEach-Object { $_.X } | Measure-Object -Maximum -Minimum
  $YRange = $Knots | ForEach-Object { $_.Y } | Measure-Object -Maximum -Minimum

  $NewXSize = $XRange.Maximum - $XRange.Minimum + 1
  $NewYSize = $YRange.Maximum - $YRange.Minimum + 1

  if ($NewXSize -gt $XSize) { $Global:XSize = $NewXSize }
  if ($NewYSize -gt $YSize) { $Global:YSize = $NewYSize }

  if ($XSize -le ($XRange.Maximum + $XOffset)) { $Global:XSize = $XRange.Maximum + $XOffset + 1 }
  if ($YSize -le ($YRange.Maximum + $YOffset)) { $Global:YSize = $YRange.Maximum + $YOffset + 1 }

  if ($XRange.Minimum -lt 0) { $XOffset = [System.Math]::Abs($XRange.Minimum) }
  else { $XOffset = 0 }

  if ($YRange.Minimum -lt 0) { $YOffset = [System.Math]::Abs($YRange.Minimum) }
  else { $YOffset = 0 }
  
  $KnotLayout = [Object[]]::new($YSize)

  for ($i = 0; $i -lt $KnotLayout.Count; $i++) {
    $KnotLayout[$i] = [Object[]]::new($XSize)

    for ($ii = 0; $ii -lt $KnotLayout[$i].Count; $ii++) {
      $KnotLayout[$i][$ii] = '.'
    }
  }

  $KnotLayout[$YOffset][$XOffset] = 's'

  for ($i = 0; $i -lt $Knots.Count; $i++) {
    $X = $Knots[$i].X + $XOffset
    $Y = $Knots[$i].Y + $YOffset

    if ($i -eq 0) {
      $Mark = 'H'
    }
    else {
      $Mark = "$i"
    }

    if ( $X -ne $PrevX -or $Y -ne $PrevY -or $i -eq 0 ) {
      try { $KnotLayout[$Y][$X] = $Mark }
      catch { throw $_ }
    }

    $PrevX = $X
    $PrevY = $Y
  
  }

  [array]::Reverse($KnotLayout)
  $KnotLayout | ForEach-Object { $_ -join '' }

}

$Data = Get-Content $InputFile

$TailPositions = @{ '0,0' = $true }
$XSize = 0
$YSize = 0

$Knots = @(
  @{X = 0; Y = 0 }
  @{X = 0; Y = 0 }
  @{X = 0; Y = 0 }
  @{X = 0; Y = 0 }
  @{X = 0; Y = 0 }
  @{X = 0; Y = 0 }
  @{X = 0; Y = 0 }
  @{X = 0; Y = 0 }
  @{X = 0; Y = 0 }
  @{X = 0; Y = 0 }
)

$TranslationTable = @{
  '-2,1'  = @{ X = -1; Y = 1 }
  '-2,2'  = @{ X = -1; Y = 1 }
  '-1,2'  = @{ X = -1; Y = 1 }
  '0,2'   = @{ X = 0; Y = 1 }
  '1,2'   = @{ X = 1; Y = 1 }
  '2,2'   = @{ X = 1; Y = 1 }
  '2,1'   = @{ X = 1; Y = 1 }
  '2,0'   = @{ X = 1; Y = 0 }
  '2,-1'  = @{ X = 1; Y = -1 }
  '2,-2'  = @{ X = 1; Y = -1 }
  '1,-2'  = @{ X = 1; Y = -1 }
  '0,-2'  = @{ X = 0; Y = -1 }
  '-1,-2' = @{ X = -1; Y = -1 }
  '-2,-2' = @{ X = -1; Y = -1 }
  '-2,-1' = @{ X = -1; Y = -1 }
  '-2,0'  = @{ X = -1; Y = 0 }
}

for ($i = 0; $i -lt $Data.Count; $i++) {
  $Instruction = $Data[$i] -split ' '

  $Steps = [int]$Instruction[1]

  for ($ii = 0; $ii -lt $Steps; $ii++) {

    # Move Head
    switch ($Instruction[0]) {
      'U' { $Knots[0].Y++; break }
      'D' { $Knots[0].Y--; break }
      'L' { $Knots[0].X--; break }
      'R' { $Knots[0].X++; break }
    }
    
    #Write-Positions
    #Write-Host ""

    for ($n = 1; $n -lt $Knots.Count; $n++) {
      $DX = $Knots[$n - 1].X - $Knots[$n].X
      $DY = $Knots[$n - 1].Y - $Knots[$n].Y
    
      # Determine if knot needs to be moved
      if ( [Math]::Abs($DX) -eq 2 -or [Math]::Abs($DY) -eq 2) {
        $Knots[$n].X += $TranslationTable.("$DX,$DY").X
        $Knots[$n].Y += $TranslationTable.("$DX,$DY").Y
        
        #Write-Positions
        #Write-Host ""
      }

      if ($DX -eq 0 -and $DY -eq 0) {
        $n = $Knots.Count
      }

    }

    # Mark tail position
    $TailPositions.("$($Knots[-1].X),$($Knots[-1].Y)") = $true

  }

}

$Count = $TailPositions.Count

Write-Host "Answer: $Count"
