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

$IsVisible = @{}
$Max = $TreeLayout.Count - 1

# Top > Down

for ($X = 0; $X -lt $TreeLayout.Count; $X++) {
  $Tallest = -1
  for ($Y = $Max; $Y -ge 0; $Y--) {
    $Tree = $TreeLayout[$X][$Y]
    if ($Tree -gt $Tallest) {
      $IsVisible.("$X,$Y") = $true
      $Tallest = $Tree
    }
    
  }
}

# Bottom > Up

for ($X = 0; $X -lt $Max; $X++) {
  $Tallest = -1
  for ($Y = 0; $Y -le $Max; $Y++) {
    $Tree = $TreeLayout[$X][$Y]
    if ($Tree -gt $Tallest) {
      $IsVisible.("$X,$Y") = $true
      $Tallest = $Tree
    }
    
  }
}

# Left > Right

for ($Y = 0; $Y -le $Max; $Y++) {
  $Tallest = -1
  for ($X = 0; $X -le $Max; $X++) {
    $Tree = $TreeLayout[$X][$Y]
    if ($Tree -gt $Tallest) {
      $IsVisible.("$X,$Y") = $true
      $Tallest = $Tree
    }
    
  }
}

# Right > Left

for ($Y = 0; $Y -le $Max; $Y++) {
  $Tallest = -1
  for ($X = $max; $X -ge 0; $X--) {
    $Tree = $TreeLayout[$X][$Y]
    if ($Tree -gt $Tallest) {
      $IsVisible.("$X,$Y") = $true
      $Tallest = $Tree
    }
    
  }
}

$Visible = $IsVisible.Count

Write-Host "Answer: $Visible"
