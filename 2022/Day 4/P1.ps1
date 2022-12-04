Param (
  $InputFile = (Join-Path $PSScriptRoot "Input.txt")
)

$Data = Get-Content $InputFile

<#

How many pairs in which one assignment set fully contains the other

#>

function Get-Array {
  param ( $Value )

  $null = $Value -match '(\d+)-(\d+)'
  [int]$Matches[1]..[int]$Matches[2]

}

$Count = 0

for ($i = 0; $i -lt $Data.Count; $i++) {
  $Pair = $Data[$i].Split(',')
  $A = Get-Array $Pair[0]
  $B = Get-Array $Pair[1]
  $Comparison = Compare-Object -ReferenceObject $A -DifferenceObject $B
  if (($Comparison.SideIndicator | Select-Object -Unique).Count -eq 1) {
    $Count++
  }
  elseif ($Comparison.Count -eq 0) {
    $Count++
  }
}

Write-Host "Answer: $Count"
