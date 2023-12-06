Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile
$Sum = 0

for ($i = 0; $i -lt $Data.Count; $i++) {

  $Numbers = $Data[$i] | Select-String '\d+' -AllMatches | Select-Object -ExpandProperty Matches

  for ($ii = 0; $ii -lt $Numbers.Count; $ii++) {

    $YMin = $i - 1
    $YMax = $i + 1
    $AdjacentValues = @()

    for ($Y = $YMin; $Y -le $YMax; $Y++){
      
      if ($Y -lt 0) { continue }
      if ($Y -ge $Data.Count) {continue}

      $XMin = $Numbers[$ii].Index - 1
      $XMax = $Numbers[$ii].Index + $Numbers[$ii].Length

      for ($X = $XMin; $X -le $XMax; $X++) {
        
        if ($X -lt 0) { continue }
        if ($X -gt $Data[$i].Length) { continue }

        $AdjacentValues += $Data[$Y][$X] | Where-Object { $_ -match '\D' }

      }

    }

    if ($AdjacentValues -match '[^\.]') {
      $Sum += [int]$Numbers[$ii].Value
    }

  }


}

# Solution goes here
# Attempt 1: 543867

Write-Host "Answer: $Sum"
