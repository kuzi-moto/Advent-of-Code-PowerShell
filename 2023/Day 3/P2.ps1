Param (
  $InputFile = (Join-Path $PSScriptRoot 'Input.txt')
)

$Data = Get-Content $InputFile
$GearTable = @{}
$Sum = 0

for ($i = 0; $i -lt $Data.Count; $i++) {

  $Numbers = $Data[$i] | Select-String '\d+' -AllMatches | Select-Object -ExpandProperty Matches

  for ($ii = 0; $ii -lt $Numbers.Count; $ii++) {

    $YMin = $i - 1
    $YMax = $i + 1

    for ($Y = $YMin; $Y -le $YMax; $Y++) {
      
      if ($Y -lt 0) { continue }
      if ($Y -ge $Data.Count) { continue }

      $XMin = $Numbers[$ii].Index - 1
      $XMax = $Numbers[$ii].Index + $Numbers[$ii].Length

      for ($X = $XMin; $X -le $XMax; $X++) {
        
        if ($X -lt 0) { continue }
        if ($X -gt $Data[$i].Length) { continue }

        if ($Data[$Y][$X] -match '\*') {

          if (!$GearTable."$X,$Y") {
            $GearTable."$X,$Y" = @()
          }

          $GearTable."$X,$Y" += [int]$Numbers[$ii].Value

        }

      }

    }

  }

}

$GearTable.GetEnumerator() | ForEach-Object {

  if ($_.Value.Count -eq 2) {
    $Sum += $_.Value[0] * $_.Value[1]
  }

}

# Solution goes here
# Attempt 1: 79613331

Write-Host "Answer: $Sum"
