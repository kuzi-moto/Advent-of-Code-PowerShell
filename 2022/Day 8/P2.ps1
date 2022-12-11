Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

$TreeLayout = [Object[]]::new($Data[0].Length)

for ($i = 0; $i -lt $TreeLayout.Count; $i++) {
  $TreeLayout[$i] = [Object[]]::new($Data.Count)
}

# Build the TreeLayout array

for ($i = 0; $i -lt $Data.Count; $i++) {

  for ($ii = 0; $ii -lt $Data[$i].Length; $ii++) {
    $TreeLayout[$ii][($Data.Count - 1 - $i)] = [int][string]$Data[$i][$ii]
  }

}

$MaxScore = 0
$Max = $TreeLayout.Count - 1

for ($X = 1; $X -lt $Max; $X++) {
  
  for ($Y = 1; $Y -lt $Max; $Y++) {

    $TreeHeight = $TreeLayout[$X][$Y]

    $Up = 0
    $Down = 0
    $Left = 0
    $Right = 0

    for ($Y2 = ($Y + 1); $Y2 -le $Max; $Y2++) {
      $Up++
      if ($TreeLayout[$X][$Y2] -ge $TreeHeight) {
        $Y2 = $Max + 1
      }
    }

    for ($Y2 = ($Y - 1); $Y2 -ge 0; $Y2--) {
      $Down++
      if ($TreeLayout[$X][$Y2] -ge $TreeHeight) {
        $Y2 = -1
      }
    }

    for ($X2 = ($X - 1); $X2 -ge 0; $X2--) {
      $Left++
      if ($TreeLayout[$X2][$Y] -ge $TreeHeight) {
        $X2 = -1
      }
    }

    for ($X2 = ($X + 1); $X2 -le $Max; $X2++) {
      $Right++
      if ($TreeLayout[$X2][$Y] -ge $TreeHeight) {
        $X2 = $Max + 1
      }
    }

    $ScenicScore = $Up * $Down * $Left * $Right
    if ($ScenicScore -gt $MaxScore) { $MaxScore = $ScenicScore }
  }

}

Write-Host "Answer: $MaxScore"
